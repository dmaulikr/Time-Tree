//
//  ContainerVC.m
//  TimeTree
//
//  Created by Joseph on 2015/8/18.
//  Copyright (c) 2015年 dosomethingq. All rights reserved.
//

#import "ContainerVC.h"
#import "NavigationVC.h"
#import "popVC.h"
#import "Parse/Parse.h"
#import "CatalogueTableVC.h"
#import "data.h"
#import "MenuTableViewController.h"
#import "TimeTreeTableVC.h"
#import "DataTimeTreeObj.h"
#import "MBProgressHUD.h"
#import "ContentVC.h"
#import "DataTreeContentObj.h"
#import "Utility.h"

static ContainerVC *_containerVC=nil;

@interface ContainerVC ()
{
    //    PFObject *timeTreeObj;
    PFObject *treeContent;
    data *dataClass;
}
@property (strong,nonatomic) PFUser *user;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (strong,nonatomic) NSMutableArray *totalTreeArray;  //timeTreeObj 只有用到->樹的數量,有加循迴
@property (strong,nonatomic) NSMutableArray *vcArray; // array 裡裝各個tableView controller ,vc裡是樹的內容

@property (strong,nonatomic) NSArray *treeObjArray; // 只有用到->樹的數量,無加循迴
@property (strong,nonatomic) NSMutableArray *contentArray; // 樹的內容陣列

@property (assign,nonatomic) NSInteger scrollIndex; // 滑到到頁籤

@end

@implementation ContainerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _containerVC=self;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:(NavigationVC*)self.navigationController
                                                                            action:@selector(showMenu)];
    // years btn in navigation bar
    UIButton *yearsBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 40)];
    [yearsBtn addTarget:self action:@selector(yearSelector:) forControlEvents:UIControlEventTouchUpInside];
    [yearsBtn setBackgroundColor:[UIColor blackColor]];
    [yearsBtn setTitle:@"1995" forState:UIControlStateNormal];
    UIBarButtonItem *years=[[UIBarButtonItem alloc]initWithCustomView:yearsBtn];
    UIBarButtonItem *leftFixedItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    leftFixedItem.width = self.view.frame.size.width/2-42-30;
    
    // add tree or event button
    UIButton *addBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [addBtn addTarget:self action:@selector(addTree:) forControlEvents:UIControlEventTouchUpInside];
    [addBtn setBackgroundColor:[UIColor blackColor]];
    [addBtn setTitle:@"＋" forState:UIControlStateNormal];
    UIBarButtonItem *add=[[UIBarButtonItem alloc]initWithCustomView:addBtn];
    self.navigationItem.rightBarButtonItems=@[add,leftFixedItem,years];
    
    // PFUser
    self.user=[PFUser currentUser];
    
    self.contentArray=[[NSMutableArray alloc]initWithCapacity:0];
    
    
    // get tree obj data , TscrollView 頭尾加入 供無限循環
    [self getTreeObjData];
    
    // scrollView delegate
    self.scrollView.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

+(ContainerVC*)currentInstance{
    return _containerVC;
}

-(void)getTreeObjData{
    
    __weak ContainerVC *this=self;
    dataClass=[[data alloc]init];
    dataClass.dataBlock=^(NSArray *treeObjArray){
        dispatch_async(dispatch_get_main_queue(), ^{
            // init
            this.totalTreeArray=[[NSMutableArray alloc]initWithArray:treeObjArray];
            this.treeObjArray=[NSArray arrayWithArray:treeObjArray];
            
            if (treeObjArray.count>=2) {
                //TreeScrollView
                //頭尾加入 供無限循環
                DataTimeTreeObj *firstTree = treeObjArray[0];
                DataTimeTreeObj *lastTree = treeObjArray[treeObjArray.count-1];
                [this.totalTreeArray insertObject:lastTree atIndex:0];
                [this.totalTreeArray insertObject:firstTree atIndex:this.totalTreeArray.count];
                NSLog(@"TimeTreeObj 頭尾加入，循環 count is %lu",(unsigned long)this.totalTreeArray.count);
            }
            
            [this getContentData:this.totalTreeArray]; //傳入dataTimeTreeObj物件的Array (循環)
            
        });
    };
    
    dataClass.loadDataFail=^(NSError *error){
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:@"Fetch data fail,Please try again later!" delegate:this cancelButtonTitle:@"OK" otherButtonTitles:nil];
        NSLog(@"get TimeTreeObj fail in parse , error is %@",error.description);
        [av show];
    };
    [dataClass findTreeObjViaUser];
}

-(void)scrollViewSetup:(NSInteger)x{
    
    NSLog(@"scrollView setup start");
    
    CGFloat scrollWidth=self.scrollView.frame.size.width;
    CGFloat scrollHeight=self.scrollView.frame.size.height;
    
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    
    //ScrollView
    self.scrollView.contentSize = CGSizeMake(scrollWidth*self.vcArray.count, scrollHeight);
    
    for (NSInteger i=0; i<self.vcArray.count; i++) {
        TimeTreeTableVC *vc = self.vcArray[i];
        vc.view.frame = CGRectMake(scrollWidth*i, 0, scrollWidth, self.scrollView.frame.size.height);
        [self.scrollView addSubview:vc.view];
    }
    //起始位置
    [self.scrollView scrollRectToVisible:CGRectMake(scrollWidth*x, 0, scrollWidth,scrollHeight) animated:NO];
    
}


-(void)getContentData:(NSArray*)totalTreeObjArray{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=@"loading";
    [hud show:YES];
    
    //先取樹內容全部 in parse tree content
    PFQuery *pq=[PFQuery queryWithClassName:@"treeContent"];
    [pq whereKey:@"user" equalTo:self.user];
    [pq findObjectsInBackgroundWithBlock:^(NSArray *allContentArray,NSError *err){
        //        NSLog(@"allContentsArra--no filter Array--%lu",allContentArray.count);
        
        if (err) {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:@"Fetch data fail,Please try again later!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            NSLog(@"get all treeContent fail in parse , error is %@",err.description);
            [av show];
        }
        
        if (allContentArray.count!=0) {
            //排除相同的content_Obj(為關聯到TimeTreeObj的物件) 在parse treeContent
            NSArray *filterArray=[Utility arrayWithoutDuplicates:allContentArray];
            //        NSLog(@"filterArray %lu",filterArray.count);
            
            for (__block NSInteger i=0; i<filterArray.count; i++) {
                
                // 搜尋，條件是key:content_Obj 是否等於 PFObject "relativeContentObj" ,一對多方式去找是否一樣的樹名
                PFObject *relativeContentObj=filterArray[i];
                PFQuery *query = [PFQuery queryWithClassName:@"treeContent"];
                [query whereKey:@"content_Obj" equalTo:relativeContentObj];
                [query orderByAscending:@"createdAt"];
                [query findObjectsInBackgroundWithBlock:^(NSArray *contents, NSError *error) {
                    // NSArray *contents=[query findObjects];同步方法
                    
                    [hud hide:YES];
                    NSLog(@"i is %lu",i);
                    if (!error) {
                        
                        [self.contentArray addObject:contents]; //array中有array
                        //NSLog(@"contentArray---%@",self.contentArray);
                        
                        // 存取到最後一個物件才呼叫method
                        if (self.contentArray.count==filterArray.count) {
                            
                            //樹的數量大於2,內容才做循環
                            if (self.treeObjArray.count>=2) {
                                DataTreeContentObj *firstContent = self.contentArray[0];
                                DataTreeContentObj *lastContent = self.contentArray[self.contentArray.count-1];
                                [self.contentArray insertObject:lastContent atIndex:0];
                                [self.contentArray insertObject:firstContent atIndex:self.contentArray.count];
                                NSLog(@"fetch final obj , 樹的內容 contentArray count %lu",self.contentArray.count);
                            }
                            //                    NSLog(@"i is 0 ~ %ld",i);
                            [self getTableViewData:totalTreeObjArray contents:self.contentArray];
                            return ;
                        }
                    }else{
                        
                        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:@"Fetch data fail,Please try again later!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        NSLog(@"query treeContent-> content_Obj fail in parse , error is %@",error.description);
                        [av show];
                    }
                    
                }];
            }
        }
    }];
}

-(void)getTableViewData:(NSArray*)totalTreeObjArray contents:(NSArray*)contentsArray{
    
    // totalTreeObjArray 與 contentsArray 數量要一樣
    // 產生ContainerView裡面的內容
    self.vcArray = [[NSMutableArray alloc] init];
    NSArray *contentArray;
    
    // get data from parse
    for (NSInteger i=0; i<totalTreeObjArray.count; i++) {
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"TimeTree" bundle:nil];
        TimeTreeTableVC *vc = [sb instantiateViewControllerWithIdentifier:@"TimeTreeVC"];
        
        //get tree content
        contentArray= [NSArray arrayWithArray:contentsArray[i]]; //取出array中的array
        
        vc.dataObjectArray=[[NSMutableArray alloc]initWithArray:contentArray];
        
        //add VC 到 vcArray
        [self addChildViewController:vc];
        [self.vcArray addObject:vc];
    }
    
    NSLog(@"把樹的內容資料加入各個 vcArray");
    
    // 設定 scroll view 位置
//    if (self.treeObjArray.count>=2) {
        //加循環 , 傳1給起始位置
#warning to do 10/06 需要滾到新增事件，或是新增樹的位置
        [self scrollViewSetup:self.scrollIndex];
        NSLog(@"滑到 --%zd",self.scrollIndex);
//    }else{
        //需判斷只有一個的話 ，先不用加循環 , 傳0給起始位置
//        [self scrollViewSetup:0];
//    }
}

#pragma mark - Scroll Delegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView.tag == 100) {
        //上方ButtonScrollView
        CGRect rect = self.scrollView.frame;
        
        self.scrollIndex = scrollView.contentOffset.x/rect.size.width;
        NSLog(@"切換到第幾棵樹 -- %zd", self.scrollIndex);
        
        
        //切換ButtonView 做循環
        if (scrollView.contentOffset.x == 0) {
            [scrollView scrollRectToVisible:CGRectMake(rect.size.width*(self.totalTreeArray.count-2), 0, rect.size.width, rect.size.height) animated:NO];
        }else if(scrollView.contentOffset.x == rect.size.width*(self.totalTreeArray.count-1)) {
            [scrollView scrollRectToVisible:CGRectMake(rect.size.width, 0, rect.size.width, rect.size.height) animated:NO];
        }
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    //    if (scrollView.tag == 100) {
    //        CGRect rect = self.topButtonScrollView.frame;
    //        CGFloat offset = rect.size.width*currentButtonIndex - scrollView.contentOffset.x;
    //        //NSLog(@"位移量 -- (%f)", offset);
    //
    //        //開始位移
    //        self.rightLabelConstraint.constant = 20 - offset;
    //        self.leftLabelConstraint.constant = 20 + offset;
    //
    //        //位移大出畫面一半大就回到原點
    //        if (fabs(offset) >= rect.size.width/2) {
    //            self.rightLabelConstraint.constant = 20;
    //            self.leftLabelConstraint.constant = 20;
    //        }
    //
    //    }
    
}

#pragma mark -button action
-(void)yearSelector:(id)sender{
#warning  year pick view to do later
}

-(void)addTree:(id)sender
{
    //新增樹木
    //1.先跳出新增樹木的名字
    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"TimeTree" bundle:nil];
    popVC *vc=[sb instantiateViewControllerWithIdentifier:@"popVC"];
    
    [self addChildViewController:vc];
    
    [vc.view setBackgroundColor:[UIColor whiteColor]];
    vc.view.frame = CGRectMake(0, 0, 250, 150);
    vc.view.center = self.view.center;
    //        [vc.view.layer setBorderWidth:1];
    //        [vc.view.layer setBorderColor:[UIColor blackColor].CGColor];
    [vc.view.layer setCornerRadius:8];
    
    vc.timeTreeNameCallBack=^(NSString *timeTreeName){
        self.timeTreeName=timeTreeName;
        NSLog(@"get call back name is %@",timeTreeName);
        [self addTimeTree];
    };
    
    [self.view addSubview:vc.view];
    
}

-(void)addTimeTree{
    
    // 新增樹名
    self.timeTreeObj=[PFObject objectWithClassName:@"TimeTreeObj"];
    self.timeTreeObj[@"user"]=self.user;
    [self.timeTreeObj setObject:self.timeTreeName forKey:@"tree_name"];
    
    [self.timeTreeObj saveInBackgroundWithBlock:^(BOOL success,NSError *err){
        
        // Create the treeContent
        treeContent = [PFObject objectWithClassName:@"treeContent"];
        // Add a relation between the timeTreeObj and treeContent （樹名關聯->樹內容）
        
        [treeContent setObject:self.user forKey:@"user"];
        [treeContent setObject:self.timeTreeObj.objectId forKey:@"content_Obj"];
        treeContent[@"content_Obj"]=self.timeTreeObj;
        
        //同步存檔
        [treeContent save];
        
        [self getTreeObjData];
    }];

    
}




@end

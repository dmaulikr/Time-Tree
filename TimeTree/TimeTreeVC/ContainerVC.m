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

@interface ContainerVC ()
{
    PFObject *timeTreeObj;
    PFObject *treeContent;
    data *dataClass;
}
@property (strong,nonatomic) PFUser *user;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (strong,nonatomic) NSMutableArray *totalTreeArray;
@property (strong,nonatomic) NSMutableArray *vcArray;


@end

@implementation ContainerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
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

-(void)getTreeObjData{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=@"loading";
    [hud show:YES];
    __weak ContainerVC *this=self;
    dataClass=[[data alloc]init];
    dataClass.dataBlock=^(NSArray *treeObjArray){
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hide:YES];
            // init
            this.totalTreeArray=[[NSMutableArray alloc]initWithArray:treeObjArray];

            if (treeObjArray.count>=2) {
                //TreeScrollView
                //頭尾加入 供無限循環
                DataTimeTreeObj *firstTree = treeObjArray[0];
                DataTimeTreeObj *lastTree = treeObjArray[treeObjArray.count-1];
                
                [this.totalTreeArray insertObject:lastTree atIndex:0];
                [this.totalTreeArray insertObject:firstTree atIndex:this.totalTreeArray.count];
                
                if (this.totalTreeArray.count!=0) {
                    NSLog(@"頭尾加入，循環 count is %lu",(unsigned long)this.totalTreeArray.count);
                    [this getTableViewData:this.totalTreeArray]; //傳入dataTimeTreeObj物件的Array (循環)
                    [this scrollViewSetup:1];
                }
            }else{
                //需判斷只有一個的話 ，先不用加循環 , 傳0給起始位置
                [this getTableViewData:this.totalTreeArray]; //傳入dataTimeTreeObj物件的Array (循環)
                [this scrollViewSetup:0];
            }
            
        });
    };
    
    dataClass.loadDataFail=^(NSError *error){
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:error.description delegate:this cancelButtonTitle:@"確認" otherButtonTitles:nil];
        [av show];
    };
    [dataClass findTreeObjViaUser];
}

-(void)scrollViewSetup:(NSInteger)x{
    
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


-(void)getTableViewData:(NSArray*)totalTreeObjArray{
    // 產生ContainerView裡面的內容
    self.vcArray = [[NSMutableArray alloc] init];
        
    // get data from parse
    for (NSInteger i=0; i<totalTreeObjArray.count; i++) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"TimeTree" bundle:nil];
        TimeTreeTableVC *vc = [sb instantiateViewControllerWithIdentifier:@"TimeTreeVC"];
        vc.dataObject=[NSArray arrayWithObjects:totalTreeObjArray[i], nil];
        
        //get tree name
        DataTimeTreeObj *dataTimeTreeObj=totalTreeObjArray[i];
        vc.treeTitle=dataTimeTreeObj.treeName;
        
        //get tree content
        PFObject *contentObj=dataTimeTreeObj.treeContent;
        [contentObj fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error){
            
            NSString *content = [object objectForKey:@"content"];
            NSLog(@"retrieved tree name is %@ , tree content is %@",dataTimeTreeObj.treeName , content);
            vc.treeContent= content ; //關聯式pointer get data要再fetch一次

        }];
        
        [self addChildViewController:vc];
        [self.vcArray addObject:vc];
    }

}

#pragma mark - Scroll Delegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView.tag == 100) {
        //上方ButtonScrollView
        CGRect rect = self.scrollView.frame;
        
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
    //ScrollView
//    CGFloat scrollViewWidth = self.topButtonScrollView.frame.size.width;
//    self.scrollView.contentSize = CGSizeMake(scrollViewWidth*vcArray.count, self.scrollView.frame.size.height);

#warning  會蓋掉之前的name , 應該寫在修改名稱
//    PFQuery *query = [PFQuery queryWithClassName:@"TimeTreeObj"];
//    [query whereKey:@"user" equalTo:[PFUser currentUser]];
//    [query getFirstObjectInBackgroundWithBlock:^(PFObject * timeTreeObj, NSError *error) {
//        if (!error) {
//            [timeTreeObj setObject:self.timeTreeName forKey:@"tree_name"];
//            [timeTreeObj saveInBackground];
//        } else {
//            NSLog(@"Add Catalogue Name Error: %@", error);
//        }
//    }];
    
    // 新增樹名
    timeTreeObj=[PFObject objectWithClassName:@"TimeTreeObj"];
    timeTreeObj[@"user"]=self.user;
    [timeTreeObj setObject:self.timeTreeName forKey:@"tree_name"];
    
    // Create the treeContent
    treeContent = [PFObject objectWithClassName:@"treeContent"];
    // Add a relation between the timeTreeObj and treeContent （樹名關聯->樹內容）
    timeTreeObj[@"treeContent"] = treeContent;
    [timeTreeObj saveInBackground];
    [self getTreeObjData];
    
    
//    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Content" bundle:nil];
//    ContentVC *vc=[sb instantiateViewControllerWithIdentifier:@"contentVC"];
//    self.navigationController.navigationBarHidden=YES;
//    [self.navigationController pushViewController:vc animated:YES];
 
}




@end

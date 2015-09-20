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

@interface ContainerVC ()
{
    PFObject *timeTreeObj;
    PFObject *treeContent;
    data *dataClass;
}
@property (strong,nonatomic) PFUser *user;
@property (weak, nonatomic) IBOutlet UIScrollView *topButtonScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;

@property (strong,nonatomic) NSMutableArray *totalNameArray;
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
    [addBtn addTarget:self action:@selector(addTreeOrEvent:) forControlEvents:UIControlEventTouchUpInside];
    [addBtn setBackgroundColor:[UIColor blackColor]];
    [addBtn setTitle:@"＋" forState:UIControlStateNormal];
    UIBarButtonItem *add=[[UIBarButtonItem alloc]initWithCustomView:addBtn];
    self.navigationItem.rightBarButtonItems=@[add,leftFixedItem,years];
    
    // PFUser
    self.user=[PFUser currentUser];
    
    // get name , 上方 TopButtonScrollView 頭尾加入 供無限循環
    [self getNameData];
    
    // scrollView setting
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.backgroundColor=[UIColor darkGrayColor];
    
    // scrollView delegate
    self.topButtonScrollView.delegate = self;
    self.scrollView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)getNameData{
    
    __weak ContainerVC *this=self;
    dataClass=[[data alloc]init];
    dataClass.dataBlock=^(NSArray *nameArray){
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"call back name are %@",nameArray);
            
            // init
            this.totalNameArray=[[NSMutableArray alloc]initWithArray:nameArray];
            
            if (this.totalNameArray.count>=2) {
                //TopButtonScrollView
                //頭尾加入 供無限循環
                NSString *firstButtonName = this.totalNameArray[0];
                NSString *lastByttonName = this.totalNameArray[self.totalNameArray.count-1];
                [this.totalNameArray insertObject:lastByttonName atIndex:0];
                [this.totalNameArray insertObject:firstButtonName atIndex:this.totalNameArray.count];
                
                if (self.totalNameArray.count!=0) {
                    NSLog(@"add first and last name count is %lu , content is %@",(unsigned long)this.totalNameArray.count,this.totalNameArray);
                    [this topScrollViewSetup:1];
                    [this getTableViewData];
                    [this buttonScrollViewSetup];
                }
            }else{
                //需判斷只有一個的話 ，先不用加循環 , 傳0給起始位置
                [this topScrollViewSetup:0];
                [this getTableViewData];
                [this buttonScrollViewSetup];
            }
            
        });
    };
    
    dataClass.loadDataFail=^(NSError *error){
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:error.description delegate:this cancelButtonTitle:@"確認" otherButtonTitles:nil];
        [av show];
    };
    [dataClass findCatalogueNameViaUser];
}

-(void)topScrollViewSetup:(NSInteger)x{
    
    CGFloat topScrollWidth=self.topButtonScrollView.frame.size.width;
    CGFloat topScrollHeight=self.topButtonScrollView.frame.size.height;
    
    self.topButtonScrollView.pagingEnabled = YES;
    self.topButtonScrollView.showsHorizontalScrollIndicator = NO;
    self.topButtonScrollView.showsVerticalScrollIndicator = NO;
    
    self.topButtonScrollView.contentSize=CGSizeMake(topScrollWidth*self.totalNameArray.count,topScrollHeight);
    for (NSInteger i=0; i<self.totalNameArray.count; i++) {
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(topScrollWidth*i, 0, topScrollWidth, topScrollHeight)];
        [btn setTitle:self.totalNameArray[i] forState:UIControlStateNormal];
        [self.topButtonScrollView addSubview:btn];
    }
    //起始位置
    [self.topButtonScrollView scrollRectToVisible:CGRectMake(topScrollWidth*x, 0, topScrollWidth,topScrollHeight) animated:NO];

}

-(void)buttonScrollViewSetup{
    
    CGFloat scrollWidth=self.scrollView.frame.size.width;
    CGFloat scrollHeight=self.scrollView.frame.size.height;
    
    //ScrollView
    self.scrollView.contentSize = CGSizeMake(scrollWidth*self.vcArray.count, scrollHeight);
    
    for (NSInteger i = 0; i<self.vcArray.count; i++) {
        TimeTreeTableVC *vc = self.vcArray[i];
        vc.view.frame = CGRectMake(scrollWidth*i, 0, scrollWidth, self.scrollView.frame.size.height);
        [self.scrollView addSubview:vc.view];
    }
    [self.scrollView scrollRectToVisible:CGRectMake(scrollWidth*1, 0, scrollWidth, self.scrollView.frame.size.height) animated:NO];
}

-(void)getTableViewData{
    // 產生ContainerView裡面的內容
    self.vcArray = [[NSMutableArray alloc] init];
    
    UIStoryboard *sb = self.storyboard;
#warning to do nameArray count 跟 parse 裡的數量需一致 , 需要另外加id ?
//    for (NSString *treeName in self.totalNameArray) {
        TimeTreeTableVC *vc = [sb instantiateViewControllerWithIdentifier:@"TimeTreeVC"];
        
        // get data from parse
        PFQuery *pq=[PFQuery queryWithClassName:@"TimeTreeObj"];
        NSArray *tempArray=[DataTimeTreeObj getTimeTreeObj];
        for (NSInteger i; i<tempArray.count; i++) {
            
        [pq whereKey:timeTreeObj.objectId
                equalTo:[tempArray[i]objectForKey:@"objectId"]];

        [pq whereKey:@"user" equalTo:self.user];
        [pq getFirstObjectInBackgroundWithBlock:^(PFObject *obj , NSError *error){
            if (!error) {
//                vc.dataObject=obj;
//                PFObject *pfObject=[obj lastObject];
                NSString *pfStr=[obj objectForKey:@"treeContent"] ;
                NSLog(@"obj----%@",obj);
                NSLog(@"pfStr----%@",pfStr);

            }
            else{
                NSLog(@"fetch tree content error %@",error);
            }
            
        }];
        
        [self addChildViewController:vc];
        [self.vcArray addObject:vc];
        
    }

}

#pragma mark - Scroll Delegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView.tag == 100) {
        //上方ButtonScrollView
        CGRect rect = self.topButtonScrollView.frame;
        
        //切換ButtonView 做循環
        if (scrollView.contentOffset.x == 0) {
            [scrollView scrollRectToVisible:CGRectMake(rect.size.width*(self.totalNameArray.count-2), 0, rect.size.width, rect.size.height) animated:NO];
        }else if(scrollView.contentOffset.x == rect.size.width*(self.totalNameArray.count-1)) {
            [scrollView scrollRectToVisible:CGRectMake(rect.size.width, 0, rect.size.width, rect.size.height) animated:NO];
        }
//        
//        //換標簽
//        NSInteger index = scrollView.contentOffset.x/rect.size.width;
//        NSLog(@"換到第幾個標簽 -- %zd", index);
//        [self changeLable:index];
//        
//        //連動下方scrollView
//        CGRect bottomRect = self.scrollView.frame;
//        [self.scrollView scrollRectToVisible:CGRectMake(bottomRect.size.width*currentButtonIndex, 0, bottomRect.size.width, bottomRect.size.height) animated:NO];
        
    }else {
//        //下方內容ScrollView
//        
//        //切換ScrollView 做循環
//        CGRect rect = self.scrollView.frame;
//        if (scrollView.contentOffset.x == 0) {
//            [scrollView scrollRectToVisible:CGRectMake(rect.size.width*(vcArray.count-2), 0, rect.size.width, rect.size.height) animated:NO];
//        }else if(scrollView.contentOffset.x == rect.size.width*(vcArray.count-1)) {
//            [scrollView scrollRectToVisible:CGRectMake(rect.size.width, 0, rect.size.width, rect.size.height) animated:NO];
//        }
//        
//        [self changeLable:scrollView.contentOffset.x/rect.size.width];
//        
//        //連動上方按鈕ScrollView
//        CGRect topRect = self.topButtonScrollView.frame;
//        [self.topButtonScrollView scrollRectToVisible:CGRectMake(topRect.size.width*currentButtonIndex, 0, topRect.size.width, topRect.size.height) animated:NO];
//        
        
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

-(void)addTreeOrEvent:(id)sender
{
    UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:nil otherButtonTitles:@"add tree",@"add event", nil];
    [actionSheet showInView:self.view];
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
    timeTreeObj[@"parent"] = treeContent;
    
    [timeTreeObj saveInBackground];
 
}




#pragma mark - Action Sheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0)
    {
        //新增樹木
        //先跳出新增樹木的名字
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
        
    }else if(buttonIndex==1)
    {
        //新增事件
    }
}


@end

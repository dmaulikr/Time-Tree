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

#import "MenuTableViewController.h"

@interface ContainerVC ()
{
    PFUser *user;
    PFObject *timeTreeObj;
    PFObject *treeContent;
    NSMutableArray *vcArray;
    
}
@property (weak, nonatomic) IBOutlet UIScrollView *topButtonScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;

@property (strong,nonatomic) NSMutableArray *totalNameArray;

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
    user=[PFUser currentUser];
    
    // create PFObject class ( user 關聯-> tree name )
    // 加入使用者從目錄選的第一個名字進來的name
    timeTreeObj=[PFObject objectWithClassName:@"TimeTreeObj"];
    timeTreeObj[@"user"]=user;
    [timeTreeObj setObject:self.timeTreeName forKey:@"tree_name"];
    
    // Create the treeContent
    treeContent = [PFObject objectWithClassName:@"treeContent"];
    // Add a relation between the timeTreeObj and treeContent （樹名關聯->樹內容）
    timeTreeObj[@"parent"] = treeContent;
    
    [timeTreeObj saveInBackgroundWithBlock:^(BOOL success,NSError *error){
         if (success) {
#warning  check totalNameArray is nil why?
             // get totoal catalogue name
             self.totalNameArray=[[NSMutableArray alloc]initWithArray:[self findCatalogueNameViaUser]];
             //TopButtonScrollView
             //頭尾加入 供無限循環
             NSString *firstButtonName = self.totalNameArray[0];
             NSString *lastByttonName = self.totalNameArray[self.totalNameArray.count-1];
             [self.totalNameArray insertObject:lastByttonName atIndex:0];
             [self.totalNameArray insertObject:firstButtonName atIndex:self.totalNameArray.count];
             if (self.totalNameArray.count!=0) {
                 NSLog(@"count is %lu",(unsigned long)self.totalNameArray.count);
             }
         }
     }];
    
  

    self.topButtonScrollView.pagingEnabled = YES;
    self.topButtonScrollView.showsHorizontalScrollIndicator = NO;
    self.topButtonScrollView.showsVerticalScrollIndicator = NO;
    
    
 
    
    
    
    // 產生ContainerView裡面的內容
//    vcArray = [[NSMutableArray alloc] init];
//    
//    UIStoryboard *sb = self.storyboard;
//    for (NSString *categoryId in self.totalNameArray) {
//        
//        if ([HOLA_PERFECT_URL isEqualToString:HOLA_PERFECT_TEST]) {
//            
//            NewsCategoryListViewController *vc = [sb instantiateViewControllerWithIdentifier:@"NewsCategoryListView"];
//            NSArray *tempArray = [SQLiteManager getNewsListDataByCategoryId:categoryId date:dateStrFormate];
//            vc.arrayData = tempArray;
//            
//            [self addChildViewController:vc];
//            [vcArray addObject:vc];
//        }
//        else
//        {
//            NewsCategoryListViewController *vc = [sb instantiateViewControllerWithIdentifier:@"NewsCategoryListView"];
//            NSArray *tempArray = [SQLiteManager getNewsListDataByCategoryId:categoryId];
//            vc.arrayData = tempArray;
//            
//            [self addChildViewController:vc];
//            [vcArray addObject:vc];
//            
//        }
//    }
    
    
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
  
}

-(NSArray*)findCatalogueNameViaUser{
    
    NSMutableArray *nameArray=[[NSMutableArray alloc]init];
    PFQuery *pq=[PFQuery queryWithClassName:@"TimeTreeObj"];
    [pq whereKey:@"user" equalTo:[PFUser currentUser]];
    [pq findObjectsInBackgroundWithBlock:^(NSArray *objectArray , NSError *error){
        if (!error) {
            
            for (PFObject *pfObject in objectArray) {
                NSString *tempName=[pfObject objectForKey:@"tree_name"];
                [nameArray addObject:tempName];
                NSLog(@"pfobject is %@",nameArray);
            }
            
        }else{
            NSLog(@"get total name error is %@",error);
        }
        
    }];
    
    return nameArray;
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
    timeTreeObj[@"user"]=user;
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

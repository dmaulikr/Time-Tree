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


@interface ContainerVC ()
{
    PFUser *user;
    
}
@property (weak, nonatomic) IBOutlet UIScrollView *topButtonScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;

@property (strong,nonatomic)NSString *timeTreeName;
@property (strong,nonatomic)NSMutableArray *treeNameArray;

@end

@implementation ContainerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:(NavigationVC *)self.navigationController
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
    
    // scrollView setting
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.backgroundColor=[UIColor darkGrayColor];
    
    // scrollView delegate
    self.topButtonScrollView.delegate = self;
    self.scrollView.delegate = self;
    
    // PFUser
    user=[PFUser currentUser];
    
    // init
    self.treeNameArray=[[NSMutableArray alloc]init];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    
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
    CGFloat scrollViewWidth = self.topButtonScrollView.frame.size.width;
//    self.scrollView.contentSize = CGSizeMake(scrollViewWidth*vcArray.count, self.scrollView.frame.size.height);

    PFObject *timeTreeObj=[PFObject objectWithClassName:@"TimeTreeObj"];
    timeTreeObj[@"user"]=user;
    
    [self.treeNameArray addObject:self.timeTreeName];
    
//    timeTreeObj[@"tree_name"]=self.treeNameArray;
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"TimeTreeObj"];
        [query getObjectInBackgroundWithId:user.objectId block:^(PFObject *TimeTreeObj, NSError *error) {
            
            [timeTreeObj addObjectsFromArray:self.treeNameArray forKey:@"tree_name"];
            
        }];
    
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

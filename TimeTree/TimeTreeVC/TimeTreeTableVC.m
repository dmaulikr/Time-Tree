//
//  TimeTreeTableVC.m
//  TimeTree
//
//  Created by Joseph on 2015/7/16.
//  Copyright (c) 2015年 dosomethingq. All rights reserved.
//

#import "TimeTreeTableVC.h"
#import "TimeTreeTableViewCell.h"
#import "NavigationVC.h"



@interface TimeTreeTableVC () 
{
    
}
@property (strong,nonatomic) NSArray *tempArray;

@end

@implementation TimeTreeTableVC

- (void)viewDidLoad {
    [super viewDidLoad];

    
// cell 直接建在tableViewController 不用寫以下註冊code
//    [self.tableView registerNib:[UINib nibWithNibName:@"TimeTreeTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    
    self.tempArray=@[@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1"];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
//    self.title=self.titleStr;
//    self.title=@"2015";
}


#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    // Return the number of sections.
//    return 1;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
//    NSLog(@"i have number of rows %lu",(unsigned long)self.dataObject.count);
    return self.dataObject.count;
//    return 0;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 150;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 65.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    CGSize viewSize=self.view.frame.size;
    UILabel *titleLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    titleLable.text=self.treeTitle;
    titleLable.textAlignment = NSTextAlignmentCenter;
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 70, viewSize.width, 50)];
    [headerView addSubview:titleLable];
    [titleLable setCenter:headerView.center];
     //header 隨著 scroll 滑動
    self.tableView.tableHeaderView=headerView;
    
    return headerView;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    CGFloat xAxis=self.view.frame.size.width/2;
    UIView *footerView=[[UIView alloc]initWithFrame:CGRectMake(xAxis-15,0,30,30)];
    UIButton *addButton=[[UIButton alloc]initWithFrame:footerView.frame];
    [addButton setImage:[UIImage imageNamed:@"event_plus"] forState:UIControlStateNormal];
    [footerView addSubview:addButton];
    footerView.center=self.view.center;

    return footerView;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identify=@"Cell";
    TimeTreeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (cell==nil) {
        cell=[[TimeTreeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    
//    [self.tableView setContentInset:UIEdgeInsetsMake(60, 0, 0, 0)];
//    self.tableView.tableHeaderView.backgroundColor=[UIColor darkGrayColor];
//    self.tableView.tableFooterView.backgroundColor=[UIColor darkGrayColor];
//    cell.backgroundColor=[UIColor darkGrayColor];
    
    if (indexPath.row%2) {
        // odd
        [cell.rightButton setHidden:YES];
        [cell.leftButton setHidden:NO];
        
    }else{
        // 無樹內容，顯示樹幹
        if ([self.treeContent isEqualToString:@""]||self.treeContent==nil) {
            [cell.rightButton setHidden:YES];
            [cell.leftButton setHidden:YES];
        }else{
            // even
            [cell.rightButton setHidden:NO];
            [cell.leftButton setHidden:YES];
        }
    }
    
//    
//    for (NSInteger i=0; i<self.tempArray.count; i++) {
//        if (i%2) {
//            //odd
//            [cell.rightButton setHidden:YES];
//            [cell.leftButton setHidden:NO];
//            NSLog(@"odd");
//        }else{
//            //even
//            [cell.rightButton setHidden:NO];
//            [cell.leftButton setHidden:YES];
//            NSLog(@"even");
//        }
//    }
    
    
    return cell;
}



@end

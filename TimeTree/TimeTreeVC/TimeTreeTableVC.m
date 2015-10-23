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
#import "ContentVC.h"
#import "DataTimeTreeObj.h"
#import "DataTreeContentObj.h"


@interface TimeTreeTableVC ()
{
    UIView *footerView;
}

@property (strong,nonatomic)NSMutableArray *tempArray;

@end

@implementation TimeTreeTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // cell 直接建在tableViewController 不用寫以下註冊code
    //    [self.tableView registerNib:[UINib nibWithNibName:@"TimeTreeTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    
//    self.dataObjectArray=[[NSMutableArray alloc]init];
    
    self.tempArray=[[NSMutableArray alloc]init];
    for (PFObject *contentObj in self.dataObjectArray) {
        DataTreeContentObj *contentData=[[DataTreeContentObj alloc]initWithContentObj:contentObj];
        [self.tempArray addObject:contentData];
    }
    
    self.dataObjectArray=[[NSMutableArray alloc]initWithArray:self.tempArray];
    
    [self fetchPFObjectContentData];
}

-(void)viewDidAppear:(BOOL)animated{

   
}

-(void)viewWillAppear:(BOOL)animated{
    
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// fetch timeTree obj via relatedContent_obj in treeContent
-(void)fetchPFObjectContentData{
    
    for (DataTreeContentObj *data in self.dataObjectArray) {
        
        PFObject *treeContentObj=data.relateContent_obj;
        
        //get tree name
        [treeContentObj fetchIfNeededInBackgroundWithBlock:^(PFObject *obj ,NSError *err){
            if (err) {
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:@"Fetch data fail,Please try again later!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                NSLog(@"get TimeTreeObj fail via PFObject fetch , error is %@",err.description);
                [av show];
            }
            else{
                if (obj!=nil) {
                    self.treeTitle=[obj objectForKey:@"tree_name"];
                    [self.tableView reloadData];
                }
            }
        }];
    }
}

#pragma mark - button action
-(void)addEvent:(UIButton*)sender{
    
    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Content" bundle:nil];
    ContentVC *vc=[sb instantiateViewControllerWithIdentifier:@"contentVC"];
    vc.forAddContentTag=YES;
    DataTreeContentObj *contentObj=self.dataObjectArray[0];
    vc.ttObj=contentObj.relateContent_obj; //傳content_Obj給ContentVC,讓內容知道是增加哪一棵樹
    [self.navigationController presentViewController:vc animated:YES completion:nil];
    
    //    DataTimeTreeObj *dataObj=self.dataObject[0];
    //    PFObject *treeContentObj=dataObj.treeContent;
    //    [treeContentObj fetchIfNeededInBackgroundWithBlock:^(PFObject *obj ,NSError *err){
    //        vc.ttObj=obj;
    //        NSLog(@"add event objId is %@",obj.objectId);
    //        [self.navigationController presentViewController:vc animated:YES completion:nil];
    //    }];
    
    
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataObjectArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 60.0f;
}

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
    
    if (footerView==nil) {
        
        CGFloat xAxis=self.view.frame.size.width/2;
        footerView=[[UIView alloc]initWithFrame:CGRectMake(xAxis-15,0,30,30)];
        UIButton *addButton=[[UIButton alloc]initWithFrame:footerView.frame];
        [addButton setImage:[UIImage imageNamed:@"event_plus"] forState:UIControlStateNormal];
        [addButton addTarget:self action:@selector(addEvent:) forControlEvents:UIControlEventTouchUpInside];
        
        [footerView addSubview:addButton];
        
    }
    
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
    
    DataTreeContentObj *dataObj=self.dataObjectArray[indexPath.row];
    
    if (indexPath.row%2) {
        // odd
        [cell.rightButton setHidden:YES];
        [cell.rightLabel setHidden:NO];
        cell.rightLabel.text=dataObj.content;
        
        [cell.leftButton setHidden:NO];
        [cell.leftLabel setHidden:YES];
        
    }else{
        // 無樹內容，顯示樹幹
        if ([dataObj.content isEqualToString:@""]||dataObj.content==nil) {
            [cell.rightButton setHidden:YES];
            [cell.leftButton setHidden:YES];
        }else{
            // 有內容顯示樹枝 , even
            [cell.rightButton setHidden:NO];
            [cell.rightLabel setHidden:YES];
            
            [cell.leftButton setHidden:YES];
            [cell.leftLabel setHidden:NO];
            cell.leftLabel.text=dataObj.content;
        }
    }
    
    return cell;
}



@end

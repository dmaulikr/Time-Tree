//
//  CatalogueTableVC.m
//  TimeTree
//
//  Created by Joseph on 2015/7/11.
//  Copyright (c) 2015年 dosomethingq. All rights reserved.
//

#import "CatalogueTableVC.h"
#import "TimeTreeTableVC.h"
#import "CatalogueTableViewCell.h"
#import "ContainerVC.h"
#import "ContentVC.h"



@interface CatalogueTableVC ()
{
}
@property (strong,nonatomic) NSMutableArray *catalogName;

@end

@implementation CatalogueTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // hide navigation
    self.navigationController.navigationBarHidden=YES;
    
    // catloag name data
    NSArray *catalog=@[@"BOOKS",@"MOVIE",@"TRAVEL",@"FOOD",@"EVENT",@"+"];
    self.catalogName=[[NSMutableArray alloc]initWithArray:catalog];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section==0) {
        return 1;
    }else if (section==1){
        return self.catalogName.count;
    }
    return 0;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    CatalogueTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];

    if (cell == nil ) {
        cell = [[CatalogueTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    if (indexPath.section==0) {
        // 留白
        cell.nameLabel.text=@"";
    }else if (indexPath.section==1){
        cell.nameLabel.text=self.catalogName[indexPath.row];
    }

//    cell.itemLabel.font = [UIFont fontWithName:@"DFHeiStd-W3" size:18.0];//設定字體
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"user press index.row is %ld",(long)indexPath.row);
    NSLog(@"catalog name is %@",self.catalogName[indexPath.row]);
    
    
//    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"TimeTree" bundle:nil];
//    ContainerVC *vc=[sb instantiateViewControllerWithIdentifier:@"containerVC"];
//    vc.timeTreeName=self.catalogName[indexPath.row];
//    self.navigationController.navigationBarHidden=NO;
//    [self.navigationController pushViewController:vc animated:YES];
    
    
    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Content" bundle:nil];
    ContentVC *vc=[sb instantiateViewControllerWithIdentifier:@"contentVC"];
    vc.timeTreeName=self.catalogName[indexPath.row];
    vc.cataStr=self.catalogName[indexPath.row];
    self.navigationController.navigationBarHidden=YES;
    [self.navigationController pushViewController:vc animated:YES];
    
    
}


@end

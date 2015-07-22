//
//  CatalogueTableVC.m
//  TimeTree
//
//  Created by Joseph on 2015/7/11.
//  Copyright (c) 2015年 dosomethingq. All rights reserved.
//

#import "CatalogueTableVC.h"
#import "TimeTreeTableVC.h"



@interface CatalogueTableVC ()
{
}

@end

@implementation CatalogueTableVC

- (void)viewDidLoad {
    [super viewDidLoad];


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
        return 6;
    }
    
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
}


@end

//
//  testViewController.m
//  TimeTree
//
//  Created by Joseph on 2015/6/19.
//  Copyright (c) 2015年 dosomethingq. All rights reserved.
//

#import "CatalogueViewController.h"
#import "Parse/Parse.h"


@interface CatalogueViewController ()
{
}
@end

@implementation CatalogueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated{
    
    [self.profileImg setImageURL:self.url];
}
@end

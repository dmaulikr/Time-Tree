//
//  popVC.m
//  TimeTree
//
//  Created by Joseph on 2015/8/20.
//  Copyright (c) 2015年 dosomethingq. All rights reserved.
//

#import "popVC.h"
#import "ContentVC.h"

@interface popVC ()
@property (weak, nonatomic) IBOutlet UITextField *treeNameTextField;

@end

@implementation popVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -button action
- (IBAction)closeView:(id)sender {
    
    if (self.timeTreeNameCallBack) {
        self.timeTreeNameCallBack(self.treeNameTextField.text);
    }
//    NSLog(@"name is %@",self.treeNameTextField.text);
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    
    
}

- (IBAction)cancel:(id)sender {
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}


@end

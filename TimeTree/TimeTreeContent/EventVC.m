////
////  EventVC.m
////  TimeTree
////
////  Created by Joseph on 2015/9/2.
////  Copyright (c) 2015年 dosomethingq. All rights reserved.
////
//
//#import "EventVC.h"
//
//@interface EventVC ()
//
//
//@end
//
//@implementation EventVC
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
//    [self.view addGestureRecognizer:tapGesture];
//    self.eventSt.layer.borderWidth=1;
//    self.eventSt.layer.cornerRadius=8;
//    [self.eventSt.layer setBorderColor:[UIColor grayColor].CGColor];
//
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//- (IBAction)saveAction:(id)sender {
//    
//    if (self.finishTextCallBack) {
//        self.finishTextCallBack(self.eventSt.text);
//    }
//    
//    [self.view removeFromSuperview];
//    [self removeFromParentViewController];
//}
//
//-(void)tap:(id)sender{
//    [self.view endEditing:YES];
//}
//
//@end

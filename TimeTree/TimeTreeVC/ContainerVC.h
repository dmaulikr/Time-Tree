//
//  ContainerVC.h
//  TimeTree
//
//  Created by Joseph on 2015/8/18.
//  Copyright (c) 2015年 dosomethingq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"

@interface ContainerVC : UIViewController
@property (strong,nonatomic)NSString *timeTreeName;

@property (strong,nonatomic) PFObject *timeTreeObj;

-(void)viewDidLoad;

+(ContainerVC*)currentInstance;


// 1110 issue 1.增加內容後，不會跑到當前頁面  2.增加樹,不會出來樹  3.有時往右scroll無法循迴


@end

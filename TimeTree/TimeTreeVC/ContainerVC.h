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


@end

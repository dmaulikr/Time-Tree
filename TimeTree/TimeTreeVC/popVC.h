//
//  popVC.h
//  TimeTree
//
//  Created by Joseph on 2015/8/20.
//  Copyright (c) 2015年 dosomethingq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface popVC : UIViewController

typedef void (^FinishKeyIn)(NSString *timeTreeName);

@property (strong,nonatomic) FinishKeyIn timeTreeNameCallBack;

@end

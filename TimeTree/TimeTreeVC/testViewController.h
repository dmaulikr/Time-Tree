//
//  testViewController.h
//  TimeTree
//
//  Created by Joseph on 2015/6/19.
//  Copyright (c) 2015年 dosomethingq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "AsyncImageView.h"

@interface testViewController : UIViewController
@property (weak, nonatomic) IBOutlet AsyncImageView *profileImg;
@property (strong,nonatomic) NSURL *url;

@end

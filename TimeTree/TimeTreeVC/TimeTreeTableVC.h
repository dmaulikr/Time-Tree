//
//  TimeTreeTableVC.h
//  TimeTree
//
//  Created by Joseph on 2015/7/16.
//  Copyright (c) 2015年 dosomethingq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeTreeTableVC : UITableViewController <UIActionSheetDelegate>
@property (strong,nonatomic) NSString *titleStr;
@property (strong,nonatomic) NSArray *dataObject;
@end

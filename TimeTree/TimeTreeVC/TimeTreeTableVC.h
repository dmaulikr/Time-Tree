//
//  TimeTreeTableVC.h
//  TimeTree
//
//  Created by Joseph on 2015/7/16.
//  Copyright (c) 2015年 dosomethingq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"

@interface TimeTreeTableVC : UITableViewController <UIActionSheetDelegate>
@property (strong,nonatomic) NSMutableArray *dataObjectArray; //data 裡面裝treeContent
@property (strong,nonatomic) NSString *treeTitle;  //tree title


@end

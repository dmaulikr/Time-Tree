//
//  ContentTableViewCell.h
//  TimeTree
//
//  Created by Joseph on 2015/9/2.
//  Copyright (c) 2015年 dosomethingq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UITextView *contentText;

@end

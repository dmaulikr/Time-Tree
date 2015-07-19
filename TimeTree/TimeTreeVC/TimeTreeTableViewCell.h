//
//  TimeTreeTableViewCell.h
//  TimeTree
//
//  Created by Joseph on 2015/7/16.
//  Copyright (c) 2015年 dosomethingq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeTreeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UIImageView *mainBranch;

@end

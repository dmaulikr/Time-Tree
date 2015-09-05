//
//  ContentTableViewCell.m
//  TimeTree
//
//  Created by Joseph on 2015/9/2.
//  Copyright (c) 2015年 dosomethingq. All rights reserved.
//

#import "ContentTableViewCell.h"

@implementation ContentTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.contentText.delegate=self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end

//
//  Utility.m
//  TimeTree
//
//  Created by Joseph on 2015/9/2.
//  Copyright (c) 2015年 dosomethingq. All rights reserved.
//

#import "Utility.h"

@implementation Utility

+(NSString *)createDateFormat:(NSDate*)date{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY/MM/dd"];
    NSString *dateStr=[formatter stringFromDate:date];
    return dateStr;
}

@end

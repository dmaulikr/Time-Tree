//
//  Utility.h
//  TimeTree
//
//  Created by Joseph on 2015/9/2.
//  Copyright (c) 2015年 dosomethingq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utility : NSObject

/*
 日期格式產生器 "YYYY/MM/dd"
 @param NSDate
 @return NSString
 */

+(NSString *)createDateFormat:(NSDate*)date;

/*
 傳入欲過濾陣列裡的重複值 array
 @param NSArray
 @return NSArray
 */

+(NSArray*)arrayWithoutDuplicates:(NSArray*)rawArray;

@end

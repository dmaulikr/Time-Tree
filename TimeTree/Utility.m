//
//  Utility.m
//  TimeTree
//
//  Created by Joseph on 2015/9/2.
//  Copyright (c) 2015年 dosomethingq. All rights reserved.
//

#import "Utility.h"
#import "DataTreeContentObj.h"
#import "Parse/Parse.h"


@implementation Utility

+(NSString *)createDateFormat:(NSDate*)date{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY/MM/dd"];
    NSString *dateStr=[formatter stringFromDate:date];
    return dateStr;
}

+(NSArray*)arrayWithoutDuplicates:(NSArray*)rawArray{
    
    NSMutableArray *pfArray=[[NSMutableArray alloc]init];
    
    
    for (PFObject *contentObj in rawArray) {
        DataTreeContentObj *contentData=[[DataTreeContentObj alloc]initWithContentObj:contentObj];
        PFObject *obj=contentData.relateContent_obj;
        [pfArray addObject:obj];
    }
    
    NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:pfArray];
    NSArray *arrayWithoutDuplicates = [orderedSet array];
    return arrayWithoutDuplicates;
}


@end

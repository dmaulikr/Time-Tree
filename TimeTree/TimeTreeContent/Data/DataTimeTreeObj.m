//
//  timeTreeObj.m
//  TimeTree
//
//  Created by Joseph on 2015/9/6.
//  Copyright (c) 2015年 dosomethingq. All rights reserved.
//

#import "DataTimeTreeObj.h"
#import "URLib.h"

@implementation DataTimeTreeObj

-(instancetype)initObj:(PFObject*)obj{

    self=[super init];
    if (self) {
        if (obj.objectId!=nil) {
            self.objectId=obj.objectId;
        }
//        if ([obj objectForKey:@"treeContent"]!=nil) {
//            self.treeContent=[obj objectForKey:@"treeContent"]; // self.treeContent become "treeContent" PFObject , 因為TimeTreeObj關聯到treeContent
//        }
        if ([obj objectForKey:@"tree_name"]!=nil) {
            self.treeName=[obj objectForKey:@"tree_name"];
        }if ([obj objectForKey:@"user"]!=nil) {
            self.userIs=[obj objectForKey:@"user"];
        }
        if (obj.createdAt!=nil) {
            self.createdAt=obj.createdAt;
        }
    }
  
    return self;
}

/*
+(void)saveTimeTreeObj:(id)obj{
    
    // 取出之前的資料
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSMutableArray *previousObjArray=[[NSMutableArray alloc]init];
    NSArray *tempArray=[defaults objectForKey:TIMETREEOBJ];
    if (tempArray.count!=0) {
        previousObjArray=[[defaults objectForKey:TIMETREEOBJ]mutableCopy];
    }
    
    NSLog(@"先前的 timeTreeObj 清單 -- %@", previousObjArray);
    
    [previousObjArray addObject:obj];
    [defaults setObject:previousObjArray forKey:TIMETREEOBJ];
    [defaults synchronize];
    NSLog(@"所有的 timeTreeObj 清單 -- %@", previousObjArray);
}

+(NSArray*)getTimeTreeObj{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSArray *iDArray=[defaults objectForKey:TIMETREEOBJ];
    return iDArray;
}

*/
@end

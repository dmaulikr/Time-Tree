//
//  timeTreeObj.h
//  TimeTree
//
//  Created by Joseph on 2015/9/6.
//  Copyright (c) 2015年 dosomethingq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"

@interface DataTimeTreeObj : NSObject


@property (strong,nonatomic) NSString *objectId;
@property (strong,nonatomic) NSString *treeName;
@property (strong,nonatomic) NSString *userIs; //關聯到user's objectId
//@property (strong,nonatomic) PFObject *treeContent; //關聯到treeContent's objectId
@property (strong,nonatomic) NSDate *createdAt;

/**
 初始化 Parse class裡的物件 TimeTreeObj:key,value
 @param obj:PFObject
 @return nil
*/
-(instancetype)initObj:(PFObject*)obj;


/*
+(void)saveTimeTreeObj:(id)obj;
+(NSArray*)getTimeTreeObj;
*/
@end

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
@property (strong,nonatomic) NSString *userIs;
@property (strong,nonatomic) NSString *treeContent;
@property (strong,nonatomic) NSDate *createdAt;

-(instancetype)initObj:(PFObject*)obj;

+(void)saveTimeTreeObj:(id)obj;
+(NSArray*)getTimeTreeObj;

@end

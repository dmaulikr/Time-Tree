//
//  data.h
//  TimeTree
//
//  Created by Joseph on 2015/9/4.
//  Copyright (c) 2015年 dosomethingq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface data : NSObject

typedef void (^loadData) (NSArray *nameArray);
@property (strong,nonatomic)loadData dataBlock;

typedef void (^loadDataFail) (NSError *error);
@property (strong,nonatomic)loadDataFail loadDataFail;


/**
 先抓Parse整包的array透過current user，再轉成DataTimeTreeObj物件存成Array
 @param nil
 @return nil
*/
-(void)findTreeObjViaUser;
@end

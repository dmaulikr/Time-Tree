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

-(void)findCatalogueNameViaUser;
@end

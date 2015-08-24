//
//  Comms.h
//  TimeTree
//
//  Created by Joseph on 2015/6/19.
//  Copyright (c) 2015年 dosomethingq. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol CommsDelegate <NSObject>
@optional
- (void) commsDidLogin:(BOOL)loggedIn;
@end


@interface Comms : NSObject

+ (void) login:(id<CommsDelegate>)delegate;
@end
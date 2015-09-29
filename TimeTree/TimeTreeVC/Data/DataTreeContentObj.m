//
//  DataTreeContentObj.m
//  TimeTree
//
//  Created by Joseph on 2015/9/29.
//  Copyright © 2015年 dosomethingq. All rights reserved.
//

#import "DataTreeContentObj.h"

@implementation DataTreeContentObj

-(instancetype)initWithContentObj:(PFObject*)obj{
    self=[super init];
    if (self) {
        
        if (obj.objectId!=nil) {
            self.objectId=obj.objectId;
        }
        
        if ([obj objectForKey:@"content"]!=nil) {
            self.content=[obj objectForKey:@"content"];
        }
        
        if ([obj objectForKey:@"content_obj"]!=nil) {
            self.content_obj=[obj objectForKey:@"content_obj"];
        }
        
        if (obj.createdAt!=nil) {
            self.createdAt=obj.createdAt;
        }
    }
    return self;
}


@end

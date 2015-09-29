//
//  DataTreeContentObj.h
//  TimeTree
//
//  Created by Joseph on 2015/9/29.
//  Copyright © 2015年 dosomethingq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"


@interface DataTreeContentObj : NSObject

@property (strong,nonatomic) NSString *objectId;
@property (strong,nonatomic) NSString *content;
@property (strong,nonatomic) PFObject *content_obj;
//@property (strong,nonatomic) PFFile *treeEventImgFile;
@property (strong,nonatomic) NSDate *createdAt;


@end


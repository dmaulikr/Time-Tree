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
@property (strong,nonatomic) PFObject *relateContent_obj; 
//@property (strong,nonatomic) PFFile *treeEventImgFile;
@property (strong,nonatomic) NSDate *createdAt;



/**
 初始化 Parse class 裡的物件 treeContent
 @param obj:PFObject
 @return nil
 */
-(instancetype)initWithContentObj:(PFObject*)obj;


@end


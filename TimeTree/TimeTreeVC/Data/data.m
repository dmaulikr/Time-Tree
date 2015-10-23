//
//  data.m
//  TimeTree
//
//  Created by Joseph on 2015/9/4.
//  Copyright (c) 2015年 dosomethingq. All rights reserved.
//

#import "data.h"
#import "Parse/Parse.h"
#import "DataTimeTreeObj.h"
#import "Utility.h"

@implementation data


-(void)findTreeObjViaUser{
#warning to do 需要加入MB progress bar
  
    NSMutableArray *treeObjArray=[[NSMutableArray alloc]init];
    PFUser *user=[PFUser currentUser];
    NSString *username=[user objectForKey:@"username"];
    
    // query only condition is current user 跟使用者有關的都抓下來成 array
    PFQuery *pq=[PFQuery queryWithClassName:@"TimeTreeObj"];
    [pq whereKey:@"user" equalTo:user];
    [pq orderByAscending:@"createdAt"];
    [pq findObjectsInBackgroundWithBlock:^(NSArray *objectArray , NSError *error){
        if (!error) {
            
            if (self.dataBlock) {
                // 先抓Parse整包array，再轉成DataTimeTreeObj物件Array
                for (PFObject *pfObj in objectArray) {
                    DataTimeTreeObj *treeObj=[[DataTimeTreeObj alloc]initObj:pfObj];
                    [treeObjArray addObject:treeObj];
//                    NSLog(@"tree id are %@",treeObj.objectId);
                }
                NSLog(@"user: %@ , own tree count is %lu ",username,(unsigned long)treeObjArray.count);
                self.dataBlock(treeObjArray);
            }
           
        }else{
            if (self.loadDataFail) {
                self.loadDataFail(error);
            }
        }
        
    }];
    
}

@end

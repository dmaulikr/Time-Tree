//
//  data.m
//  TimeTree
//
//  Created by Joseph on 2015/9/4.
//  Copyright (c) 2015年 dosomethingq. All rights reserved.
//

#import "data.h"
#import "Parse/Parse.h"

@implementation data


-(void)findCatalogueNameViaUser{
    
    NSMutableArray *nameArray=[[NSMutableArray alloc]init];
    PFUser *user=[PFUser currentUser];
    NSString *username=[user objectForKey:@"username"];
    
    PFQuery *pq=[PFQuery queryWithClassName:@"TimeTreeObj"];
    [pq whereKey:@"user" equalTo:user];
    [pq findObjectsInBackgroundWithBlock:^(NSArray *objectArray , NSError *error){
        if (!error) {
            
            if (self.dataBlock) {
                
                for (PFObject *pfObject in objectArray) {
                    NSString *tempName=[pfObject objectForKey:@"tree_name"];
                    [nameArray addObject:tempName];
                    NSLog(@"user: %@ , own tree count is %lu , tree name are %@",username,(unsigned long)nameArray.count,nameArray);
                }
                
                self.dataBlock(nameArray);
            }
           
        }else{
            if (self.loadDataFail) {
                self.loadDataFail(error);
            }
            NSLog(@"get total name error is %@",error);
        }
        
    }];
    
}

@end

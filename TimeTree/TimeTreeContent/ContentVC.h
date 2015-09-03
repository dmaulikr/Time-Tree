//
//  ContentVC.h
//  TimeTree
//
//  Created by Joseph on 2015/9/2.
//  Copyright (c) 2015年 dosomethingq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContentVC : UIViewController <UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>
@property (strong,nonatomic)NSString *cataStr;
@property (strong,nonatomic)NSString *timeTreeName;

@end

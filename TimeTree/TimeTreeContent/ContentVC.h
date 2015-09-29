//
//  ContentVC.h
//  TimeTree
//
//  Created by Joseph on 2015/9/2.
//  Copyright (c) 2015年 dosomethingq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"

@interface ContentVC : UIViewController <UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>
@property (strong,nonatomic)NSString *timeTreeName; //由CatalogueTableVC傳過來

@property (assign,nonatomic)BOOL forAddContentTag; //由timeTreeTableVC傳過來
@property (strong,nonatomic)PFObject *ttObj; // 由timeTreeTableVC傳過來
@end

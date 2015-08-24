//
//  ViewController.m
//  TimeTree
//
//  Created by Joseph on 2015/6/9.
//  Copyright (c) 2015年 dosomethingq. All rights reserved.
//

#import "ViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>


//
//#import "MenuTableViewController.h"
//#import "NavigationVC.h"
//#import "REFrostedViewController.h"
//#import "TimeTreeTableVC.h"
//#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu"
//                                                                             style:UIBarButtonItemStylePlain
//                                                                            target:(NavigationVC *)self.navigationController
//                                                                            action:@selector(showMenu)];
//
    
    
//    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"TimeTree" bundle:nil];
//    TimeTreeTableVC *vc=[sb instantiateViewControllerWithIdentifier:@"TimeTreeVC"];
//    
//    NavigationVC *navigationController = [[NavigationVC alloc] initWithRootViewController:vc];
//    MenuTableViewController *menuController = [[MenuTableViewController alloc] initWithStyle:UITableViewStylePlain];
//    
//    // Create frosted view controller
//    REFrostedViewController *frostedViewController = [[REFrostedViewController alloc] initWithContentViewController:navigationController menuViewController:menuController];
//    frostedViewController.direction = REFrostedViewControllerDirectionLeft;
//    frostedViewController.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleLight;
//    frostedViewController.liveBlur = YES;
//    
//    UIStoryboard *sb1=[UIStoryboard storyboardWithName:@"TimeTree" bundle:nil];
//    TimeTreeTableVC *vc1=[sb1 instantiateViewControllerWithIdentifier:@"TimeTreeVC"];
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    
//    [appDelegate.window.rootViewController presentViewController:vc1 animated:YES completion:nil];
//    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewDidAppear:(BOOL)animated
{
    }

@end

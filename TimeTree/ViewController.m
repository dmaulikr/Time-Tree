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
#import "MenuTableViewController.h"
#import "NavigationVC.h"
#import "REFrostedViewController.h"
//#import "TimeTreeTableVC.h"
//#import "AppDelegate.h"

#import "LoginViewController.h"
#import "CatalogueTableVC.h"
#import "ContainerVC.h"

@interface ViewController ()
{
    NSUserDefaults *defaults;

}

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
    
    defaults=[NSUserDefaults standardUserDefaults];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    
  
}

-(void)viewDidAppear:(BOOL)animated
{
        // 從 dismiss login vc , set tag 就會到這
    if ([[defaults objectForKey:@"pushToCatalog"]isEqualToString:@"pushToCatalog"]) {
        // create NavigationVC
        UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Login" bundle:nil];
        CatalogueTableVC *vc=[sb instantiateViewControllerWithIdentifier:@"GoCatalogueTVC"];
        NavigationVC *navigationController =[[NavigationVC alloc]initWithRootViewController:vc];
        
        // Create frosted view controller
        [self frostedVC:navigationController];

        [defaults setObject:@"" forKey:@"pushToCatalog"];
        [defaults synchronize];
        
        
    }else if ([[defaults objectForKey:@"pushToTT"]isEqualToString:@"pushToTT"]){
        // create NavigationVC
        UIStoryboard *sb=[UIStoryboard storyboardWithName:@"TimeTree" bundle:nil];
        ContainerVC *vc=[sb instantiateViewControllerWithIdentifier:@"containerVC"];
        NavigationVC *navigationController =[[NavigationVC alloc]initWithRootViewController:vc];
        
        // Create frosted view controller
        [self frostedVC:navigationController];
        
        [defaults setObject:@"" forKey:@"pushToTT"];
        [defaults synchronize];

        self.navigationController.navigationBarHidden=NO;
    }
    
}


-(void)frostedVC:(NavigationVC*)nav{
    // Create frosted view controller
    MenuTableViewController *menuController = [[MenuTableViewController alloc] initWithStyle:UITableViewStylePlain];
    REFrostedViewController *frostedViewController = [[REFrostedViewController alloc] initWithContentViewController:nav menuViewController:menuController];
    frostedViewController.direction = REFrostedViewControllerDirectionLeft;
    frostedViewController.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleLight;
    frostedViewController.liveBlur = YES;
    self.view.window.rootViewController=frostedViewController;
}

#pragma mark -action

- (IBAction)skipAction:(id)sender {
    // present login VC
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    LoginViewController *logVC=[storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:logVC];
    [self.view.window.rootViewController presentViewController:nav animated:YES completion:nil];

}



@end

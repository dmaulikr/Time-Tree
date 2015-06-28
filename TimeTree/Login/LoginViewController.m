//
//  LoginViewController.m
//  TimeTree
//
//  Created by Joseph on 2015/6/9.
//  Copyright (c) 2015年 dosomethingq. All rights reserved.
//

#import "LoginViewController.h"
#import "FBSDKCoreKit/FBSDKCoreKit.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "Parse/Parse.h"
#import "Comms.h"
#import "testViewController.h"
#import <FacebookSDK/FacebookSDK.h>



@interface LoginViewController ()<CommsDelegate>
@property (weak, nonatomic) IBOutlet FBSDKLoginButton *FBLogin_Btn;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

//    if ([FBSDKAccessToken currentAccessToken]) {
//        NSLog(@"login succcessful!");
//    }
//    self.aa.readPermissions= @[@"public_profile", @"email", @"user_friends"];
//
//    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
//
//    [login logInWithReadPermissions:@[@"email"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
//        if (error) {
//            // Process error
//        } else if (result.isCancelled) {
//            // Handle cancellations
//        } else {
//            // If you ask for multiple permissions at once, you
//            // should check if specific permissions missing
//            if ([result.grantedPermissions containsObject:@"email"]) {
//                // Do work
//            }
//        }
//    }];
    
    FBLoginView *loginView =[[FBLoginView alloc] initWithReadPermissions:@[@"public_profile", @"email", @"user_friends"]];
    
    
//    [self.view addSubview:loginView];
    [PFUser logOut];

    self.FBLogin_Btn.delegate=self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)FBlogin:(id)sender {
    
    // Disable the Login button to prevent multiple touches
    [self.FBLogin_Btn setEnabled:NO];
    
    // Do the login
    [Comms login:self];
    
}

- (void) commsDidLogin:(BOOL)loggedIn {
    // Re-enable the Login button
    [self.FBLogin_Btn setEnabled:YES];
    
    
    // Did we login successfully ?
    if (loggedIn) {
        
        UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Login" bundle:nil];
        testViewController *vc= [sb instantiateViewControllerWithIdentifier:@"LoginSuccessful"];
        
        [self.navigationController pushViewController:vc animated:YES];
      
        
    } else {
        // Show error alert
        [[[UIAlertView alloc] initWithTitle:@"Login Failed"
                                    message:@"Facebook Login failed. Please try again"
                                   delegate:nil
                          cancelButtonTitle:@"Ok"
                          otherButtonTitles:nil] show];
    }
}

@end

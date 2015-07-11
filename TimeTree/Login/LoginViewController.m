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
#import "ParseFacebookUtils/PFFacebookUtils.h"
#import "URLib.h"
#import "AsyncImageView.h"




@interface LoginViewController ()<CommsDelegate,FBLoginViewDelegate>
{
    NSUserDefaults *defaults;
}

//@property (weak, nonatomic) IBOutlet FBSDKLoginButton *FBLogin_Btn;
@property (weak, nonatomic) IBOutlet FBLoginView *fbLoginView1;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // set up NSUserDefaults
    defaults=  [NSUserDefaults standardUserDefaults];

    // sdk3.5 old version (old method)
    self.fbLoginView1.publishPermissions=@[@"public_profile", @"email", @"user_friends"];
    
    self.fbLoginView1.delegate=self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES];

}
-(void)viewDidAppear:(BOOL)animated{
}

#pragma mark -  FBLoginView delegate
// 3. user logged
- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView;
{
    
    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Login" bundle:nil];
    testViewController *vc= [sb instantiateViewControllerWithIdentifier:@"LoginSuccessful"];
    
    // 傳URL過去
    NSURL *empUrl =nil;
    vc.profileImg.imageURL = empUrl;
    [vc.profileImg setShowActivityIndicator:YES];
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:vc.profileImg.imageURL];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", FB_GRAPH,[defaults objectForKey:@"pic"],FB_PROFILE_IMG]];
    vc.url=url;
    
//    [self.navigationController pushViewController:vc animated:YES];


}

// 2. parse login via FB (PFUser)
-(void)parseLogin{
    [PFFacebookUtils logInWithPermissions:@[@"public_profile", @"email", @"user_friends"] block:^(PFUser *user, NSError *error) {
        // Was login successful ?
        if (!user) {
            if (!error) {
                NSLog(@"The user cancelled the Facebook login.");
            } else {
                NSLog(@"An error occurred: %@", error.localizedDescription);
            }
            
        } else {
            // Callback - login successful
            PFUser *pfUser=[PFUser currentUser];
            pfUser.email=[defaults objectForKey:@"email"];
            pfUser.username=[defaults objectForKey:@"name"];
            
            // create object in parse
            [pfUser setObject:[defaults objectForKey:@"gender"] forKey:@"gender"];
            [pfUser saveInBackground];
            
        }
    }];
    
}

// 1. fetch user info
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    NSLog(@"user is %@",user);
    
    // save user information
    [defaults setObject: [user objectForKey:@"email"] forKey:@"email"];
    [defaults setObject:[user objectForKey:@"name"] forKey:@"name"];
    [defaults setObject:[user objectForKey:@"gender"] forKey:@"gender"];
    [defaults setObject:user.objectID forKey:@"pic"];
    
    [defaults synchronize];
    
    // parse login
    [self parseLogin];
    
}

// log out
- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView;
{
#warning  write later clear user information
//    [defaults setObject:nil forKey:@"email"];
//    [defaults synchronize];
//    [PFUser logOut];
}

- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error{
    
    NSLog(@"login in error %@",error);

}

@end

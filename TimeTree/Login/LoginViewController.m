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



//- (IBAction)FBlogin:(id)sender {
//    
//    // Disable the Login button to prevent multiple touches
//    [self.FBLogin_Btn setEnabled:NO];
//    
//    // Do the login
//    [Comms login:self];
//
//}

//- (void) commsDidLogin:(BOOL)loggedIn {
//    // Re-enable the Login button
//    [self.FBLogin_Btn setEnabled:YES];
//    
//    
//    // Did we login successfully ?
//    if (loggedIn) {
////        
////        UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Login" bundle:nil];
////        testViewController *vc= [sb instantiateViewControllerWithIdentifier:@"LoginSuccessful"];
////        
////        [self.navigationController pushViewController:vc animated:YES];
////      
////        
//        
////        if ([FBSDKProfile currentProfile]) {
////            [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
////            NSLog(@"user is -- %@",[[FBSDKProfile currentProfile]name]);
////        }
//        
//        
//    } else {
//        // Show error alert
//        [[[UIAlertView alloc] initWithTitle:@"Login Failed"
//                                    message:@"Facebook Login failed. Please try again"
//                                   delegate:nil
//                          cancelButtonTitle:@"Ok"
//                          otherButtonTitles:nil] show];
//    }
//}

#pragma mark -  FBLoginView delegate

// logged
- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView;
{
    
    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Login" bundle:nil];
    testViewController *vc= [sb instantiateViewControllerWithIdentifier:@"LoginSuccessful"];
    [self.navigationController pushViewController:vc animated:YES];


}

// parse login via FB (PFUser)
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
            NSLog(@"id is %@",pfUser.objectId);
            pfUser.email=[defaults objectForKey:@"email"];
            [pfUser saveInBackground];
        }
    }];
    
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    //將 layout 是 profilePictureView 將會顯示使用者的大頭照
    //    self.profilePictureView.profileID = user.id;
    //nameLabel 的內容將會改變成使用者的名稱
    NSLog(@"user is %@",user);
    
    [defaults setObject: [user objectForKey:@"email"] forKey:@"email"];
    [defaults synchronize];
    
    [self parseLogin];
   
}


//log out
- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView;
{
//    [defaults setObject:nil forKey:@"email"];
//    [defaults synchronize];
//    [PFUser logOut];
}

- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error{
    
    NSLog(@"login in error %@",error);

}

@end

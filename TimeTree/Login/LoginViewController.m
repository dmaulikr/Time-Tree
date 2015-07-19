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
#import "CatalogueViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "ParseFacebookUtils/PFFacebookUtils.h"
#import "URLib.h"
#import "AsyncImageView.h"
#import "CatalogueTableVC.h"
#import "TimeTreeTableVC.h"




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

- (IBAction)login:(id)sender {
    
    // user name 有大小寫之分
    [PFUser logInWithUsernameInBackground:self.name.text password:self.password.text block:^(PFUser *user,NSError *error){
       
        if (!error) {
            
//            static dispatch_once_t onceToken;
//            dispatch_once(&onceToken,^{
//            UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Login" bundle:nil];
//            CatalogueTableVC *vc=[sb instantiateViewControllerWithIdentifier:@"GoCatalogueTVC"];
//            [self.navigationController pushViewController:vc animated:YES];
                
                UIStoryboard *sb=[UIStoryboard storyboardWithName:@"TimeTree" bundle:nil];
                TimeTreeTableVC *vc=[sb instantiateViewControllerWithIdentifier:@"TimeTreeVC"];
                [self.navigationController pushViewController:vc animated:YES];
//            });
            
            
        }
        else{
            
                UIAlertView *av=[[UIAlertView alloc]initWithTitle:nil message:@"Please enter valid username/password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [av show];
            
            NSLog(@"sign up error %@",error.description);

        }
        
    }];
    
}


#pragma mark -  FBLoginView delegate
// 3. user logged
- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView;
{
#warning do later , 決定大頭圖在哪，在寫
//    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Login" bundle:nil];
//    CatalogueViewController *vc= [sb instantiateViewControllerWithIdentifier:@"GoCatalogueVC"];
//    
//    // 傳URL過去
//    NSURL *empUrl =nil;
//    vc.profileImg.imageURL = empUrl;
//    [vc.profileImg setShowActivityIndicator:YES];
//    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:vc.profileImg.imageURL];
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", FB_GRAPH,[defaults objectForKey:@"pic"],FB_PROFILE_IMG]];
//    vc.url=url;
#warning write later FB log out做完再打開
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

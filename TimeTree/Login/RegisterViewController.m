//
//  RegisterViewController.m
//  TimeTree
//
//  Created by Joseph on 2015/7/11.
//  Copyright (c) 2015年 dosomethingq. All rights reserved.
//

#import "RegisterViewController.h"
#import "Parse/Parse.h"


@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)register:(id)sender {
    
    // get使用者資料to parse
    PFUser *user=[PFUser user];
    user.username=self.name.text;
    user.email=self.email.text;
    user.password=self.password.text;
    
    if([user.username isEqualToString: @""] || [user.email isEqualToString: @""] || [user.password isEqualToString:@""]){
        UIAlertView *av=[[UIAlertView alloc]initWithTitle:nil message:@"Please fill in user/email/password " delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [av show];
        return;
    }
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded,NSError *error){
        
        if(!error){
            
            UIAlertView *av=[[UIAlertView alloc]initWithTitle:nil message:@"singup successful" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [av show];
            
        }else{
            
            if(error.code==202){
                UIAlertView *av=[[UIAlertView alloc]initWithTitle:nil message:@"username or email  already taken" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [av show];
            }else if (error.code==125){
                UIAlertView *av=[[UIAlertView alloc]initWithTitle:nil message:@"invalid email address" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [av show];
            }
            
            NSLog(@"sign up error %@",error.description);
        }
    }];
}

@end

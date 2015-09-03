//
//  ContentVC.m
//  TimeTree
//
//  Created by Joseph on 2015/9/2.
//  Copyright (c) 2015年 dosomethingq. All rights reserved.
//

#import "ContentVC.h"
#import "EventVC.h"
#import "ContentTableViewCell.h"
#import "Utility.h"
#import "ParallaxHeaderView.h"
#import "Parse/Parse.h"


@interface ContentVC ()
{
    ParallaxHeaderView *headerView;
    PFUser *user;
    PFObject *timeTreeObj;
    PFObject *treeContent;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) UIImage *img;
@property (assign,nonatomic) BOOL takePhotoTag;

@end

@implementation ContentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self parseClassCreate];
    
    // Create ParallaxHeaderView with specified size, and set it as uitableView Header, that's it
    [self CreateParallaxHeaderView];
    [self.tableView setTableHeaderView:headerView];
    
    // add button for add pic
    UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(10, 10, 30, 30)];
    [btn setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(photoAction:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:btn];
    
    // tap gesture
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tapGesture];
    [self eventAlertView];
    
    
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [(ParallaxHeaderView *)self.tableView.tableHeaderView refreshBlurViewForNewImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString*)dateIs{
    NSDate *now=[NSDate date];
    NSString *dateIs=[Utility createDateFormat:now];
    return dateIs;
}

-(void)CreateParallaxHeaderView{
    headerView = [ParallaxHeaderView parallaxHeaderViewWithImage:self.img forSize:CGSizeMake(self.tableView.frame.size.width, 300)];
    //    headerView.headerTitleLabel.text = self.story[@"story"];
}

-(void)parseClassCreate{
    // PFUser
    user=[PFUser currentUser];
    
    // create PFObject class ( user 關聯-> tree name )
    // 加入使用者從目錄選的第一個名字進來的name
    timeTreeObj=[PFObject objectWithClassName:@"TimeTreeObj"];
    timeTreeObj[@"user"]=user;
    [timeTreeObj setObject:self.timeTreeName forKey:@"tree_name"];
    
    // Create the treeContent
    treeContent = [PFObject objectWithClassName:@"treeContent"];
    // Add a relation between the timeTreeObj and treeContent （樹名關聯->樹內容）
    timeTreeObj[@"treeContent"] = treeContent;
    [timeTreeObj saveInBackground];

}

#pragma mark - action
-(void)eventAlertView{

    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Content" bundle:nil];
    EventVC *vc=[sb instantiateViewControllerWithIdentifier:@"eventVC"];
    [self addChildViewController:vc];
    [vc.view setBackgroundColor:[UIColor whiteColor]];
//    vc.view.frame = CGRectMake(0, 0, 250, 150);
    vc.evenLabel.text=self.cataStr;
    vc.view.center = self.view.center;
    [vc.view.layer setBorderWidth:1];
    [vc.view.layer setBorderColor:[UIColor grayColor].CGColor];
    [vc.view.layer setCornerRadius:8];
    [self.view addSubview:vc.view];    
}

-(void)tap:(id)sender{
    [self.view endEditing:YES];
}

- (IBAction)photoAction:(id)sender {
    UIActionSheet *actionSheet =[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take photo",@"Use album photo", nil];
    [actionSheet showInView:self.view];
}


#pragma mark - action sheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0)
    {   // take picture
        // check camera available or not
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *imagePicker=[[UIImagePickerController alloc]init];
            imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
            imagePicker.delegate=self;
            self.takePhotoTag=YES;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
        
    }
    else if (buttonIndex==1)
    {   // select your photo libray
        UIImagePickerController *imagePicker=[[UIImagePickerController alloc]init];
        imagePicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.delegate=self;
        [self presentViewController:imagePicker animated:YES completion:nil];
        
    }
}


#pragma mark - UIImagePickerController Delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    // 圖片選取結束會到這,所以這邊要存圖片到 parse
    UIImage *image=[info valueForKey:UIImagePickerControllerOriginalImage];
    // save to album tag
    if (self.takePhotoTag) {
        // save pic to album
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    self.img=image;
    headerView.headerImage = self.img;
#warning 圖片似乎要解壓縮，不然會大
    // pic to NSData -> PFFile
    NSData *picData=UIImagePNGRepresentation(self.img);
    PFFile *imgFile=[PFFile fileWithData:picData];
    treeContent[@"treeEventImgFile"]=imgFile;
#warning 內容圖片要加入不重複存
    [imgFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        // Handle success or failure here ...
    } progressBlock:^(int percentDone) {
        // Update your progress spinner here. percentDone will be between 0 and 100.
        NSLog(@"percentage %d",percentDone);
    }];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - tableView data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify=@"contentCell";
    ContentTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identify forIndexPath:indexPath];
    if (cell==nil) {
        cell=[[ContentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    
    NSString *date=[self dateIs];
    
    cell.date.text=date;
    
    return cell;
}

#pragma mark - tableView delegate

#pragma mark UISCrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.tableView)
    {
        // pass the current offset of the UITableView so that the ParallaxHeaderView layouts the subViews.
        [(ParallaxHeaderView *)self.tableView.tableHeaderView layoutHeaderViewForScrollViewOffset:scrollView.contentOffset];
    }
}

@end

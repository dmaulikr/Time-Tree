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
#import "ContainerVC.h"
#import "DataTimeTreeObj.h"

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
#warning thinking 需要加tag only for 第一次進來
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
#warning thinking 好像直接寫就好不用跳個view出來
//    [self eventAlertView];
    
    
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
    
    // create PFObject class
    timeTreeObj=[PFObject objectWithClassName:@"TimeTreeObj"];
    // timeTreeObj 關聯到 user
    timeTreeObj[@"user"]=user;
    // 加入使用者從目錄選的第一個名字進來的name
    [timeTreeObj setObject:self.timeTreeName forKey:@"tree_name"];
    
    // Create the treeContent class
    treeContent = [PFObject objectWithClassName:@"treeContent"];
    // Add a relation between the timeTreeObj and treeContent （timeTreeObj obj關聯->樹內容）
    timeTreeObj[@"treeContent"] = treeContent;
    [timeTreeObj saveInBackground];
    
    /*
    [timeTreeObj saveInBackgroundWithBlock:^(BOOL finishSave,NSError *error){
        
        if (finishSave) {
//            NSString *timeTreeObjId=timeTreeObj.objectId;
// save to array in other class

#warning to do , 增加樹的那邊也需save id
            //存整包物件
            DataTimeTreeObj *dataObj=[[DataTimeTreeObj alloc]initObj:timeTreeObj];
            [DataTimeTreeObj saveTimeTreeObj:dataObj];
        }
        
        
        if (error) {
            UIAlertView *av=[[UIAlertView alloc]initWithTitle:nil message:error.description delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [av show];
        }
    }];
     */
}

#pragma mark - action
//-(void)eventAlertView{
//
//    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Content" bundle:nil];
//    EventVC *vc=[sb instantiateViewControllerWithIdentifier:@"eventVC"];
//    [self addChildViewController:vc];
//    [vc.view setBackgroundColor:[UIColor whiteColor]];
//    vc.evenLabel.text=self.cataStr;
//    vc.view.center = self.view.center;
//    [vc.view.layer setBorderWidth:1];
//    [vc.view.layer setBorderColor:[UIColor grayColor].CGColor];
//    [vc.view.layer setCornerRadius:8];
//    [self.view addSubview:vc.view];    
//}

-(void)tap:(id)sender{
    [self.view endEditing:YES];
}

- (IBAction)photoAction:(id)sender {
    UIActionSheet *actionSheet =[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take photo",@"Use album photo", nil];
    [actionSheet showInView:self.view];
}

- (IBAction)saveGo2NextView:(id)sender {
    // get textField and save to parse
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:
                             [NSIndexPath indexPathForRow:0 inSection:0]];
    UITextField *textField = (UITextField *)[cell.contentView viewWithTag:100];
    NSLog(@"text is %@",textField.text);
    
    // save to parse
    treeContent[@"content"]=textField.text;
#warning thinking save to PFFile ? text ?
    [treeContent saveInBackground];

#warning thinking 第一次for push 之後應該dismiss就好？
    // push to container
    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"TimeTree" bundle:nil];
    ContainerVC *vc=[sb instantiateViewControllerWithIdentifier:@"containerVC"];
    self.navigationController.navigationBarHidden=NO;
    [self.navigationController pushViewController:vc animated:YES];
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
    
#warning to do 圖片似乎要解壓縮，不然會大
    // pic to NSData -> PFFile
    NSData *picData=UIImagePNGRepresentation(self.img);
    PFFile *imgFile=[PFFile fileWithData:picData];
    treeContent[@"treeEventImgFile"]=imgFile;
    
#warning to do 內容圖片要加入不重複存
    [treeContent saveInBackground];
    
//    [imgFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        // Handle success or failure here ...
//    } progressBlock:^(int percentDone) {
//        // Update your progress spinner here. percentDone will be between 0 and 100.
//        NSLog(@"percentage %d",percentDone);
//    }];
    
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

    [cell.saveBtn addTarget:self action:@selector(saveGo2NextView:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}


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

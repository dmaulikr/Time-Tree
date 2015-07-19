//
//  TimeTreeTableVC.m
//  TimeTree
//
//  Created by Joseph on 2015/7/16.
//  Copyright (c) 2015年 dosomethingq. All rights reserved.
//

#import "TimeTreeTableVC.h"
#import "TimeTreeTableViewCell.h"
#import "NavigationVC.h"



@interface TimeTreeTableVC () 
{
    
}

@property (strong,nonatomic) NSArray *tempArray;

@end

@implementation TimeTreeTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Home Controller";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:(NavigationVC *)self.navigationController
                                                                            action:@selector(showMenu)];
 
 
    
// cell 直接建在tableViewController 不用寫以下註冊code
//    [self.tableView registerNib:[UINib nibWithNibName:@"TimeTreeTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    
    self.tempArray=@[@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    // Return the number of sections.
//    return 1;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
//    return self.tempArray.count;
    return 3;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 150;
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 80.0f;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identify=@"Cell";

    TimeTreeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify forIndexPath:indexPath];
    
    if (cell==nil) {
        cell=[[TimeTreeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    
//    [self.tableView setContentInset:UIEdgeInsetsMake(60, 0, 0, 0)];
    
    if (indexPath.row%2) {
        // odd
        [cell.rightButton setHidden:YES];
        [cell.leftButton setHidden:NO];
        
    }else{
        // even
        [cell.rightButton setHidden:NO];
        [cell.leftButton setHidden:YES];
    }
    
//    
//    for (NSInteger i=0; i<self.tempArray.count; i++) {
//        if (i%2) {
//            //odd
//            [cell.rightButton setHidden:YES];
//            [cell.leftButton setHidden:NO];
//            NSLog(@"odd");
//        }else{
//            //even
//            [cell.rightButton setHidden:NO];
//            [cell.leftButton setHidden:YES];
//            NSLog(@"even");
//        }
//    }
    
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

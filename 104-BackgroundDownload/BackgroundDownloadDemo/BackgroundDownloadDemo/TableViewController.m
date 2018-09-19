//
//  TableViewController.m
//  BackgroundDownloadDemo
//
//  Created by Jay on 7/9/18.
//  Copyright © 2018年 hkhust. All rights reserved.
//

#import "TableViewController.h"
#import "NSString+Object.h"
#include "SPBase64Data.h"
#import "DownItem.h"
#import "TableViewCell.h"
#include "TTDownloader.h"

@interface TableViewController ()

@property (nonatomic, strong) NSMutableArray *lists;
@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    NSArray *list = [SPBase64Data downloadList].toJSONObject;
    self.lists = [NSMutableArray array];
    
    [list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        DownItem *ITEM = [DownItem new];
        [ITEM setValuesForKeysWithDictionary:obj];
        [self.lists addObject:ITEM];
    }];
    
    
    NSLog(@"%s", __func__);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return self.lists.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DownItem *item = self.lists[indexPath.row];
    TableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [[TTDownloader defaultDownloader] beginDownload:item.down fileName:item.zhuti progress:^(CGFloat progress, NSString *url) {
        if([url isEqualToString:item.down]) item.progress.progress = progress;
        else item.progress.progress = 0.0;
    } speed:^(NSString *speed, NSString *url) {
        if([url isEqualToString:item.down]) item.speed.text = speed;
        else item.speed.text = nil;
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    DownItem *item = self.lists[indexPath.row];
    item.progress = cell.progress;
//    item.progressBolck = ^(CGFloat progress,NSString *url) {
////        NSLog(@"%s---%@----%f", __func__,item.zhuti,progress);
//        if([url isEqualToString:item.down]) item.progress.progress = progress;
////        else cell.progress.progress = 0.0;
//    };
//    item.speedBolck = ^(NSString *speed, NSString *url) {
////        if([url isEqualToString:item.down]) cell.speed.text = speed;
////        else cell.speed.text = nil;
//    };
    cell.textLabel.text = item.zhuti;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",item.status];
    // Configure the cell...
    
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

//
//  WeController.m
//  FM
//
//  Created by czljcb on 2017/10/8.
//  Copyright © 2017年 czljcb. All rights reserved.
//

#import "WeController.h"
#import "AboutController.h"
#import "LZDrumstickController.h"
#import "LZAdViewController.h"

#import "WeCell.h"
#import "ZDYCacheCell.h"

#import "LZCommon.h"
#import "UIView+Extension.h"


@interface WeController ()

@property (nonatomic, strong) NSArray <NSArray *>*titles;

@property (nonatomic, strong) UILabel *timerLabel;

@end

@implementation WeController

-(UILabel *)timerLabel {
    if (_timerLabel == nil) {
        _timerLabel = [[UILabel alloc] init];
    }
    return _timerLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
}


- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)setUI {
    self.title = @"我的";
    
    self.titles = @[
                    
                    @[
                        @{@"name":@"解锁所有功能",@"img":@"购物",@"des":@"移除广告"},
                        @{@"name":@"请我吃个鸡腿",@"img":@"鸡腿-1",@"des":@""}
                        ],
                    @[
//                        @{@"name":@"我的收藏",@"img":@"love it",@"des":@""},
                        @{@"name":@"分享应用",@"img":@"share",@"des":@""},
                        @{@"name":@"好评反馈",@"img":@"ic_rate_review",@"des":@""},
                        @{@"name":@"联系我们",@"img":@"联系人",@"des":@""},
                        @{@"name":@"清除缓存",@"img":@"清理缓存",@"des":@""}
                        ]
                    ];
    
    
    
    self.tableView.rowHeight = 50;
    [self.tableView registerNib:[UINib nibWithNibName:@"WeCell" bundle:nil] forCellReuseIdentifier:@"WeCellID"];
    [self.tableView registerClass:[ZDYCacheCell class] forCellReuseIdentifier:@"CacheCellID"];
    self.tableView.tableFooterView = [UIView new];
    
    UIView *headerView = [[UIView alloc] initWithFrame:self.view.bounds];
    headerView.height = kScreenW * 160.0 / 375;
    headerView.backgroundColor = [UIColor clearColor];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, headerView.height-0.3, headerView.width, 0.3)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [headerView addSubview:lineView];
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_title"]];
    //iconImageView.backgroundColor = [UIColor redColor];
    //    iconImageView.width = 60;
    //    iconImageView.height = 60;
    iconImageView.center = CGPointMake(headerView.width/2, headerView.height/2);
    //iconImageView.layer.cornerRadius = 30;
    //iconImageView.layer.masksToBounds = YES;
    //iconImageView.image = [UIImage imageNamed:@"logo"];
    [headerView addSubview:iconImageView];
    
    //    UILabel *appNameLabel = [[UILabel alloc] init];
    //    appNameLabel.text = @"图云FM";
    //    appNameLabel.font = [UIFont systemFontOfSize:25];
    //    [appNameLabel sizeToFit];
    //    appNameLabel.x = iconImageView.maxX + 10;
    //    appNameLabel.centerY = iconImageView.centerY;
    //    appNameLabel.textColor = [UIColor blackColor];
    //    [headerView addSubview:appNameLabel];
    
    UILabel *benLabel = [[UILabel alloc] init];
    //benLabel.text = @"版本号：1.0.0";
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [info valueForKey:@"CFBundleShortVersionString"];
    NSString *buildVersion = [info valueForKey:@"CFBundleVersion"];
    benLabel.text = [NSString stringWithFormat:@"版本号：%@ (BUILD  %@)",version,buildVersion];
    
    benLabel.font = [UIFont systemFontOfSize:15];
    [benLabel sizeToFit];
    benLabel.centerX = headerView.centerX;
    benLabel.y = headerView.height - 20 - benLabel.height;//iconImageView.maxY + 20;
    benLabel.textColor = [UIColor lightGrayColor];
    [headerView addSubview:benLabel];
    
    self.tableView.tableHeaderView = headerView;
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.titles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.titles[section].count;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *line = [UIView new];
    line.backgroundColor = kBackgroundColor;
    return line;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *model = self.titles[indexPath.section][indexPath.row];

    if (indexPath.row == 3) {
        ZDYCacheCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CacheCellID" forIndexPath:indexPath];
        cell.iconImageView.image = [UIImage imageNamed:model[@"img"]];
        cell.update = YES;
        return cell;
    }else {
    
        WeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WeCellID" forIndexPath:indexPath];
        
        cell.nameLabel.text = model[@"name"];
        cell.iconImageView.image = [UIImage imageNamed:model[@"img"]];
        cell.desLabel.text = model[@"des"];

        return cell;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (!indexPath.section) {
        switch (indexPath.row) {
            case 0:
            {
                LZAdViewController *vc = [[LZAdViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];

            }
                break;
            case 1:
            {
                LZDrumstickController *vc = [[LZDrumstickController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;

            default:
                break;
        }
        return;
    }
    
    switch (indexPath.row) {
        case 1:
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id1297897150?action=write-review"]];

        }
            break;
        case 0:
        {
            NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com/cn/app/%E9%A6%99%E6%B8%AF%E7%94%B5%E5%8F%B0-%E9%A6%99%E6%B8%AF%E5%B9%BF%E6%92%AD%E7%94%B5%E5%8F%B0-hk-radio-%E8%A6%81%E5%90%AC%E5%90%AC%E9%A6%99%E6%B8%AF%E6%94%B6%E9%9F%B3%E6%9C%BA/id1297897150?mt=8&uo=4"];
            
            UIActivityViewController * activityCtl = [[UIActivityViewController alloc]initWithActivityItems:@[url] applicationActivities:nil];
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                [self  presentViewController:activityCtl animated:YES completion:nil];
            }else {
                WeCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:activityCtl];
                [popup presentPopoverFromRect:CGRectMake(cell.width/2, cell.height/4, 0, 0) inView:cell permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
            }

        }
            break;
        case 2:
        {
            AboutController *aboutVC = [AboutController new];
            aboutVC.title = @"联系我们";
            [self.navigationController pushViewController:aboutVC animated:YES];

        }
            break;
        case 3:
        {
            UIAlertController *alerVc = [UIAlertController alertControllerWithTitle:@"是否清除缓存?" message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            UIAlertAction *alert = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                ZDYCacheCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                [cell removeCache];
                
            }];
            
            [alerVc addAction:alertAction];
            [alerVc addAction:alert];
            
            [self presentViewController:alerVc animated:YES completion:nil];

        }
            break;

        default:
            break;
    }
    
}


@end

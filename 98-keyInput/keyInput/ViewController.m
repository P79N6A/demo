//
//  ViewController.m
//  keyInput
//
//  Created by Jay on 27/8/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "ViewController.h"
#import "UIView+LayoutMethods.h"
#import "UIView+HandyAutoLayout.h"

@interface ViewController ()

@end

@implementation ViewController
//获取网络时间
- (void)getNetWorkDateSuccess:(void(^)(NSDate *networkDate, NSString *networkDateStr))success {
    NSString *urlString = @"https://www.baidu.com";
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString: urlString]];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [request setTimeoutInterval:5];
    [request setHTTPShouldHandleCookies:FALSE];
    [request setHTTPMethod:@"GET"];
    __block NSDate *localDate;
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (!connectionError) {
            //要把网络数据强转 不然用不了下面那个方法获取不到内容（个人感觉，不知道对不）
            NSHTTPURLResponse *responsee = (NSHTTPURLResponse *)response;
            NSString *date = [[responsee allHeaderFields] objectForKey:@"Date"];
            date = [date substringFromIndex:5];
            date = [date substringToIndex:[date length]-4];
            NSDateFormatter *dMatter = [[NSDateFormatter alloc] init];
            dMatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
            [dMatter setDateFormat:@"dd MMM yyyy HH:mm:ss"];
            //处理八小时问题-这里获取到的是标准时间
            NSDate *netDate = [dMatter dateFromString:date];
            NSTimeZone *zone = [NSTimeZone systemTimeZone];
            NSInteger interval = [zone secondsFromGMTForDate:netDate];
            NSLog(@"interval: %ld", interval);
            localDate = [netDate dateByAddingTimeInterval: interval];
            NSLog(@"%@________1",localDate);
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
            NSString *nowtimeStr = [NSString string];
            nowtimeStr = [formatter stringFromDate:localDate];
            NSLog(@"%@--------2",nowtimeStr);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (success) {
                    success(localDate, nowtimeStr);
                }
            });
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                //[MBProgressHUD showError:@"网络异常, 请稍后重试"];
            });
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self getNetWorkDateSuccess:^(NSDate *networkDate, NSString *networkDateStr) {
        NSLog(@"%s", __func__);
    }];
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    
    [view setCt_size:CGSizeMake(200, 200)];
    [view centerEqualToView:self.view];
//    [self.view addConstraint:[view constraintWidth:200]];
//
//   NSLayoutConstraint * h = [view constraintHeightEqualToView:self.view];
//    [self.view addConstraint:h];
//
//    [self.view addConstraint:[view constraintCenterXEqualToView:self.view]];
//    [self.view addConstraint:[view constraintCenterYEqualToView:self.view]];

    //for auto layout:
//
//        [self.view addConstraint:[self.tableView constraintCenterXEqualToView:self.view]];
//    [self.view addConstraint:[self.tableView constraintWidthEqualToView:self.view]];
//
//    [self.view addConstraints:[self.nextStepButton constraintsSize:CGSizeMake(300.0f, 40.0f)]];
//    [self.view addConstraint:[self.nextStepButton constraintCenterXEqualToView:self.view]];
    //for frame:
        
//        [self.subtitleLabel leftEqualToView:self.titleLabel];
//    [self.subtitleLabel top:14 FromView:self.timeLabel];
//
//    [self.createPost centerXEqualToView:self.view];
//    [self.createPost bottomInContainer:19.0f shouldResize:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

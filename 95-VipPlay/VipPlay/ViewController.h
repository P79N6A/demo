//
//  ViewController.h
//  VipPlay
//
//  Created by Jay on 24/8/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AXWebViewController/AXWebViewController.h>

@interface ViewController : AXWebViewController


@end


@interface ListController : UITableViewController

@property (nonatomic, strong) NSMutableArray <NSString *>*mediaObjs;
@property (nonatomic, copy) void (^didSelectItemBlock)(NSString *url);
@end

//
//  SPWebViewController.h
//  riyutv
//
//  Created by Jay on 30/9/18.
//  Copyright © 2018年 HKDramaFan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPWebViewController : UIViewController
@property (nonatomic, copy) NSString *url;
@property (nonatomic, strong) NSArray <NSString *> *filter;
@property (nonatomic, strong) NSArray <NSString *> *js;
@end

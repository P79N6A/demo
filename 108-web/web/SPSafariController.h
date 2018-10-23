//
//  SPSafariController.h
//  web
//
//  Created by Jay on 19/10/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SPSafariController : UIViewController

- (void)listButtonClicked:(id)sender;

- (void)vipButtonClicked:(id)sender;

- (void)failLoadWithError:(NSError *)error;

- (void)loadURL:(NSURL*)URL;

@end

NS_ASSUME_NONNULL_END

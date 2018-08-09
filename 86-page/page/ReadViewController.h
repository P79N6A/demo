//
//  ReadViewController.h
//  page
//
//  Created by Jay on 7/8/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPReadView.h"


@interface ReadViewController : UIViewController

@property (nonatomic, assign) NSInteger chapter;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, copy) NSString *content;

@end

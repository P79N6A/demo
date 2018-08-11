//
//  ReadViewController.h
//  page
//
//  Created by Jay on 7/8/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPReadView.h"

@class SPChapterModel;

@interface ReadViewController : UIViewController

@property (nonatomic, assign) NSInteger chapter;
@property (nonatomic, assign) NSInteger page;
//@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong) SPChapterModel *model;
@end

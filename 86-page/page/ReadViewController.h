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
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet SPReadView *readView;

@end

//
//  PlayViewController.h
//  audioPlayer
//
//  Created by Jay on 27/7/18.
//  Copyright © 2018年 Jayson. All rights reserved.
//

#import <UIKit/UIKit.h>




@protocol PlayViewControllerDelegate <NSObject>

-(void)dismiss;

@end

@interface PlayViewController : UIViewController

@property(nonatomic,weak)id<PlayViewControllerDelegate> delegate;

@end

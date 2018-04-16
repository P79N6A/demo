//
//  NELivePlayerViewController.h
//  NELivePlayerDemo
//
//  Created by BiWei on 15-10-10.
//  Copyright (c) 2015年 netease. All rights reserved.
//

#import <UIKit/UIKit.h>


#import <NELivePlayer.h>
#import <NELivePlayerController.h>


@class NELivePlayerControl;
@interface NELivePlayerViewController : UIViewController

@property(nonatomic, strong) NSURL *url;
@property(nonatomic, strong) NSString *decodeType;
@property(nonatomic, strong) NSString *mediaType;
@property(nonatomic, strong) id<NELivePlayer> liveplayer;
@property(nonatomic, strong) dispatch_source_t timer;

- (id)initWithURL:(NSURL *)url andDecodeParm:(NSMutableArray *)decodeParm;

+ (void)presentFromViewController:(UIViewController *)viewController withTitle:(NSString *)title URL:(NSURL *)url andDecodeParm:(NSMutableArray *)decodeParm completion:(void(^)())completion;

@property(nonatomic, strong) IBOutlet NELivePlayerControl *mediaControl;

@end


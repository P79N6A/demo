//
//  NELivePlayerControl.h
//  NELivePlayerDemo
//
//  Created by BiWei on 15-10-12.
//  Copyright (c) 2015年 netease. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol NELivePlayer;

@interface NELivePlayerControl : UIControl


@property(nonatomic, weak) id<NELivePlayer> delegatePlayer;

@end

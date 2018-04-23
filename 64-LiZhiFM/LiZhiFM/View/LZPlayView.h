//
//  LZPlayView.h
//  LiZhiFM
//
//  Created by czljcb on 2018/4/21.
//  Copyright © 2018年 czljcb. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LZliveChannelModel;


typedef NS_ENUM(NSUInteger, LZPlayViewState) {
    LZPlayViewStateNotShow = 0,//
    LZPlayViewStateShow = 1 //
};

@interface LZPlayView : UIView

@property (nonatomic, copy) void(^move)(LZPlayViewState state);

@property (nonatomic, strong) LZliveChannelModel *model;

+ (instancetype)playView;

@end

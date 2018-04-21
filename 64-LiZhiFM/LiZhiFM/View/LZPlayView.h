//
//  LZPlayView.h
//  LiZhiFM
//
//  Created by czljcb on 2018/4/21.
//  Copyright © 2018年 czljcb. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LZliveChannelModel;
@interface LZPlayView : UIView

@property (nonatomic, copy) void(^move)(CGFloat);

@property (nonatomic, strong) LZliveChannelModel *model;

+ (instancetype)playView;

@end

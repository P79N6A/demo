//
//  TTZPlayer.h
//  player
//
//  Created by Jay on 2018/3/26.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TTZPlayerModel<NSObject>

@property (nonatomic, copy, readonly) NSString *url;

@end

@interface TTZPlayer : NSObject

+ (instancetype)sharedInstance;

/** 加载中 */
@property (nonatomic, copy) void (^playerLoading)(void);

/** 加载完毕 */
@property (nonatomic, copy) void (^playerCompletion)(void);


-(void)play;

-(void)stop;

-(void)pause;


@property (nonatomic, assign) BOOL isPlaying;

@property (nonatomic, strong) id<TTZPlayerModel> model;

-(void)playWithModel:(id<TTZPlayerModel>)model;

@end

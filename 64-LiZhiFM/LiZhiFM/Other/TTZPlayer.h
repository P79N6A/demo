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
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *icon;
@property (nonatomic, copy, readonly) NSString *main;
@property (nonatomic, copy, readonly) NSString *des;

@end

@interface TTZPlayer : NSObject

+ (instancetype)defaultPlayer;

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

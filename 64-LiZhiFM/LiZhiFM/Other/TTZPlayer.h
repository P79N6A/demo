//
//  TTZPlayer.h
//  player
//
//  Created by Jay on 2018/3/26.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import <Foundation/Foundation.h>



@protocol TTZPlayerModel<NSObject>

@property (nonatomic, copy, readonly) NSString *live_stream;
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *img;
@property (nonatomic, copy, readonly) NSString *liveSectionName;

@end


typedef void(^PlayerLoading)(void);
typedef void(^PlayerCompletion)(void);

@interface TTZPlayer : NSObject

+ (instancetype)defaultPlayer;

-(void)play;

-(void)stop;

-(void)pause;


@property (nonatomic, assign) BOOL isPlaying;

@property (nonatomic, strong) id<TTZPlayerModel> model;

-(void)playWithModel:(id<TTZPlayerModel>)model
        onStartCache:(PlayerLoading)loading
          onEndCache:(PlayerCompletion)completion;

@end

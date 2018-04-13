//
//  TTZTagView.m
//  9*9
//
//  Created by Jay on 2018/4/3.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "TTZTagView.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>


@implementation TTZModel
@end
@implementation TTZMoveView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.textAlignment = NSTextAlignmentCenter;
        self.font = [UIFont systemFontOfSize:34];
    }
    return self;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    !(_moveBlock)? : _moveBlock(self);
}

//- (void)setText:(NSString *)text{
//    [super setText:[NSString stringWithFormat:@"%@(%ld)",text,self.tag]];
//}

@end


@interface TTZTagView()
@property (nonatomic, strong) NSMutableArray <TTZModel *>*models;
@property (nonatomic, assign) CGRect emptyFrame;
@property (nonatomic, assign) NSInteger emptyIndex;
@end

@implementation TTZTagView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.models = [NSMutableArray array];
}


- (void)setLadder:(NSInteger)ladder{
    _ladder = ladder;
    [self.models removeAllObjects];
    
    for (NSInteger i = 0; i < ladder*ladder - 1; i++) {
        TTZModel *m = [TTZModel new];
        m.index = i;
        [self.models addObject:m];
    }
    
    
    TTZModel *model = [TTZModel new];
    model.index = NSIntegerMax;

    NSInteger rand = arc4random() % (self.models.count + 1);
    [self.models insertObject:model atIndex:rand];
    
    [self.models shuffle];
    
    [self setUI];

    
}

- (void)setUI{

    CGFloat spacing = 5;
    
    CGFloat w = ([UIScreen mainScreen].bounds.size.width - spacing * (self.ladder - 1)) * 1.0 / self.ladder;
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat h = w;
    
    for (NSInteger i = 0; i < self.models.count; i ++) {
       
        x = i% self.ladder * (w + spacing);
        y = i/ self.ladder * (h + spacing);

        TTZModel *model = self.models[i];
        
        if (model.index == NSIntegerMax) {
            self.emptyFrame =  CGRectMake(x, y, w, h);
            self.emptyIndex = i;
            continue;
        }

        
        TTZMoveView *move =  [[TTZMoveView alloc] initWithFrame:CGRectMake(x, y, w, h)];
        move.tag = i;
        model.view = move;
        move.backgroundColor = [UIColor orangeColor];
        move.text = [NSString stringWithFormat:@"%ld",(long)model.index];
        [self addSubview:move];
        move.moveBlock = ^(UIView *view) {

            CGFloat absx = fabs(view.frame.origin.x - self.emptyFrame.origin.x);
            CGFloat absy = fabs(view.frame.origin.y - self.emptyFrame.origin.y);

            if(CGRectEqualToRect(view.frame,self.emptyFrame)){
               
                
            }
            else if ([self A:view.frame.origin.y isEqualB:self.emptyFrame.origin.y] && absx <= w+spacing+5){
                [self move:view];
            }else if ([self A:view.frame.origin.x isEqualB:self.emptyFrame.origin.x] && absy <= h+spacing+5){
                [self move:view];
            }
        };

    }
    

}

- (void)move:(UIView *)view{
    [UIView animateWithDuration:0.25 animations:^{
        
        NSLog(@"%s-交换前的位置--%@", __func__,NSStringFromCGRect(self.emptyFrame ));
        CGRect tempFrame = view.frame;
        NSInteger tempTag = view.tag;
        
        view.frame = self.emptyFrame;
        view.tag = self.emptyIndex;
        
        [self.models exchangeObjectAtIndex:tempTag withObjectAtIndex:self.emptyIndex];
        
        self.emptyFrame = tempFrame;
        self.emptyIndex = tempTag;
        
        NSLog(@"%s-交换后的位置--%@", __func__,NSStringFromCGRect(self.emptyFrame ));
        
        
        __block NSInteger lastIdx = NSIntegerMax;
        
        [self.models enumerateObjectsUsingBlock:^(TTZModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSLog(@"%s--位置idx：%lu-->%ld", __func__,(unsigned long)idx,(long)obj.index);
            
            if (obj.index != idx ) {
                
                lastIdx = idx;
                *stop = YES;
            }
            
        }];
        
        if( lastIdx ==  self.models.count - 1 ){
            NSLog(@"%s----通关了", __func__);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"恭喜你" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"通关了", nil];
            [alert show];
            
            
            // 6. 开始播放
//            [self.player play];
//            SystemSoundID sound = [self loadSound:@"win.mp3"];
            // 播放音效
//            AudioServicesPlayAlertSound(sound);//在播放音效的同时会震动
            //AudioServicesPlaySystemSound(sound);
            [self play:@"win"];



        }
    }];
}

// 初始化音乐播放器
//- (AVAudioPlayer *)player
//{
//        // 1 初始化播放器需要指定音乐文件的路径
//        NSString *path = [[NSBundle mainBundle]pathForResource:@"win.mp3" ofType:nil];
//        // 2 将路径字符串转换成url，从本地读取文件，需要使用fileURL
//        NSURL *url = [NSURL fileURLWithPath:path];
//        // 3 初始化音频播放器
//        AVAudioPlayer *player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
//        // 4 设置循环播放
//        // 设置循环播放的次数
//        // 循环次数=0，声音会播放一次
//        // 循环次数=1，声音会播放2次
//        // 循环次数小于0，会无限循环播放
//        [player setNumberOfLoops:0];
//
//        [player setVolume:0.5];
//
//        // 5 准备播放
//        [player prepareToPlay];
//
//
//    return player;
//}

// 加载音效
//- (SystemSoundID)loadSound:(NSString *)soundFileName
//{
//    // 1. 需要指定声音的文件路径，这个方法需要加载不同的音效
//    NSString *path = [[NSBundle mainBundle]pathForResource:soundFileName ofType:nil];
//    // 2. 将路径字符串转换成url
//    NSURL *url = [NSURL fileURLWithPath:path];
//
//    // 3. 初始化音效
//    // 3.1 url => CFURLRef
//    // 3.2 SystemSoundID
//    SystemSoundID soundId;
//    // url先写个错的，然后让xcode帮我们智能修订，这里的方法不要硬记！
//    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &soundId);
//
//    return soundId;
//}

SystemSoundID soundID;


- (void)play:(NSString *)soundFileName{
    
    
    //    NSString *str = [[NSBundle mainBundle] pathForResource:@"vcyber_waiting" ofType:@"wav"];
    NSString *str = [[NSBundle mainBundle] pathForResource:soundFileName ofType:@"mp3"];
    //    NSString *str = [[NSBundle mainBundle] pathForResource:@"48s" ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:str];
    
    
    AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(url), &soundID);
    //
    //    AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, soundCompleteCallBack, NULL);
    //
    //    //AudioServicesPlaySystemSound(soundID);
    //
    //    AudioServicesPlayAlertSound(soundID);
    
    
    //    AudioServicesPlaySystemSoundWithCompletion(soundID, ^{
    //        NSLog(@"播放完成");
    //        AudioServicesDisposeSystemSoundID(soundID);
    //    });
    
    AudioServicesPlayAlertSoundWithCompletion(soundID, ^{
        NSLog(@"播放完成");
    });
    

}

- (BOOL)A:(CGFloat)a isEqualB:(CGFloat)b{
    NSInteger numA =  (NSInteger)a * 1000;
    NSInteger numB =  (NSInteger)b * 1000;

    return numA == numB;
}

- (void)reset{
    
    // 6. 开始播放
//    [self.player play];
//    SystemSoundID sound = [self loadSound:@"correct.mp3"];
    // 播放音效
    //AudioServicesPlayAlertSound(sound);//在播放音效的同时会震动
//    AudioServicesPlaySystemSound(sound);
    
    [self play:@"correct"];

    
    [self.models shuffle];
    
    CGFloat spacing = 5;
    CGFloat w = ([UIScreen mainScreen].bounds.size.width - spacing * (self.ladder - 1)) * 1.0 / self.ladder;
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat h = w;
    
    for (NSInteger i = 0; i < self.models.count; i ++) {
        
        x = i% self.ladder * (w + spacing);
        y = i/ self.ladder * (h + spacing);
        
        TTZModel *model = self.models[i];
        
        if (model.index == NSIntegerMax) {
            self.emptyFrame =  CGRectMake(x, y, w, h);
            self.emptyIndex = i;
            continue;
        }
        
        [self.subviews enumerateObjectsUsingBlock:^(__kindof TTZMoveView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

            if([model.view isEqual:obj]){
                NSLog(@"%s--tag--%ld", __func__,(long)obj.tag);
                obj.tag = i;
                [UIView animateWithDuration:0.25 animations:^{
                    obj.frame = CGRectMake(x, y, w, h);
                }];
                *stop = YES;
            }
        }];
    }
}



@end


@implementation NSMutableArray (Shuffling)
- (void)shuffle
{
    NSUInteger count = [self count];
    for (int i = 0; i < count; ++i) {
        int n = (arc4random() % (count - i)) + i;
        [self exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
}
@end

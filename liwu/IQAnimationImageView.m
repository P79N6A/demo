//
//  IQAnimationImageView.m
//  liwu
//
//  Created by czljcb on 2017/8/27.
//  Copyright © 2017年 czljcb. All rights reserved.
//

#import "IQAnimationImageView.h"

@implementation IQAnimationImageView

-(void)playAnim{
    _isDisplaying = YES;
    [self.filePaths enumerateObjectsUsingBlock:^(NSString * _Nonnull filePath, NSUInteger idx, BOOL * _Nonnull stop) {
        usleep(self.displayTime);//1s = 1000ms 1ms = 1000μs
        UIImage *image=[[UIImage alloc]initWithContentsOfFile:filePath];
        [self performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:YES];
    }];
    
    [self performSelectorOnMainThread:@selector(setImage:) withObject:nil waitUntilDone:YES];
    _isDisplaying = NO;
    

}

- (void)startAnimating
{
    [self performSelectorInBackground:@selector(playAnim)withObject:nil];
}

@end

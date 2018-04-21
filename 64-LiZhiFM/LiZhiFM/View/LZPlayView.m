//
//  LZPlayView.m
//  LiZhiFM
//
//  Created by czljcb on 2018/4/21.
//  Copyright © 2018年 czljcb. All rights reserved.
//

#import "LZPlayView.h"
#import "LZCommon.h"

@interface LZPlayView()

@property (weak, nonatomic) IBOutlet UIButton *lockBtn;


@end

@implementation LZPlayView

+ (instancetype)playView{
    return [[NSBundle mainBundle] loadNibNamed:@"LZPlayView" owner:nil options:nil].lastObject;
}

- (IBAction)lockAction:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    
    if (sender.isSelected) {
        !(_move)? : _move(ScreenHeight - 70-55);
    }
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
     if (!self.lockBtn.isSelected) !(_move)? : _move(self.frame.origin.y);
}

@end

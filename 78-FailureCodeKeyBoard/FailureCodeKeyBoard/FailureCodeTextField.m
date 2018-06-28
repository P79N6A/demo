//
//  FailureCodeTextField.m
//  FailureCodeKeyBoard
//
//  Created by Jay on 25/6/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "FailureCodeTextField.h"
#import "FailureCodeKeyBoard.h"

// iPhone X
#define  iPhoneX ([UIScreen mainScreen].bounds.size.width == 375.f && [UIScreen mainScreen].bounds.size.height == 812.f ? YES : NO)
// Tabbar safe bottom margin.
#define  kTabbarSafeBottomMargin         (iPhoneX ? 34.f : 0.f)


@implementation FailureCodeTextField

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
        
    }
    return self;
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if([UIMenuController sharedMenuController]) {
        [UIMenuController sharedMenuController].menuVisible = NO;
    }
    return NO;
}

- (void)setUI{
    
    CGFloat inset = 3;
    CGFloat keyBoardViewH = 260;
    CGFloat spacing = 6;
    CGFloat width = ([UIScreen mainScreen].bounds.size.width - 2 * inset - 4 * spacing) * 0.2;
    CGFloat smallHeight = 0.80;
    CGFloat height = (keyBoardViewH - 2 * inset - 4 * spacing) / (4 + smallHeight);

    NSArray *keyCodes = @[
                               @{
                                   @"code":@"E",
                                   @"img":@"",
                                   @"frame":[NSValue valueWithCGRect:CGRectMake(inset, inset, width, height * smallHeight)]
                                   },
                               
                               @{
                                   @"code":@"F",
                                   @"img":@"",
                                   @"frame":[NSValue valueWithCGRect:CGRectMake(inset + 1 * width + 1*spacing, inset, width, height * smallHeight)]
                                   },
                               @{
                                   @"code":@"A",
                                   @"img":@"",
                                   @"frame":[NSValue valueWithCGRect:CGRectMake(inset + 2 * width + 2*spacing, inset, width, height * smallHeight)]
                                   },
                               @{
                                   @"code":@"D",
                                   @"img":@"",
                                   @"frame":[NSValue valueWithCGRect:CGRectMake(inset + 3 * width + 3*spacing, inset, width, height * smallHeight)]
                                   },
                               @{
                                   @"code":@"收起",
                                   @"img":@"",
                                   @"frame":[NSValue valueWithCGRect:CGRectMake(inset + 4 * width + 4*spacing, inset, width, height * smallHeight)]
                                   },

                               @{
                                   @"code":@"P",
                                   @"img":@"",
                                   @"frame":[NSValue valueWithCGRect:CGRectMake(inset + 0 * width + 0*spacing, inset + smallHeight * height + 1*spacing, width, height)]
                                   },
                               @{
                                   @"code":@"1",
                                   @"img":@"",
                                   @"frame":[NSValue valueWithCGRect:CGRectMake(inset + 1 * width + 1*spacing, inset + smallHeight * height + 1*spacing, width, height)]
                                   },
                               @{
                                   @"code":@"2",
                                   @"img":@"",
                                   @"frame":[NSValue valueWithCGRect:CGRectMake(inset + 2 * width + 2*spacing, inset + smallHeight * height + 1*spacing, width, height)]
                                   },
                               @{
                                   @"code":@"3",
                                   @"img":@"",
                                   @"frame":[NSValue valueWithCGRect:CGRectMake(inset + 3 * width + 3*spacing, inset + smallHeight * height + 1*spacing, width, height)]
                                   },
                               @{
                                   @"code":@"推格",
                                   @"img":@"",
                                   @"frame":[NSValue valueWithCGRect:CGRectMake(inset + 4 * width + 4*spacing, inset + smallHeight * height + 1*spacing, width, height)]
                                   },
                               
                               @{
                                   @"code":@"B",
                                   @"img":@"",
                                   @"frame":[NSValue valueWithCGRect:CGRectMake(inset + 0 * width + 0*spacing, inset + (1 + smallHeight) * height + 2*spacing, width, height)]
                                   },
                               @{
                                   @"code":@"4",
                                   @"img":@"",
                                   @"frame":[NSValue valueWithCGRect:CGRectMake(inset + 1 * width + 1*spacing, inset + (1 + smallHeight) * height + 2*spacing, width, height)]
                                   },
                               @{
                                   @"code":@"5",
                                   @"img":@"",
                                   @"frame":[NSValue valueWithCGRect:CGRectMake(inset + 2 * width + 2*spacing, inset + (1 + smallHeight) * height + 2*spacing, width, height)]
                                   },
                               @{
                                   @"code":@"6",
                                   @"img":@"",
                                   @"frame":[NSValue valueWithCGRect:CGRectMake(inset + 3 * width + 3*spacing, inset + (1 + smallHeight) * height + 2*spacing, width, height)]
                                   },

                               @{
                                   @"code":@"确定",
                                   @"img":@"",
                                   @"frame":[NSValue valueWithCGRect:CGRectMake(inset + 4 * width + 4*spacing, inset + (1 + smallHeight) * height + 2*spacing, width, 3*height+2*spacing)]
                                   },
                               
                               @{
                                   @"code":@"C",
                                   @"img":@"",
                                   @"frame":[NSValue valueWithCGRect:CGRectMake(inset + 0 * width + 0*spacing, inset + (2 + smallHeight) * height + 3*spacing, width, height)]
                                   },
                               @{
                                   @"code":@"7",
                                   @"img":@"",
                                   @"frame":[NSValue valueWithCGRect:CGRectMake(inset + 1 * width + 1*spacing, inset + (2 + smallHeight) * height + 3*spacing, width, height)]
                                   },
                               @{
                                   @"code":@"8",
                                   @"img":@"",
                                   @"frame":[NSValue valueWithCGRect:CGRectMake(inset + 2 * width + 2*spacing, inset + (2 + smallHeight) * height + 3*spacing, width, height)]
                                   },
                               @{
                                   @"code":@"9",
                                   @"img":@"",
                                   @"frame":[NSValue valueWithCGRect:CGRectMake(inset + 3 * width + 3*spacing, inset + (2 + smallHeight) * height + 3*spacing, width, height)]
                                   },

                               @{
                                   @"code":@"U",
                                   @"img":@"",
                                   @"frame":[NSValue valueWithCGRect:CGRectMake(inset + 0 * width + 0*spacing, inset + (3 + smallHeight) * height + 4*spacing, width, height)]
                                   },
                               @{
                                   @"code":@"0",
                                   @"img":@"",
                                   @"frame":[NSValue valueWithCGRect:CGRectMake(inset + 1 * width + 1*spacing, inset + (3 + smallHeight) * height + 4*spacing, 3*width+2*spacing, height)]
                                   }

                               
                               ];
    
    FailureCodeKeyBoard *keyBoardView  = [FailureCodeKeyBoard new];
    keyBoardView.frame = CGRectMake(0, 0, 375, keyBoardViewH+kTabbarSafeBottomMargin);
    keyBoardView.codes = keyCodes;
    self.inputView = keyBoardView;
     __weak typeof(self) weakSelf = self;
    keyBoardView.clickBlock = ^(NSDictionary *codeObj) {
        NSString *code = codeObj[@"code"];
        if ([code isEqualToString:@"收起"] || [code isEqualToString:@"确定"]) {
            [weakSelf endEditing:YES];
            return ;
        }else if ([code isEqualToString:@"推格"]){
            
           if(weakSelf.hasText) weakSelf.text = [weakSelf.text substringToIndex:weakSelf.text.length-1];
            return;
        }
        weakSelf.text = [NSString stringWithFormat:@"%@%@",weakSelf.text,code];
    };
}


@end

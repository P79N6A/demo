//
//  TTZTagView.h
//  tagView
//
//  Created by Jay on 2018/3/9.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTZTagView : UIView
- (CGFloat)contentHeight:(NSArray<NSString *> *)models;
@property (nonatomic, strong) NSArray <NSString *> *models;
@end
@interface NSString (NSStringWidth)
- (CGFloat)stringWidthWithFont:(UIFont *)font height:(CGFloat)height;
@end

//
//  SPChapterModel.m
//  page
//
//  Created by Jay on 9/8/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "SPChapterModel.h"
#import "SPReadConfig.h"
#import "const.h"
#import <CoreText/CoreText.h>

@implementation SPChapterModel

- (void)setContent:(NSString *)content{
    _content = content;
    [self updateFont];
}

- (NSMutableArray<NSNumber *> *)pages{
    if (!_pages) {
        _pages = [NSMutableArray array];
    }
    return _pages;
}


-(void)updateFont
{
    [self paginateWithBounds:CGRectMake(0, 0,DZReaderContentFrame.size.width , DZReaderContentFrame.size.height)];
//    [self paginateWithBounds:[UIScreen mainScreen].bounds];
}



-(void)paginateWithBounds:(CGRect)bounds
{
    [self.pages removeAllObjects];
    
    NSAttributedString *attrString;
    CTFramesetterRef frameSetter;
    CGPathRef path;
    NSMutableAttributedString *attrStr;
    attrStr = [[NSMutableAttributedString  alloc] initWithString:self.content];
    
    
//    NSMutableDictionary *attribute = [NSMutableDictionary dictionary];
//    attribute[NSForegroundColorAttributeName] = [UIColor orangeColor];
//    attribute[NSFontAttributeName] = [UIFont systemFontOfSize:14.0];
//
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    paragraphStyle.lineSpacing = 10;
//    //paragraphStyle.paragraphSpacing = 10;
//    paragraphStyle.alignment = NSTextAlignmentJustified;
//    paragraphStyle.lineHeightMultiple = 1.0;
//    attribute[NSParagraphStyleAttributeName] = paragraphStyle;

    
    [attrStr setAttributes:SPReadConfig.attributeStyle range:NSMakeRange(0, attrStr.length)];
    
    attrString = [attrStr copy];
    
    frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef) attrString);
    path = CGPathCreateWithRect(bounds, NULL);
    int currentOffset = 0;
    int currentInnerOffset = 0;
    BOOL hasMorePages = YES;
    // 防止死循环，如果在同一个位置获取CTFrame超过2次，则跳出循环
    int preventDeadLoopSign = currentOffset;
    int samePlaceRepeatCount = 0;
    
    while (hasMorePages) {
        if (preventDeadLoopSign == currentOffset) {
            
            ++samePlaceRepeatCount;
            
        } else {
            
            samePlaceRepeatCount = 0;
        }
        
        if (samePlaceRepeatCount > 1) {
            // 退出循环前检查一下最后一页是否已经加上
            if (self.pages.count == 0) {
                [self.pages addObject:@(currentOffset)];
            }
            else {
                
                NSUInteger lastOffset = [[self.pages lastObject] integerValue];
                
                if (lastOffset != currentOffset) {
                    [self.pages addObject:@(currentOffset)];
                }
            }
            break;
        }
        
        [self.pages addObject:@(currentOffset)];
        
        CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(currentInnerOffset, 0), path, NULL);
        CFRange range = CTFrameGetVisibleStringRange(frame);
        if ((range.location + range.length) != attrString.length) {
            
            currentOffset += range.length;
            currentInnerOffset += range.length;
            
        } else {
            // 已经分完，提示跳出循环
            hasMorePages = NO;
        }
        if (frame) CFRelease(frame);
    }
    
    CGPathRelease(path);
    CFRelease(frameSetter);
    _pageCount = self.pages.count;
}

-(NSString *)stringOfPage:(NSUInteger)index
{
    NSUInteger local = [self.pages[index] integerValue];
    NSUInteger length;
    if (index<self.pageCount-1) {
        length=  [self.pages[index+1] integerValue] - [self.pages[index] integerValue];
    }
    else{
        length = _content.length - [self.pages[index] integerValue];
    }
    return [_content substringWithRange:NSMakeRange(local, length)];
}



@end

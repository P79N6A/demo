//
//  SPReadConfig.m
//  page
//
//  Created by Jay on 9/8/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "SPReadConfig.h"
#import "const.h"



@implementation SPReadConfig


+ (instancetype)defaultConfig{
    
    static dispatch_once_t onceToken;
    static SPReadConfig *instance = nil;

    dispatch_once(&onceToken, ^{
        
        instance = [[self alloc] init];
        
    });
    
    return instance;
}



- (instancetype)init
{
    self = [super init];
    if (self) {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"ReadConfig"];
        if (data) {
            NSKeyedUnarchiver *unarchive = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
            SPReadConfig *config = [unarchive decodeObjectForKey:@"ReadConfig"];
            [config addObserver:config forKeyPath:@"fontSize" options:NSKeyValueObservingOptionNew context:NULL];
            [config addObserver:config forKeyPath:@"lineSpace" options:NSKeyValueObservingOptionNew context:NULL];
            [config addObserver:config forKeyPath:@"fontColor" options:NSKeyValueObservingOptionNew context:NULL];
            //[config addObserver:config forKeyPath:@"themeColor" options:NSKeyValueObservingOptionNew context:NULL];
            [config addObserver:config forKeyPath:@"fontType" options:NSKeyValueObservingOptionNew context:NULL];
            [config addObserver:config forKeyPath:@"themeType" options:NSKeyValueObservingOptionNew context:NULL];

            return config;
        }
        
        _lineSpace = 10.0f;
        _fontSize = 14.0f;
        _fontColor = DZMColor_5;//[UIColor blackColor];
        //_themeColor = [UIColor whiteColor];
        _fontType = 0;
        _themeType = 0;
        
        [self addObserver:self forKeyPath:@"fontSize" options:NSKeyValueObservingOptionNew context:NULL];
        [self addObserver:self forKeyPath:@"lineSpace" options:NSKeyValueObservingOptionNew context:NULL];
        [self addObserver:self forKeyPath:@"fontColor" options:NSKeyValueObservingOptionNew context:NULL];
        //[self addObserver:self forKeyPath:@"themeColor" options:NSKeyValueObservingOptionNew context:NULL];
        [self addObserver:self forKeyPath:@"themeType" options:NSKeyValueObservingOptionNew context:NULL];

        [self addObserver:self forKeyPath:@"fontType" options:NSKeyValueObservingOptionNew context:NULL];

        [SPReadConfig updateLocalConfig:self];
        
    }
    return self;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    [SPReadConfig updateLocalConfig:self];
}
+(void)updateLocalConfig:(SPReadConfig *)config{
    NSMutableData *data=[[NSMutableData alloc]init];
    NSKeyedArchiver *archiver=[[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [archiver encodeObject:config forKey:@"ReadConfig"];
    [archiver finishEncoding];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"ReadConfig"];
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeDouble:self.fontSize forKey:@"fontSize"];
    [aCoder encodeDouble:self.lineSpace forKey:@"lineSpace"];
    [aCoder encodeObject:self.fontColor forKey:@"fontColor"];
    //[aCoder encodeObject:self.themeColor forKey:@"themeColor"];
    [aCoder encodeInteger:self.fontType forKey:@"fontType"];
    [aCoder encodeInteger:self.themeType forKey:@"themeType"];

}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.fontSize = [aDecoder decodeDoubleForKey:@"fontSize"];
        self.lineSpace = [aDecoder decodeDoubleForKey:@"lineSpace"];
        self.fontColor = [aDecoder decodeObjectForKey:@"fontColor"];
        //self.themeColor = [aDecoder decodeObjectForKey:@"themeColor"];
        self.themeType = [aDecoder decodeIntegerForKey:@"themeType"];

        self.fontType = [aDecoder decodeIntegerForKey:@"fontType"];
    }
    return self;
}

- (UIColor *)themeColor{
    return @[[UIColor whiteColor],DZMReadBGColor_1,DZMReadBGColor_2,DZMReadBGColor_3,DZMReadBGColor_4,DZMReadBGColor_5][self.themeType];
}


+ (UIFont *)readFont{
    NSInteger type = SPReadConfig.defaultConfig.fontType;
    if (type == 3) {
        return [UIFont fontWithName:@"Papyrus" size:SPReadConfig.defaultConfig.fontSize];
    }else if (type == 2){
        return [UIFont fontWithName:@"AmericanTypewriter-Light" size:SPReadConfig.defaultConfig.fontSize];
    }else if (type == 1){
        return [UIFont fontWithName:@"EuphemiaUCAS-Italic" size:SPReadConfig.defaultConfig.fontSize];
    }
    
    return [UIFont systemFontOfSize:SPReadConfig.defaultConfig.fontSize];
}


+ (NSMutableDictionary *)attributeStyle{
    NSMutableDictionary *attribute = [NSMutableDictionary dictionary];
    attribute[NSForegroundColorAttributeName] = SPReadConfig.defaultConfig.fontColor;
    attribute[NSFontAttributeName] = self.readFont;
    
    /*
     NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
     
     paragraphStyle.lineSpacing = 20.;// 行间距
     paragraphStyle.lineHeightMultiple = 1.5;// 行高倍数（1.5倍行高）
     paragraphStyle.firstLineHeadIndent = 30.0f;//首行缩进
     paragraphStyle.minimumLineHeight = 10;//最低行高
     paragraphStyle.maximumLineHeight = 20;//最大行高(会影响字体)
     
     paragraphStyle.alignment = NSTextAlignmentLeft;// 对齐方式
     paragraphStyle.defaultTabInterval = 144;// 默认Tab 宽度
     paragraphStyle.headIndent = 20;// 起始 x位置
     paragraphStyle.tailIndent = 320;// 结束 x位置（不是右边间距，与inset 不一样）
     
     paragraphStyle.paragraphSpacing = 44.;// 段落间距
     paragraphStyle.paragraphSpacingBefore = 44.;// 段落头部空白(实测与上边的没差啊？)
     
     
     paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;// 分割模式

     NSLineBreakByWordWrapping = 0,      // Wrap at word boundaries, default
     NSLineBreakByCharWrapping,  // Wrap at character boundaries
     NSLineBreakByClipping,  // Simply clip
     NSLineBreakByTruncatingHead, // Truncate at head of line: "...wxyz"
     NSLineBreakByTruncatingTail, // Truncate at tail of line: "abcd..."
     NSLineBreakByTruncatingMiddle // Truncate middle of line:  "ab...yz"
     
    
    
     paragraphStyle.baseWritingDirection = NSWritingDirectionRightToLeft;// 段落方向

     NSWritingDirectionNatural       = -1,    // Determines direction using the Unicode Bidi Algorithm rules P2 and P3
     NSWritingDirectionLeftToRight   =  0,    // Left to right writing direction
     NSWritingDirectionRightToLeft   =  1
    
     */
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = SPReadConfig.defaultConfig.lineSpace;
    //paragraphStyle.paragraphSpacing = 10;
    paragraphStyle.alignment = NSTextAlignmentJustified;
    paragraphStyle.lineHeightMultiple = 1.0;
    attribute[NSParagraphStyleAttributeName] = paragraphStyle;
    return attribute;
}

@end

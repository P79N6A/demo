//
//  TTZBanner.m
//  English
//
//  Created by czljcb on 2018/4/13.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "TTZBanner.h"

#import <UIImageView+WebCache.h>

@implementation TTZBanner

+ (instancetype)headerView{
    return [[NSBundle mainBundle] loadNibNamed:@"TTZBanner" owner:nil options:nil].lastObject;
}
- (void)awakeFromNib{
    [super awakeFromNib];
    NSString *url = @"https://upload-images.jianshu.io/upload_images/1274527-725bdc5a0ef5a899.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240";
    [self.logoIV sd_setImageWithURL:[NSURL URLWithString:url]];

}

@end

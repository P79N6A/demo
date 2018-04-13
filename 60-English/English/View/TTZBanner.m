//
//  TTZBanner.m
//  English
//
//  Created by czljcb on 2018/4/13.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "TTZBanner.h"

@implementation TTZBanner

+ (instancetype)headerView{
    return [[NSBundle mainBundle] loadNibNamed:@"TTZBanner" owner:nil options:nil].lastObject;
}
@end

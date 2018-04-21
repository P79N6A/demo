//
//  LZliveChannelModel.m
//  LiZhiFM
//
//  Created by czljcb on 2018/4/21.
//  Copyright © 2018年 czljcb. All rights reserved.
//

#import "LZliveChannelModel.h"
@implementation LZStreamModel
@end


@implementation LZliveChannelModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"streams" : [LZStreamModel class]};
}

@end

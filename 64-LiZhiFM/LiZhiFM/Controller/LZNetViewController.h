//
//  LZNetViewController.h
//  LiZhiFM
//
//  Created by czljcb on 2018/4/21.
//  Copyright © 2018年 czljcb. All rights reserved.
//

#import "LZBaseViewController.h"

@class LZliveChannelModel;
@interface LZNetViewController : LZBaseViewController
@property (nonatomic, strong) NSArray <LZliveChannelModel *> *models;
@end

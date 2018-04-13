//
//  KDSModel.h
//  player
//
//  Created by Jay on 2018/3/26.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTZPlayer.h"

@interface KDSModel : NSObject <TTZPlayerModel>
@property (nonatomic, copy) NSString *url;
@end

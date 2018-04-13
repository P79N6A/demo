//
//  Model.h
//  English
//
//  Created by Jay on 2018/4/12.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlayerView.h"
@interface Model : NSObject <TTZPlayerModel>

@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *name;

@end

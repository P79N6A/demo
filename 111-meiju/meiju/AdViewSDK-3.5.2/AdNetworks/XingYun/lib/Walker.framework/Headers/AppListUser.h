//
//  Created by cq on 14-2-15.
//  Copyright (c) 2014年 cq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppList.h"

@interface AppListUser : NSObject


+(void)earn:(id<AppListDelegate>)_delegate;;//查询积分
+(void)consumption:(int)_score delegate:(id<AppListDelegate>)_delegate;//消耗积分
@end

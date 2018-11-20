//
//
//  Created by zhang cheng
//  Copyright (c) 2014年 faf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdLog : NSObject

+ (void)debug:(NSString *)message;

+ (void)setDebugEnabled:(BOOL)enabled;

@end

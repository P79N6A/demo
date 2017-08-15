//
//  NSObject+Extension.h
//  extension
//
//  Created by czljcb on 2017/8/12.
//  Copyright © 2017年 czljcb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Extension)

-(void)perform:(void (^)(void))performBlock;

-(void)perform:(void (^)(void))performBlock andDelay:(NSTimeInterval)delay;


@end

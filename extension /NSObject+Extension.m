//
//  NSObject+Extension.m
//  extension
//
//  Created by czljcb on 2017/8/12.
//  Copyright © 2017年 czljcb. All rights reserved.
//

#import "NSObject+Extension.h"

@implementation NSObject (Extension)
-(void)perform:(void (^)(void))performBlock{
    
    performBlock();
    
}

-(void)perform:(void (^)(void))performBlock andDelay:(NSTimeInterval)delay{
    
    [self performSelector:@selector(perform:) withObject:(__bridge id)Block_copy((__bridge const void *)performBlock) afterDelay:delay];
    
    Block_release((__bridge const void *)performBlock);
}

@end

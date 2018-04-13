//
//  NSError+Message.h
//  Hello
//
//  Created by FEIWU888 on 2017/10/11.
//  Copyright © 2017年 广州飞屋网络. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (Message)
- (NSError *)getError:(NSError *)error;
@end

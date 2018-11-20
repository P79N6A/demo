//
//  Created by cq on 14-2-15.
//  Copyright (c) 2014年 cq. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GuInitServer : NSObject<NSURLConnectionDelegate>

-(void) setInfo:(NSString*)appkey Channel:(NSString*)channel User_info:(NSString*)user_info;

@end

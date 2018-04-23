//
//  TTFUpLoadServer.h
//  upload
//
//  Created by Jay on 2018/3/1.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTFUpLoadServer : NSObject
- (void)uploadFormData:(NSData *)data
                    url:(NSString *)url
            parameters:(NSDictionary*)parameters
                  name:(NSString *)name
              fileName:(NSString *)fileName;
@end

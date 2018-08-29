//
//  SPIQYVideo.h
//  VipPlay
//
//  Created by Jay on 27/8/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPIQYVideo : NSObject

+ (instancetype)sharedVideo;


@end

@interface HybridNSURLProtocol : NSURLProtocol

@end

@interface NSURLProtocol (WKWebVIew)

+ (void)wk_registerScheme:(NSString*)scheme;

+ (void)wk_unregisterScheme:(NSString*)scheme;


@end

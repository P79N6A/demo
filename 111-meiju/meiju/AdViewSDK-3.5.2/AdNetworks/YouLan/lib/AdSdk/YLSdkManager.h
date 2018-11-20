//
//  SdkManager.h
//  AdSdk
//
//  Created by youlan-sligner on 2017/10/21.
//  Copyright © 2017年 youlanad-sligner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLSdkManager : NSObject

+(void) setLogModel:(BOOL) logModel;

+(BOOL) isLog;

+(void) setClientId:(NSString *) clientId;

+(NSString *) getClientId;

@end

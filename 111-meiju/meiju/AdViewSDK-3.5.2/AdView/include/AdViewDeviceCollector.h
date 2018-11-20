//
//  AdViewDeviceCollector.h
//  AdViewDeviceCollector
//
//  Created by Zhang Kerberos on 11-9-9.
//  Copyright 2011年 Access China. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AdViewCommonDef.h"

@class AdViewDeviceCollector;

@protocol AdViewDeviceCollectorDelegate <NSObject>
@required
- (NSString*) appKey;
@optional
- (NSString*) marketChannel;
@end

@interface AdViewDeviceCollector : NSObject
@property (nonatomic, weak) id<AdViewDeviceCollectorDelegate> delegate;
@property (nonatomic, retain) NSString *uuid;
@property (nonatomic, retain) NSString *idfa;
@property (nonatomic, retain) NSString *idfv;

+ (AdViewDeviceCollector*) sharedDeviceCollector;
- (NSString*) deviceId;
- (NSString*) deviceModel;
- (NSString*) systemVersion;
- (NSString*) systemName;
- (NSString*) screenResolution;
- (NSString*) serviceProviderCode;
- (NSString*) networkType;
- (void) postDeviceInformation:(AdViewSDKType)sdkType;

+ (NSString *)myIdentifier;
+ (NSString *)myIdfa;
+ (NSString *)myIdfv;

- (NSString*) getIdfa;
- (NSString*) getIdfv;

@end
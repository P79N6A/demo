/*
 
 AdViewConfigStore.h
 
 Copyright 2010 www.adview.cn
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 
 */

#import <Foundation/Foundation.h>
#import "AdViewCommonDef.h"
#import "AdViewConfig.h"
#import "AWNetworkReachabilityDelegate.h"

@class AWNetworkReachabilityWrapper;
@class AdViewDBManager;

typedef enum tagConfigMethod {
    ConfigMethod_DataFile = 0,
    ConfigMethod_OfflineFile = 1,
}ConfigMethod;

@interface AdViewConfigStoreData : NSObject {
    NSMutableDictionary *configs_;
    AdViewDBManager *dbManager;
}

@property  (retain) NSMutableDictionary *configs_;
@property  (retain) AdViewDBManager *dbManager;

@end

@class ConfigFetchItem;

@protocol ConfigFetchItemDelegate

-(void)configFetchFinished:(ConfigFetchItem*)item;
-(void)configFetchFailed:(ConfigFetchItem*)item;

-(void)configFetchToStore:(ConfigFetchItem*)item;

@end

@interface ConfigFetchItem : NSObject<AWNetworkReachabilityDelegate> {
    NSObject<ConfigFetchItemDelegate> __weak *delegate;
    
    AdViewConfig *fetchingConfig;
    NSMutableArray *configObjs;
    AWNetworkReachabilityWrapper *reachability;
    NSURLConnection *connection;
    NSMutableData *receivedData;
    int		reachCheckNum;
}

@property (weak) NSObject<ConfigFetchItemDelegate> *delegate;

@property (strong) AdViewConfig *fetchingConfig;
@property (strong) NSMutableArray *configObjs;
@property (strong) AWNetworkReachabilityWrapper *reachability;
@property (strong) NSURLConnection *connection;
@property (strong) NSMutableData *receivedData;
@property (assign) int		reachCheckNum;

@end

// Singleton class to store AdView configs, keyed by appKey. Fetched config
// is cached unless it is force-fetched using fetchConfig. Checks network
// reachability using AWNetworkReachabilityWrapper before making connections to
// fetch configs, so that that means it will wait forever until the config host
// is reachable.
@interface AdViewConfigStore : NSObject <ConfigFetchItemDelegate> {
    NSMutableDictionary *fetchObjs;
    AdViewConfigStoreData   *storeData_;
}

// Returns the singleton AdViewConfigStore object.
+ (AdViewConfigStore *)sharedStore;

// Deletes all existing configs.
+ (void)resetStore;

// 获取N个key配置
- (void)requestConfig:(NSArray*)appKeyArr sdkType:(AdViewSDKType)sdkType;

// Returns config for appKey. If config does not exist for appKey, goes and
// fetches the config from the server, the URL of which is taken from
// [delegate adViewConfigURL].
// Returns nil if appKey is nil or empty, another fetch is in progress, or
// error setting up reachability check.
- (AdViewConfig *)getConfig:(NSString *)appKey
                    sdkType:(AdViewSDKType)sdkType;

// 请求网络广告
- (AdViewConfig *)getNetworkConfig:(NSString *)appKey
                           sdkType:(AdViewSDKType)sdkType;

// For testing -- set mocks here.
@property (strong) NSMutableDictionary *fetchObjs;

- (AdViewConfig*)getBufferConfig:(NSString*)appKey
                         sdkType:(AdViewSDKType)sdkType;

+ (BOOL)isLimitConfigTimeForKey:(NSString*)appKey SDKType:(AdViewSDKType)sdkType;

- (void)setNeedReParse:(AdViewSDKType)sdkType;

@end

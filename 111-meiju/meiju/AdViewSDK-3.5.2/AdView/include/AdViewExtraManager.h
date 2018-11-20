//
//  AdViewExtraManager.h
//  AdViewSDK
//
//  Created by zhiwen on 12-7-25.
//  Copyright 2012 www.adview.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocationManagerDelegate.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocationManager.h>

#define LAST_NET_CONFIG_TIME	@"lastGetNetConfigTime"

@interface AdViewTimerItem : NSObject {
    NSObject    __weak  *target;
    
    SEL                 selFunc;
    NSTimeInterval      time;
    NSObject     __weak       *param1;
    NSObject     __weak       *param2;
    NSTimer      __weak       *timer;
}

@property (nonatomic, weak) NSObject *target;
@property (nonatomic, assign) SEL selFunc;
@property (nonatomic, assign) NSTimeInterval time;
@property (nonatomic, weak) NSObject *param1;
@property (nonatomic, weak) NSObject *param2;
@property (nonatomic, weak) NSTimer *timer;

- (id)initWithTimeInterval:(NSTimeInterval)aInterval target:(NSObject*)aTarget selector:(SEL)aSel;

@end


@interface AdViewExtraManager : NSObject <CLLocationManagerDelegate> {
	CLLocationManager *locationManager;
	CLLocation		  *myLocation;
	NSTimeInterval	   myLocationTime;
	
	NSMutableDictionary		*objDict;
    
    NSMutableArray          *timerArr;
}

@property (nonatomic, retain) NSString *macAddr;

+ (AdViewExtraManager*)createManager;	//create and return.
+ (AdViewExtraManager*)sharedManager;	//won't create.

- (void)findLocation;
- (CLLocation*)getLocation;

- (NSString*)getMacAddress;

- (void)storeObject:(NSObject*)obj forKey:(NSString*)keyStr;
- (NSObject*)objectStoredForKey:(NSString*)keyStr;

- (BOOL)addTimer:(AdViewTimerItem*)item;
- (BOOL)cancelTimer:(AdViewTimerItem*)item;     //By target and selFunc
- (BOOL)cancelTimerWithTarget:(NSObject*)target selector:(SEL)sel;

+ (NSString *)encodeToPercentEscapeString:(NSString *)input;
+ (NSString *)decodeFromPercentEscapeString:(NSString*)input;

//like "\xab\xcd\xef" -> utf8 char.
+ (NSData*)dataTrim16Char:(NSData*)data;
//====
+ (NSString *)md5Digest:(NSString *)str;
+ (NSString *)getMd5HexString:(NSString *)plainText;
//base64
+ (NSData *)dataFromBase64String:(NSString *)aString;
//default no optForURL.
+ (NSString *)base64EncodedString:(NSData*)data;
+ (NSString *)base64EncodedString:(NSData*)data OptForURL:(BOOL)bOptForURL;

//xor map decode.
//aMap: array of 16 length, like, 1, 5, 13, 0, ...
+ (NSString*)xorMapDecode:(NSString*)aString Map:(unsigned char*)aMap;

+ (NSString*)optXorMapEncode:(NSString*)aString Map:(unsigned char*)aMap;
+ (NSString*)optXorMapDecode:(NSString*)aString Map:(unsigned char*)aMap;

@end

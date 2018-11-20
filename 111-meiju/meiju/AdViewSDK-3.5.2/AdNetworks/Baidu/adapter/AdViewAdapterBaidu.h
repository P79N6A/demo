/*
 
 Copyright 2010 www.adview.cn. All rights reserved.
 
 */

#import "AdViewAdNetworkAdapter+helpers.h"
#import <BaiduMobAdSDK/BaiduMobAdView.h>

//@interface Baidu : BaiduMobAdView
//
//@end
//static Baidu *baiduShare = nil;
//
//@implementation Baidu
//
//+(Baidu*)shareInit
//{
//    if (baiduShare == nil) {
//        baiduShare = nil;
//        baiduShare = (Baidu*)[[BaiduMobAdView alloc] init];
//    }
//    return baiduShare;
//}
//@end



@interface AdViewAdapterBaidu : AdViewAdNetworkAdapter <BaiduMobAdViewDelegate> {
}

+ (AdViewAdNetworkType)networkType;
@property (nonatomic, retain) BaiduMobAdView * sharedAdView;

@end

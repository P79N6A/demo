/*
 
 Copyright 2010 www.adview.cn. All rights reserved.
 
 */

#import "AdViewAdNetworkAdapter.h"
#import "SmtaranSDKManager.h"
#import "SmtaranBannerAd.h"

/**/

@interface AdViewAdapterSmtaran : AdViewAdNetworkAdapter<SmtaranBannerAdDelegate> {
@private
    NSThread *adThread_;
}

+ (AdViewAdNetworkType)networkType;
@property (nonatomic, retain) SmtaranBannerAd* SmtaranAdView;

@end

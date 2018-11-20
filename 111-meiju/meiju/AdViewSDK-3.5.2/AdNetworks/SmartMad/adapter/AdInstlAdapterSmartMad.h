/*

adview.
 
*/

#import "AdInstlAdNetworkAdapter.h"
#import "SMAdInterstitial.h"

@interface AdInstlAdapterSmartMad : AdInstlAdNetworkAdapter<SMAdInterstitialDelegate> {

}

+ (AdInstlAdNetworkType)networkType;

@property (nonatomic, weak) UIViewController *rootController;

@end

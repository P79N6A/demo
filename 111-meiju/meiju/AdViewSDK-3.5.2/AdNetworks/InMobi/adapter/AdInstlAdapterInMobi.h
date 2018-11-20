/*

adview.
 
*/

#import "AdInstlAdNetworkAdapter.h"
#import <InMobiSDK/InMobiSDK.h>

@interface AdInstlAdapterInMobi : AdInstlAdNetworkAdapter<IMInterstitialDelegate> {
   
}

+ (AdInstlAdNetworkType)networkType;

@end

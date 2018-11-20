/*

adview.
 
*/

#import "AdInstlAdNetworkAdapter.h"
#import "DMInterstitialAdController.h"

@interface AdInstlAdapterDomob : AdInstlAdNetworkAdapter<DMInterstitialAdControllerDelegate> {

}

+ (AdInstlAdNetworkType)networkType;

@property (nonatomic, weak) UIViewController *rootController;

@end

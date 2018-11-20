/*

Adview .
 
*/

#import "AdViewAdNetworkAdapter.h"
#import "AduuDelegate.h"
#import "AduuView.h"


/*Adview openapi ad -- Aduu.*/

@interface AdViewAdapterAduu : AdViewAdNetworkAdapter <AduuDelegate> {

}

@property (retain, nonatomic) AduuView *aduuView;

+ (AdViewAdNetworkType)networkType;

@end

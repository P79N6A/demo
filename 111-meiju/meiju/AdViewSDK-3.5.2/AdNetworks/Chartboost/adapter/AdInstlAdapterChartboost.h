/*

adview.
 
*/

#import "AdInstlAdNetworkAdapter.h"
#import <Chartboost/Chartboost.h>

@interface AdInstlAdapterChartboost : AdInstlAdNetworkAdapter <ChartboostDelegate> {
    
    BOOL        bLoadedCache;
    BOOL        didShow;
}

@property (nonatomic,strong) Chartboost *chartboost;

+ (AdInstlAdNetworkType)networkType;

@end

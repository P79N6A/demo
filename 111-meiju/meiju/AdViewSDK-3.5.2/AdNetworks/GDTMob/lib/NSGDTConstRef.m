//
//  NSGDTConstRef.m
//  KuaiYouAdHello
//
//  Created by maming on 2018/6/19.
//

#import "NSGDTConstRef.h"
#import "GDTNativeAd.h"

@implementation NSGDTConstRef

+(NSString*)refConst:(GDTConstRefName)refName {
    NSString *string;
    switch (refName) {
        case GDTConstRefTitle:
            string = GDTNativeAdDataKeyTitle;
            break;
        case GDTConstRefDesc:
            string = GDTNativeAdDataKeyDesc;
            break;
        case GDTConstRefImgUrl:
            string = GDTNativeAdDataKeyImgUrl;
            break;
        case GDTConstRefIconUrl:
            string = GDTNativeAdDataKeyIconUrl;
            break;
        case GDTConstRefAppPrice:
            string = GDTNativeAdDataKeyAppPrice;
            break;
        case GDTConstRefAppRating:
            string = GDTNativeAdDataKeyAppRating;
            break;
        default:
            string = nil;
            break;
    }
    return string;
}

@end

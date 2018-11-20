//
//  STMConstants.h
//  SuntengMobileAdsSDK
//
//  Created by Joe.
//  Copyright © 2016年 Sunteng Information Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const STMErrorDomain;

typedef NS_ENUM(NSInteger, STMErrorCode) {
    STMErrorCodeNone = 0,               // bidding success
    STMErrorCodeNetworkError,           // network error
    STMErrorCodeResponseError,          // response is not a HTTP URL response
    STMErrorCodeSystemError,            // server system error
    STMErrorCodeNoAd,                   // no ad
    STMErrorCodeNoData,                 // no response data
    STMErrorCodeDeserializationError,   // deserialize JSON error
    STMErrorCodeLoadHTMLFail,           // load HTML fail
    STMErrorCodeErrorRequest,           // error request - HTTP code 204
    STMErrorCodeRefund,                 // no ad - refund
    STMErrorCodeBlank,                  // no ad - keep blank
    STMErrorCodeTimeout,                // timeout
    STMErrorCodeLoadResourceFail,       // load resource fail
    STMErrorCodeOther = -1              // other error
};

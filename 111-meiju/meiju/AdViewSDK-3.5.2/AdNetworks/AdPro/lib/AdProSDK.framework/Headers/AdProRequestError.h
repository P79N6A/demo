//
//  AdProRequestError.h
//  AdSDK
//
//  Created by luo on 15/12/14.
//  Copyright © 2015年 Goyoo. All rights reserved.
//

/// NSError codes for AdPro error domain.
typedef NS_ENUM(NSInteger, AdProErrorCode) {
    /// Unknown error.
    AdProErrorUnknownError = 0,
    
    /// The ad request is invalid. The localizedFailureReason error description will have more
    /// details. Typically this is because the ad did not have the appID、appKey、slotID or root view
    /// controller set.
    AdProErrorConfigInvalid,
    
    /// There was an error loading data from the network.
    AdProErrorNetworkError,
    
    /// Internal error.
    AdProErrorInternalError,
    
    /// The ad server experienced a failure processing the request.
    AdProErrorServerError,
    
    /// Invalid argument error.
    AdProErrorInvalidArgument,
    
    /// The ad request was successful, but no ad was returned.
    AdProErrorNoFill,
    
    /// Will not send request because the interstitial object has already been used.
    AdProErrorInterstitialAlreadyUsed,
    
    /// The interstitial object is not ready to be displayed.
    AdProErrorInterstitialNotReady,

};


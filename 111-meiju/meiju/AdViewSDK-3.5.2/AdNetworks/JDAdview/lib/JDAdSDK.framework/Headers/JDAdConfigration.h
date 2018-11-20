//
//  JDAdViewConfigration.h
//  JDAdSDKDemo
//
//  Created by Ben Miao on 15/11/7.
//  Copyright © 2015年 com.jd.dm. All rights reserved.
//

#ifndef JDAdViewConfigration_h
#define JDAdViewConfigration_h


typedef NS_ENUM(NSUInteger, JDAdType) {
    JDAdTypeBanner = 1,
    JDAdTypeModal,
    JDAdTypeNative,
    JDAdTypeOthers
};

typedef NS_ENUM(NSUInteger,JDAdSize){
    
    JDAdSize_Banner_320_48 = 1001,
    JDAdSize_Banner_320_50,
    JDAdSize_Banner_480_75,
    JDAdSize_Banner_640_100,
    JDAdSize_Banner_936_120,
    
    JDAdSize_Modal_320_480 = 2001,
    JDAdSize_Modal_600_500,
    JDAdSize_Modal_640_960,

};

typedef NS_ENUM(NSUInteger, BannerPosition) {
    BannerLocateBottom,
    BannerLocateTop,
    BannerLocateCustom
};

typedef NS_ENUM(NSUInteger, JDAdURLResponseStatus)
{
    JDAdURLResponseStatusSuccess,
    JDAdURLResponseStatusErrorTimeout,
    JDAdURLResponseStatusErrorNoNetwork // 默认除了超时以外的错误都是无网络错误。
};

typedef NS_ENUM(NSUInteger, JDAdNativeType) {
    NativeTypeObject,
    NativeTypeDictionary,
};

typedef NS_ENUM(NSUInteger, JDAdDefineGender) {
    JDAdGenderMale = 1,
    JDAdGenderFemale
};

/**
 *  JDAdError
 */
typedef NS_ENUM(NSUInteger, JDAdError) {
    /**
     *  check your tagid,always your tagid doesn't match your bundle.
     */
    JDADTagIDError,
    /**
     *  the viewcontroller you send has been presenting another viewcontorller.
     *  pelease ensure the viewcontroller.pressentingViewcontroller you offeris nil.
     */
    JDADPrensenttingError,
    /**
     *  server return error data or changed the json structure.
     */
    JDADReturnDataError,
    /**
     *  others.
     */
    JDADOtherError
};

#endif /* JDAdViewConfigration_h */

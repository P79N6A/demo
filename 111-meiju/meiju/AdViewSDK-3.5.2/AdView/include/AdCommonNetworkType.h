//
//  AdCommonNetworkType.h
//  AdViewDevelop
//
//  Created by maming on 14-11-10.
//  Copyright (c) 2014年 maming. All rights reserved.
//

#ifndef AdViewDevelop_AdCommonNetworkType_h
#define AdViewDevelop_AdCommonNetworkType_h

typedef enum {
    AdViewAdNetworkTypeNone	= 0,
    AdViewAdNetworkTypeAdMob       = 1,
    AdViewAdNetworkTypeJumpTap     = 200,
    AdViewAdNetworkTypeVideoEgg    = 300,
    AdViewAdNetworkTypeMedialets   = 4,
    AdViewAdNetworkTypeLiveRail    = 5,
    AdViewAdNetworkTypeMillennial  = 6,
    AdViewAdNetworkTypeGreyStripe  = 2,
    AdViewAdNetworkTypeQuattro     = 8,
    AdViewAdNetworkTypeCustom      = 9,
    AdViewAdNetworkTypeAdView10   = 10,
    AdViewAdNetworkTypeMobClix     = 11,
    AdViewAdNetworkTypeMdotM       = 12,
    AdViewAdNetworkTypeAdView13   = 13,
    AdViewAdNetworkTypeGoogleAdSense = 14,
    AdViewAdNetworkTypeGoogleDoubleClick = 15,
    AdViewAdNetworkTypeGeneric     = 16,
    AdViewAdNetworkTypeEvent	      = 17,
//    AdViewAdNetworkTypeInMobi      = 18,
    AdViewAdNetworkTypeIAd         = 27,//19
    AdViewAdNetworkTypeZestADZ	  = 20,
    AdViewAdNetworkTypeWOOBOO		  = 21,
    AdViewAdNetworkTypeYOUMI		  = 22,
    AdViewAdNetworkTypeKUAIYOU	  = 23,
    AdViewAdNetworkTypeCASEE		  = 24,
    AdViewAdNetworkTypeWIYUN		  = 25,
    AdViewAdNetworkTypeADCHINA	  = 26,
    
    AdViewAdNetworkTypeAdviewApp	  = 28,
    
    AdViewAdNetworkTypeSMARTMAD	  = 29,
    AdViewAdNetworkTypeDOMOB		  = 30,
    
    AdViewAdNetworkTypeVPON		  = 31,
    AdViewAdNetworkTypeADWO		  = 33,
    AdViewAdNetworkTypeAirAD	  = 34,
    AdViewAdNetworkTypeWQ		  = 35,
    AdViewAdNetworkTypeGreystripe = 2,
    AdViewAdNetworkTypeInMobi = 3,
    AdViewAdNetworkTypeBAIDU      = 38,
    AdViewAdNetworkTypeWinAd = 40,
    AdViewAdNetworkTypeIZPTec = 41,
    AdViewAdNetworkTypeAdSage = 42,
    AdViewAdNetworkTypeUMAd = 43,
    AdViewAdNetworkTypeAdFracta = 44,
    AdViewAdNetworkTypeImmob = 45,
    AdViewAdNetworkTypeMobWin = 46,
    AdViewAdNetworkTypeSuiZong = 47,
    AdViewAdNetworkTypeAduu = 48,
    
    
    AdViewAdNetworkTypeAder	= 50,
    
    AdViewAdNetworkTypeDoubleClick = 51,
    AdViewAdNetworkTypeYunyun = 53,
    AdViewAdNetworkTypeGuomob      = 55,
    AdViewAdNetworkTypePingcoo = 56,
    AdViewAdNetworkTypeChance = 57,
    AdViewAdNetworkTypeGDTMob  = 59,
    AdViewAdNetworkTypeTanx = 60,
    AdViewAdNetworkTypeMiidi = 61,
    AdViewAdNetworkTypeYJF = 64,
    AdViewAdNetworkTypeDianRu = 65,
    AdViewAdNetworkTypeAdPro = 73,
    AdViewAdNetworkTypeAdSmar = 74,
    AdViewAdNetworkTypeJDAdview = 76,
    AdViewAdNetworkTypeMopan = 78,
    AdViewAdNetworkTypeMobFox =80,
    
    AdViewAdNetworkTypeSTMob =81,
    AdViewAdNetworkTypeOpera =82,
    
    AdViewAdNetworkTypeYouLan =85,
    
    AdViewAdNetworkTypeAdDirect = 995,           // 直投
    AdViewAdNetworkTypeAdExchange = 996,         // 交换
    AdViewAdNetworkTypeADFill = 997,
    AdViewAdNetworkTypeAdViewBID = 998,
    AdViewAdNetworkTypeUserDefined = 999,
    
} AdViewAdNetworkType;

typedef enum {
    AdInstlAdNetworkTypeNone = 0,
    //china
    AdInstlAdNetworkTypeDomob    = 2,
    AdInstlAdNetworkTypeAdwo     = 3,
    AdInstlAdNetworkTypeYoumi    = 4,
    AdInstlAdNetworkTypeAdChina  = 5,
    AdInstlAdNetworkTypeSmtaran = 6,
    AdInstlAdNetworkTypeYiJiFen  = 7,
    AdInstlAdNetworkTypeWaps     = 8,
    AdInstlAdNetworkTypeSmartMad = 9,
    AdInstlAdNetworkTypeAdMob    = 10,
    AdInstlAdNetWorkTypeGuomob   = 11,
    AdInstlAdNetworkTypeAder     = 13,
    AdInstlAdNetWorkTypeLmmob    = 14,
    AdInstlAdNetworkTypeGuoHe    = 15,
    AdInstlAdNetworkTypeChance = 16,
    AdInstlAdNetWorkTypePingcoo  = 18,
    AdInstlAdNetworkTypeCoolAd   = 19,
    AdInstlAdNetworkTypeVtime    = 20,
    AdInstlAdNetworkTypeBaidu    = 23,
    AdInstlAdNetworkTypeGDTMob   = 24,
    AdInstlAdNetworkTypeDianRu   = 25,
    AdInstlAdNetworkTypeXingYun  = 26,
    AdInstlAdNetworkTypeMiidi = 27,
    AdInstlAdNetworkTypeMopan   = 55,//mopan
    AdInstlAdNetworkTypeAdSmar   = 74,
    AdInstlAdNetworkTypeMobFox   = 80,
    AdInstlAdNetworkTypeSTMob   = 85,
    AdInstlAdNetworkTypeOpera   = 86,
    //foreign
    AdInstlAdNetworkTypeChartboost = 81,
    AdInstlAdNetworkTypeInMobi = 82,
    AdInstlAdNetworkTypeJDAdview = 83,
    AdInstlAdNetworkTypeMillennialMedia = 88,
    
    AdInstlAdNetworkTypeAppnext = 92,
    
    AdInstlAdNetworkTypeYouLan = 94,
    
    AdInstlAdNetworkTypeAdDirect = 995,           // 直投
    AdInstlAdNetworkTypeAdExchange = 996,         // 交换
    //adfill
    AdInstlAdNetworkTypeADFill = 997,
    AdInstlAdNetworkTypeADBID = 998,
    //
    AdInstlAdNetworkTypeUserDefined = 999,
    
} AdInstlAdNetworkType;

typedef enum {
    AdSpreadScreenAdNetworkTypeNone = 0,
    //china
    AdSpreadScreenAdNetworkTypeDomob    = 2,
    AdSpreadScreenAdNetworkTypeAdwo     = 3,
    AdSpreadScreenAdNetworkTypeYoumi    = 4,
    AdSpreadScreenAdNetworkTypeAdChina  = 5,
    AdSpreadScreenAdNetworkTypeGDTMob = 6,
    AdSpreadScreenAdNetworkTypeYiJiFen  = 7,
    AdSpreadScreenAdNetworkTypeWaps     = 8,
    AdSpreadScreenAdNetworkTypeSmartMad = 9,
    AdSpreadScreenAdNetworkTypeAdMob    = 10,
    AdSpreadScreenAdNetWorkTypeGuomob   = 11,
    AdSpreadScreenAdNetworkTypeAder     = 13,
    AdSpreadScreenAdNetWorkTypeLmmob    = 14,
    AdSpreadScreenAdNetworkTypeGuoHe    = 15,
    AdSpreadScreenAdNetworkTypeChance = 16,
    AdSpreadScreenAdNetWorkTypePingcoo  = 18,
//    AdSpreadScreenAdNetworkTypeCoolAd   = 19,
    AdSpreadScreenAdNetworkTypeOpera    = 19,
    AdSpreadScreenAdNetworkTypeVtime    = 20,
    AdSpreadScreenAdNetworkTypeYouLan   = 21,
    AdSpreadScreenAdNetworkTypeBaidu    = 23,
    AdSpreadScreenAdNetworkTypeDianRu   = 25,
   
    //adview adfill
    AdSpreadScreenAdNetworkTypeAdFill   = 55,
    AdSpreadScreenAdNetworkTypeAdSmar   = 74,
    AdSpreadScreenAdNetworkTypeSTMob   = 82,
    //foreign
    AdSpreadScreenAdNetworkTypeChartboost = 81,
    AdSpreadScreenAdNetworkTypeInMobi = 82,
    
    
    AdSpreadScreenAdNetworkTypeAdDirect = 995,           // 直投
    AdSpreadScreenAdNetworkTypeAdExchange = 996,         // 交换
    //adfill
    AdSpreadScreenAdNetworkTypeADFill = 997,
    AdSpreadScreenAdNetworkTypeADBID = 998,
    //
    AdSpreadScreenAdNetworkTypeUserDefined = 999,
    
} AdSpreadScreenAdNetworkType;

typedef enum {
    AdNativeAdNetworkTypeNone = 0,
    
    AdNativeAdNetworkTypeJDAdview = 7,
    AdNativeAdNetworkTypeGDTMob = 24,
    AdNativeAdNetworkTypeSmtaran = 26,
    //foreign
    AdNativeAdNetworkTypeInMobi = 27,
    AdNativeAdNetworkTypeAdSmar = 74,
    
    AdNativeAdNetworkTypeAdDirect = 995,           // 直投
    AdNativeAdNetworkTypeAdExchange = 996,         // 交换
    //adfill
    AdNativeAdNetworkTypeADFill = 997,
    AdNativeAdNetworkTypeADBID = 998,
    //
    AdNativeAdNetworkTypeUserDefined = 999,
    
} AdNativeAdNetworkType;

typedef enum {
    AdVideoAdNetworkTypeNone = 0,
    AdVideoAdNetworkTypeDomob = 2,
    AdVideoAdNetworkTypeChance = 16,
    AdVideoAdNetworkTypeUnity = 17,
    AdVideoAdNetworkTypeAdColony = 18,
    AdVideoAdNetworkTypeBaidu = 74,
    AdVideoAdNetworkTypeInmobi = 82,
    AdVideoAdNetworkTypeSTMob = 90,
    AdVideoAdNetworkTypeYouLan = 95,

    //foreign
    
    AdVideoAdNetworkTypeAppnext = 91,
    
    AdVideoAdNetworkTypeAdDirect = 995,           // 直投
    AdVideoAdNetworkTypeAdExchange = 996,         // 交换
    //adfill
    AdVideoAdNetworkTypeADFill = 997,
    AdVideoAdNetworkTypeADBID = 998,
    //
    AdVideoNetworkTypeUserDefined = 999,
    
} AdVideoAdNetworkType;
#endif

//
//  LocationManager.h
//  MobFoxSDKCore
//
//  Created by Shimi Sheetrit on 5/2/16.
//  Copyright © 2016 Itamar Nabriski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

@interface MFLocationServicesManager : NSObject <CLLocationManagerDelegate, UIAlertViewDelegate>

@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nonatomic) double accuracy;

@property (nonatomic, strong) CLLocationManager *locationManager;

+ (instancetype)sharedInstance;
- (void)findLocation;
- (void)stopFindingLocation;


@end

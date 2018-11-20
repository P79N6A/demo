//
//  Created by cq on 14-2-15.
//  Copyright (c) 2014年 cq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@protocol AppListDelegate <NSObject>
@optional
-(void)getAppListSucess:(int)_score unit:(NSString *) unit;
-(void)getAppListFailed:(int)_code error:(NSString *) error;
-(void)consumptionAppListSucess:(int)_score balance:(int)balance unit:(NSString *) unit;
-(void)consumptionAppListFailed:(int)_code error:(NSString *)error;

@end

@interface AppList : UIViewController<UIWebViewDelegate,UIAlertViewDelegate,CLLocationManagerDelegate>

{
    UIWebView *_appListWebView;
    CLLocationManager *_locationManager;
}

@property (assign) id<AppListDelegate> delegate;
@property (nonatomic,strong) UIActivityIndicatorView  *progressInd;

@end

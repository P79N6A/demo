//
//  ViewController.m
//  36admob
//
//  Created by FEIWU888 on 2017/10/25.
//  Copyright © 2017年 FEIWU888. All rights reserved.
//

#import "ViewController.h"

#import <GoogleMobileAds/GoogleMobileAds.h>

@interface ViewController ()<GADBannerViewDelegate>
@property (weak, nonatomic) IBOutlet GADBannerView *bannerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.bannerView.adUnitID = @"ca-app-pub-7838430345875942/1566975260";
    self.bannerView.rootViewController = self;
    self.bannerView.delegate = self;
    self.bannerView.adSize = kGADAdSizeBanner;

    GADRequest *request = [GADRequest request];

    
    request.testDevices = @[kGADSimulatorID];
    [self.bannerView loadRequest:request];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/// the banner view to the view hierarchy if it hasn't been added yet.
- (void)adViewDidReceiveAd:(GADBannerView *)bannerView{
    NSLog(@"%s", __func__);
}

/// Tells the delegate that an ad request failed. The failure is normally due to network
/// connectivity or ad availablility (i.e., no fill).
- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error{
    NSLog(@"%s", __func__);
}
@end

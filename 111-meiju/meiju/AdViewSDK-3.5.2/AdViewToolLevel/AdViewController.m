//
//  AdViewController.m
//  AdViewAdVSDK
//
//  Created by the user on 12-7-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AdViewController.h"
#import "AdViewUtils.h"
#import "AdViewCommonDef.h"

static AdViewController *gAdVAdController;
static AdViewController *gAdVMultiControllers[] = {nil, nil, nil, nil, nil, nil, nil, nil, nil, nil};

static NSObject *gLockObj;

static BOOL gAdVLog = NO;
static const int MAX_INSTANCE = 10;

#define ADVIEW_LOG_PREFIX		@"AdView:"

void setAdViewAdVLog(BOOL bLog)
{
    gAdVLog = bLog;
}

void _AdViewAdVLogInfo(NSString *format, ...) {
	if (!gAdVLog) return;
    
	va_list ap;
	NSString *fmt_real = [ADVIEW_LOG_PREFIX stringByAppendingString:format];
	va_start(ap, format);
	NSLogv(fmt_real, ap);
	va_end(ap);
}

@interface AdViewController(PRIVATE)

- (void)removeNotification;

@end


@implementation AdViewController
@synthesize adView = adView_;
@synthesize adBannerSize = adBannerSize_;
@synthesize adRootController = adRootController_;
@synthesize notifyDelegate = notifyDelegate_;

@synthesize bSuperOrientFix;

+ (void)load {
     gLockObj = [[NSObject alloc] init];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
#if IS_VIEWCONTROLLER
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
#else
    self = [super init];
#endif
    if (self) {
        // Custom initialization
        AdVLogInfo(@"AdViewController initWithNibName");
        
        ad_x = -1;//-1;
        ad_y = 0;
        ad_hidden = NO;
        nOrientationSupport = 1<<UIInterfaceOrientationPortrait;
        self.adBannerSize = AdviewBannerSize_Auto;
        nOrientation = UIDeviceOrientationPortrait;
    }
    return self;
}

#pragma mark 单例调用

+ (AdViewController*) sharedController
{
    if (nil == gAdVAdController) {
        @synchronized(gLockObj) {
            if (nil == gAdVAdController)
            {
                gAdVAdController = [[AdViewController alloc] initWithNibName:nil bundle:[NSBundle mainBundle]];
            }
        }
    }
    return gAdVAdController;
}

+ (AdViewController*) sharedControllerIfExists {
    return gAdVAdController;
}

+ (void) deleteController
{
    if (nil == gAdVAdController) return;
    
    @synchronized(gLockObj) {
        [gAdVAdController removeNotification];
#if IS_VIEWCONTROLLER
        [gAdVAdController.view removeFromSuperview];
#endif
        [gAdVAdController.adView removeFromSuperview];
        
         gAdVAdController = nil;
    }
}

#pragma mark 多个实例调用

+ (AdViewController*) sharedControllerById:(int)nId             //多个实例之一，存在直接返回，否则新建返回
{
    if (nId < 0 || nId >= MAX_INSTANCE) return nil;
    
    if (nil == gAdVMultiControllers[nId])
    {
        @synchronized(gLockObj) {
            if (nil == gAdVMultiControllers[nId]) {
                gAdVMultiControllers[nId] = [[AdViewController alloc] initWithNibName:nil bundle:[NSBundle mainBundle]];
            }
        }
    }
    return gAdVMultiControllers[nId];
}

+ (AdViewController*) sharedControllerIfExistsById:(int)nId     //多个实例之一，检查是否存在，存在则返回，否则返回nil
{
    if (nId < 0 || nId >= MAX_INSTANCE) return nil;
    
    return gAdVMultiControllers[nId];
}

+ (void) deleteControllerById:(int)nId
{
    if (nId < 0 || nId >= MAX_INSTANCE) return;
    
    if (nil == gAdVMultiControllers[nId]) return;
    
    @synchronized(gLockObj) {
        AdViewController *controller = gAdVMultiControllers[nId];
        
        [controller removeNotification];
#if IS_VIEWCONTROLLER
        [controller.view removeFromSuperview];
#endif
        [controller.adView removeFromSuperview];        
         gAdVMultiControllers[nId] = nil;
    }
}

#if IS_VIEWCONTROLLER 

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    [super loadView];
    
    self.view.userInteractionEnabled = YES;
    self.view.frame = CGRectMake(0, 0, 0, 0);
    self.view.backgroundColor = [UIColor clearColor];
    
    [self addAdView];    
}


/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad
 {
 [super viewDidLoad];
 }
 */

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    
    AdVLogInfo(@"shouldAutorotateToInterfaceOrientation %d", nOrientationSupport);
    
    BOOL bRet = (   0 != (nOrientationSupport & (1<<interfaceOrientation))  );
#if 1
    if (bRet)
        nOrientation = interfaceOrientation;
#endif
    return bRet;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    
    [self adjustAdSize];
}

#else

- (void)loadView
{    
    [self addAdView];    
}

#endif

- (void)dealloc {
    AdVLogInfo(@"Enter AdViewController dealloc");    
	self.adView.delegate = nil;  
    self.adView = nil;
    
    adviewKey = nil;
    AdVLogInfo(@"Exit AdViewController dealloc");
}

#pragma ad

- (void)addAdView {
    if (nil != self.adView) {
        AdVLogInfo(@"Already addAdView.");
        return;
    }
    
	self.adView = [AdViewView requestAdViewViewWithAppKey:adviewKey WithDelegate:self];
	self.adView.autoresizingMask =
    UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
#if IS_VIEWCONTROLLER
	[self.view addSubview:self.adView];
#endif

	UIDevice *device = [UIDevice currentDevice];
	if ([device respondsToSelector:@selector(isMultitaskingSupported)] &&
		[device isMultitaskingSupported]) {
#ifdef __IPHONE_4_0
		[[NSNotificationCenter defaultCenter]
		 addObserver:self
		 selector:@selector(enterForeground:)
		 name:UIApplicationWillEnterForegroundNotification
		 object:nil]; 
		[[NSNotificationCenter defaultCenter]
		 addObserver:self
		 selector:@selector(didChangedStatusBarOrientation:)
		 name:UIApplicationDidChangeStatusBarOrientationNotification
		 object:nil];
#endif
	}
    self.adView.frame = CGRectMake(0, 0, 0, 0);
}

- (void)removeNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)enterForeground:(NSNotification*)n {
    [self.adView updateAdViewConfig];
}

- (void)didChangedStatusBarOrientation:(NSNotification*)n {
    [self adjustAdSize];
}

static CGRect makeCGRectByPoints(CGPoint pt1, CGPoint pt2)
{
    return CGRectMake(MIN(pt1.x, pt2.x), MIN(pt1.y, pt2.y),
                      ABS(pt1.x - pt2.x), ABS(pt1.y - pt2.y));
}

#define PI 3.1415926535898f

- (void)adjustAdSize {
	CGSize adSize = [self.adView actualAdSize];
    
    if (adSize.width <= 0 || adSize.height <= 0) {
        if ([self respondsToSelector:@selector(adViewBannerAnimationType)]
            && AdViewBannerAnimationTypeNone != [self adViewBannerAnimationType])
            return;
    }    
    
    //AdVLogInfo(@"AdSize:%@", NSStringFromCGSize(adSize));
    //AdVLogInfo(@"AdFrame:%@", NSStringFromCGRect(self.adView.frame));
    
	[UIView beginAnimations:@"AdResize" context:nil];
	[UIView setAnimationDuration:0.7];    
    CGRect barRect = [UIApplication sharedApplication].statusBarFrame;
    
    CGFloat barHeight = barRect.size.width;
    if (barHeight >= 100) barHeight = barRect.size.height;
    
	CGRect newFrame = self.adView.frame;
    UIWindow *win = [[UIApplication sharedApplication] keyWindow];
    CGRect winFrame = win.frame;
    
    BOOL        bScreenFrm = YES;
    if (nil != self.adView.superview)
    {
        winFrame = self.adView.superview.frame;
        winFrame.origin.y = 0;
        
        bScreenFrm = NO;
    }
    
    UIDeviceOrientation orientation = (UIDeviceOrientation)[UIApplication sharedApplication].statusBarOrientation;
    
    BOOL bIsLand = UIDeviceOrientationIsLandscape(orientation);
    
    AdVLogInfo(@"winFrame:%@", NSStringFromCGRect(winFrame));
    
    CGFloat winWidth = winFrame.size.width;
    CGFloat winHeight = winFrame.size.height;
    
    if (bIsLand) {
        winWidth = winFrame.size.height>winFrame.size.width?winFrame.size.height:winFrame.size.width;
        winHeight = winFrame.size.height<winFrame.size.width?winFrame.size.height:winFrame.size.width;
    }
    
    bScreenFrm |= self.bSuperOrientFix;
    if (bScreenFrm && bIsLand) winWidth = winFrame.size.height>winFrame.size.width?winFrame.size.height:winFrame.size.width;
    if (bScreenFrm && bIsLand) winHeight = winFrame.size.height<winFrame.size.width?winFrame.size.height:winFrame.size.width;
    
    CGFloat calHeight = winHeight;
    
    if (bScreenFrm && ![UIApplication sharedApplication].isStatusBarHidden)
        calHeight -= barHeight;
    
	newFrame.size.height = adSize.height;
	newFrame.size.width = adSize.width;
    if (AD_POS_CENTER == ad_x)
        newFrame.origin.x = (winWidth - adSize.width)/2;
    else if (AD_POS_REWIND == ad_x)
        newFrame.origin.x = (winWidth - adSize.width);
    else newFrame.origin.x = ad_x;
    
    if (AD_POS_CENTER == ad_y)
        newFrame.origin.y = (calHeight - adSize.height)/2;
    else if (AD_POS_REWIND == ad_y)
        newFrame.origin.y = (calHeight - adSize.height);    
	else newFrame.origin.y = ad_y;
    
    if (bScreenFrm && ![UIApplication sharedApplication].isStatusBarHidden)
        newFrame.origin.y += barHeight;
    
    CGRect rectFrom = newFrame;
    
    AdVLogInfo(@"rectFrom:%@", NSStringFromCGRect(rectFrom));
    
    CGRect rectConv = rectFrom;
    
#if IS_VIEWCONTROLLER
    
    if (orientation != nOrientation) {
        
        CGPoint pt1 = rectFrom.origin;
        CGPoint pt2 = CGPointMake(rectFrom.origin.x + rectFrom.size.width,
                                  rectFrom.origin.y + rectFrom.size.height);
        
        CGPoint pt11 = pt1, pt22 = pt2;
        CGFloat radian = 0;
        switch (orientation) {
            case UIDeviceOrientationLandscapeLeft:
                pt11.y = pt1.x;
                pt11.x = winHeight - pt1.y;
                pt22.y = pt2.x;
                pt22.x = winHeight - pt2.y;
                radian = PI/2;
                break;
            case UIDeviceOrientationLandscapeRight:
                pt11.y = winWidth - pt1.x;
                pt11.x = pt1.y;
                pt22.y = winWidth - pt2.x;
                pt22.x = pt2.y;
                radian = -PI/2;
                break;
            case UIDeviceOrientationPortraitUpsideDown:
                pt11 = CGPointMake(winWidth-pt1.x, winHeight-pt1.y);
                pt22 = CGPointMake(winWidth-pt2.x, winHeight-pt2.y);
                radian = PI;
                break;
            default:
                break;
        }
        
        rectConv = makeCGRectByPoints(pt11, pt22);
        
        AdVLogInfo(@"rectConv:%@", NSStringFromCGRect(rectConv));
        CGAffineTransform transform = CGAffineTransformMakeRotation(radian);
        self.view.transform = transform;
    }
    
    self.view.frame = rectConv;
    self.adView.frame = CGRectMake(0, 0, newFrame.size.width, newFrame.size.height);
#else
    self.adView.frame = rectConv;
#endif
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        CGRect rect = self.adView.frame;
        if (self.adRootController.navigationItem && AD_POS_REWIND != ad_y) {
            if (bIsLand)
                rect.origin.y += 33;
            else
                rect.origin.y += 44;
        }
        if (![UIApplication sharedApplication].statusBarHidden) {
            if (AD_POS_REWIND != ad_y)
                rect.origin.y += barHeight;
        }
        self.adView.frame = rect;
    }
    
	[UIView commitAnimations];
}

- (void)setAdPosition:(CGPoint)start           //x = -1, means center in horizontal
//y = -1, means center in vertical
{
    ad_x = start.x;
    ad_y = start.y;
    
    [self adjustAdSize];
}

- (CGPoint)getAdPosition                       //for restore.
{
    return CGPointMake(ad_x, ad_y);
}

- (void)setAdHidden:(BOOL)bHidden
{
    if (ad_hidden == bHidden) return;

    if (bHidden) [adView_ stopAutoRefresh];
    else [adView_ startAutoRefresh];
    
    ad_hidden = bHidden;
    adView_.hidden = ad_hidden;
#if IS_VIEWCONTROLLER
    self.view.hidden = ad_hidden;
#endif
}

- (void)setAdViewKey:(NSString*)key {
    adviewKey = nil;
    
    adviewKey = key;
}

- (void)setModeTest:(BOOL)bTest Log:(BOOL)bLog {
    adTestMode = bTest;
    adLogMode = bLog;
    
    setAdViewAdVLog(bLog);
}

- (void)rollOver {
    [self.adView rollOver];
}

- (void)requestNewAd {
    [self.adView requestFreshAd];
}

- (void)setOrientationUp:(BOOL)bUp Down:(BOOL)bDown Left:(BOOL)bLeft Right:(BOOL)bRight
{
    nOrientationSupport = 0;
    if (bUp) nOrientationSupport |= 1<<UIInterfaceOrientationPortrait;
    if (bDown) nOrientationSupport |= 1<<UIInterfaceOrientationPortraitUpsideDown;
    if (bLeft) nOrientationSupport |= 1<<UIInterfaceOrientationLandscapeLeft;
    if (bRight) nOrientationSupport |= 1<<UIInterfaceOrientationLandscapeRight;
    
    AdVLogInfo(@"setOrientationUp..., result:%d", nOrientationSupport);
}

+ (void)setAllAdProviders:(BOOL)bVal Except:(int)type
{
    NSDictionary *adProviders = [AdViewUtils getAdPlatforms];
    NSArray *keyArr = [adProviders allKeys];
    
    int     setVal = bVal?1:0;
    int     extVal = bVal?0:1;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:10];
    for (int i = 0; i < [keyArr count]; i++)
    {
        NSNumber *keyNum = [keyArr objectAtIndex:i];
        
        if (nil == keyNum) continue;
        
        int iVal = setVal;
        if (type == [keyNum intValue]) iVal = extVal;
        [dict setObject:[NSNumber numberWithInt:iVal] forKey:keyNum];
    }
    [AdViewUtils setAdPlatformStatus:dict];
 }

- (void)notifyApp:(NSString*)code Info:(NSString*)content
{
    if (nil != self.notifyDelegate)
        [self.notifyDelegate didGotNotify:code Info:content];
    doAdViewNotifyApp(code,  content);
}

#pragma mark AdViewDelegate methods

- (UIViewController *)viewControllerForPresentingModalView {
    if (nil != self.adRootController)
        return self.adRootController;
	return nil;
}

- (NSString *)adViewApplicationKey {
    //return @"SDK20112008511035ylhncq1qd1r4oq5";
    return adviewKey;
}

- (AdviewBannerSize)PreferBannerSize {
	return self.adBannerSize;
}

- (NSString *)BaiDuApIDString {
    return @"2f952126";				//@"debug";
}

- (NSString *)BaiDuApSpecString{
	//spec string for baidu
	return @"debug";		//2f952126_e498eab7
}

- (NSString *)adViewApplicationPublishChannel
{
    return KADVIEW_PUBLISH_CHANNEL_APPSTORE;
}

- (BOOL)adGpsMode {
    return NO;
}

- (BOOL)adViewTestMode {
	return adTestMode;
}

- (BOOL)adViewLogMode {
    return adLogMode;
}

- (BOOL)adViewUsingHtml5 {
    return NO;
}

- (AdViewAppAd_BgGradientType)adViewAppAdBackgroundGradientType
{
	return AdViewAppAd_BgGradient_Fix;
}

- (AdViewBannerAnimationType)adViewBannerAnimationType {
    return AdViewBannerAnimationTypeRandom;
}

- (void)adViewDidReceiveConfig:(AdViewView *)adViewView {
	AdVLogInfo(@"Received config. Requesting ad...");
    
    [self notifyApp:@"gotConfig" Info:nil];
}

- (void)adViewStartGetAd:(AdViewView *)adViewView{
	AdVLogInfo(@"%@", [NSString stringWithFormat:
                       @"Start to get ad from %@, size %@",
                       [adViewView mostRecentNetworkName],
                       NSStringFromCGSize([adViewView actualAdSize])]);
	[self adjustAdSize];
    
    CGSize adSize = [self.adView actualAdSize];
    NSString *info = [NSString stringWithFormat:@"%@;%@", [adViewView mostRecentNetworkName],
                      NSStringFromCGSize(adSize)];
    [self notifyApp:@"toGetAd" Info:info];
}

- (void)adViewDidReceiveAd:(AdViewView *)adViewView {
	AdVLogInfo(@"%@", [NSString stringWithFormat:
                       @"Got ad from %@, size %@",
                       [adViewView mostRecentNetworkName],
                       NSStringFromCGSize([adViewView actualAdSize])]);
	[self adjustAdSize];
    
    CGSize adSize = [self.adView actualAdSize];
    NSString *info = [NSString stringWithFormat:@"%@;%@", [adViewView mostRecentNetworkName],
                      NSStringFromCGSize(adSize)];
    [self notifyApp:@"show" Info:info];
}

- (void)adViewDidClickAd:(AdViewView *)adViewView {
    [self notifyApp:@"click" Info:NSStringFromCGSize([adViewView actualAdSize])];
}

- (void)adViewFailRequestAd:(AdViewView *)adViewView error:(NSError *)error {
    [self notifyApp:@"failReq" Info:[error localizedDescription]];
}

- (void)adViewDidFailToReceiveAd:(AdViewView *)adViewView usingBackup:(BOOL)yesOrNo {
	AdVLogInfo(@"%@", NSStringFromCGSize([adViewView actualAdSize]));
    
	AdVLogInfo(@"%@", [NSString stringWithFormat:
                       @"Failed to receive ad from %@, %@. Error: %@",
                       [adViewView mostRecentNetworkName],
                       yesOrNo? @"will use backup" : @"will NOT use backup",
                       adViewView.lastError == nil? @"no error" : [adViewView.lastError localizedDescription]]);
    
    NSString *errInfo = adViewView.lastError == nil? @"no error" : [adViewView.lastError localizedDescription];
    
    [self notifyApp:@"failGot" Info:errInfo];
}

#if 1
- (void)adViewWillPresentFullScreenModal {
	AdVLogInfo(@"SimpleView: will present full screen modal");
    
    [self notifyApp:@"presentModal" Info:nil];
}

- (void)adViewDidDismissFullScreenModal {
	AdVLogInfo(@"SimpleView: did dismiss full screen modal");
    
    [self notifyApp:@"dismissModal" Info:nil];
}
#endif

- (void)adViewReceivedGenericRequest:(AdViewView *)adViewView {
	UILabel *replacement = [[UILabel alloc] initWithFrame:KADVIEW_DETAULT_FRAME];
	replacement.backgroundColor = [UIColor redColor];
	replacement.textColor = [UIColor whiteColor];
	replacement.textAlignment = NSTextAlignmentCenter;
	replacement.text = @"Generic Notification";
	[adViewView replaceBannerViewWith:replacement];
 	[self adjustAdSize];
	AdVLogInfo(@"Generic Notification");
}

- (void)adViewReceivedNotificationAdsAreOff:(AdViewView *)adViewView {
	AdVLogInfo(@"Ads are off");
    
    [self notifyApp:@"adsAreOff" Info:nil];
}

@end

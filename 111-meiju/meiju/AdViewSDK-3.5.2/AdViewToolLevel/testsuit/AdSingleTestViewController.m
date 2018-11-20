//
//  AdSingleTestViewController.m
//  AdViewSDK
//
//  Created by zhiwen on 13-1-10.
//
//

#import "AdSingleTestViewController.h"
#import "AdViewUtils.h"
#import "AdRunStateManager.h"

#define COND_KEY_TIME       @"time"
#define COND_KEY_MODE       @"mode"
#define COND_KEY_SIZE       @"size"

#define SEG_VIEW_TAG        10101

#define OK_BTN_TAG          10000
#define CANCEL_BTN_TAG      10001

#define VALUE_ALL           9999


#define START_BTN_TAG       13

#define COND_LOG_MODE       YES

@interface AdSingleTestViewController (PRIVATE)

@end

@implementation AdSingleTestViewController

@synthesize adProviders = _adProviders;

//get current condition info.
- (NSString*)getConditionName
{
    int     nTime = [[[conDict objectForKey:COND_KEY_TIME] objectAtIndex:
                      [[runDict objectForKey:COND_KEY_TIME] intValue]] intValue];
    
    BOOL    bTest = [[[conDict objectForKey:COND_KEY_MODE] objectAtIndex:
                      [[runDict objectForKey:COND_KEY_MODE] intValue]] boolValue];
    int     nSize = [[[conDict objectForKey:COND_KEY_SIZE] objectAtIndex:
                      [[runDict objectForKey:COND_KEY_SIZE] intValue]] intValue];
    
    NSString *modeStr = bTest?@"test":@"real";
    
    NSString *sizeStr = @"auto";
    switch (nSize) {
        case AdviewBannerSize_320x50: sizeStr=@"320x50"; break;
        case AdviewBannerSize_300x250: sizeStr=@"300x250"; break;
        case AdviewBannerSize_480x60: sizeStr=@"480x60"; break;
        case AdviewBannerSize_728x90: sizeStr=@"728x90"; break;
        default:break;
    }
    
    return [NSString stringWithFormat:@"%ds_%@_%@", nTime, modeStr, sizeStr];
}

//show ad.
- (void)addAdView:(UIViewController*)rootController
{
    BOOL    bTest = [[[conDict objectForKey:COND_KEY_MODE] objectAtIndex:
                     [[runDict objectForKey:COND_KEY_MODE] intValue]] boolValue];
    int     nSize = [[[conDict objectForKey:COND_KEY_SIZE] objectAtIndex:
                     [[runDict objectForKey:COND_KEY_SIZE] intValue]] intValue];
    
    AdViewController *controller = [AdViewController sharedController];
    [controller setAdViewKey:@"SDK20111022530129m85is43b70r4iyc"];//@"SDK20111022530129m85is43b70r4iyc"];
    [controller setModeTest:bTest Log:COND_LOG_MODE];
    [controller setOrientationUp:NO Down:NO Left:NO Right:YES];
    [controller setAdBannerSize:nSize];
    [controller setAdRootController:rootController];
    [controller setNotifyDelegate:self];
    
    UILabel *label = (UILabel*)[self.view viewWithTag:100];
    [controller setAdPosition:CGPointMake(0, label.frame.origin.y + 40)];//+ label.frame.size.height)];
    
    [controller loadView];
    [self.view addSubview:controller.adView];
}

- (void)releaseAdView {    
	[AdViewController deleteController];
}


//init condition values for select.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.adProviders = [AdViewUtils getAdPlatforms];
        self.title = @"Single Test";
        
        adRunStateMgr = [[AdRunStateManager alloc] init];
        
        
        sizeNameArr = [[NSArray alloc] initWithObjects:@"auto", @"320x", @"300x",
                                @"480x", @"728x", @"all", nil];
        sizeValueArr = [[NSArray alloc] initWithObjects:
                        [NSNumber numberWithInt:AdviewBannerSize_Auto],
                        [NSNumber numberWithInt:AdviewBannerSize_320x50],
                        [NSNumber numberWithInt:AdviewBannerSize_300x250],
                        [NSNumber numberWithInt:AdviewBannerSize_480x60],
                        [NSNumber numberWithInt:AdviewBannerSize_728x90],
                        [NSNumber numberWithInt:VALUE_ALL],
                        nil];
        
        modeNameArr = [[NSArray alloc] initWithObjects:@"test", @"real", @"all", nil];
        modeValueArr = [[NSArray alloc] initWithObjects:[NSNumber numberWithBool:YES],
                        [NSNumber numberWithBool:NO],
                        [NSNumber numberWithInt:VALUE_ALL],
                        nil];
        
        timeNameArr = [[NSArray alloc] initWithObjects:@"3s", @"10s", @"40s", @"90s", @"all", nil];
        timeValueArr = [[NSArray alloc] initWithObjects:
                        [NSNumber numberWithInt:3],
                        [NSNumber numberWithInt:10],
                        [NSNumber numberWithInt:40],
                        [NSNumber numberWithInt:90],
                        [NSNumber numberWithInt:VALUE_ALL],
                        nil];
    }
    return self;
}

//init run.
- (void)initRun {
    int     iVal = 0;  //last key as -1, other as 0.
    for (NSInteger i = [condKeyArr count] - 1; i >=0; i--) {
        NSString *key1 = [condKeyArr objectAtIndex:i];
        [runDict setObject:[NSNumber numberWithInt:iVal] forKey:key1];
    }
    
    nAdProviderIndex = -1;
    
    [adRunStateMgr clear];
}


//init the default conditions.
//mode -- Test, Real
//size -- auto
//time -- 3
- (void)initCondition {
    NSMutableArray *modeArr = [NSMutableArray arrayWithCapacity:2];
    [modeArr addObject:[NSNumber numberWithBool:YES]];
    [modeArr addObject:[NSNumber numberWithBool:NO]];
    
    NSMutableArray *sizeArr = [NSMutableArray arrayWithCapacity:5];
    [sizeArr addObject:[NSNumber numberWithInt:AdviewBannerSize_Auto]];
    //[sizeArr addObject:[NSNumber numberWithInt:AdviewBannerSize_320x50]];
    //[sizeArr addObject:[NSNumber numberWithInt:AdviewBannerSize_300x250]];
    //[sizeArr addObject:[NSNumber numberWithInt:AdviewBannerSize_480x60]];
    //[sizeArr addObject:[NSNumber numberWithInt:AdviewBannerSize_728x90]];
    
    NSMutableArray *timeArr = [NSMutableArray arrayWithCapacity:2];
    [timeArr addObject:[NSNumber numberWithInt:3]];
    
    conDict = [[NSMutableDictionary alloc] initWithCapacity:2];
    [conDict setObject:timeArr forKey:COND_KEY_TIME];
    [conDict setObject:modeArr forKey:COND_KEY_MODE];
    [conDict setObject:sizeArr forKey:COND_KEY_SIZE];
    
    runDict = [[NSMutableDictionary alloc] initWithCapacity:2];
    
    condKeyArr = [[NSArray alloc] initWithObjects:COND_KEY_TIME, COND_KEY_MODE, COND_KEY_SIZE, nil];
    
    [self initRun];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initCondition];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [self releaseAdView];
    
    conDict = nil;
    runDict = nil;
    
    condKeyArr = nil;
    
    adRunStateMgr = nil;
    
    modeNameArr = nil;
    modeValueArr = nil;
    sizeNameArr = nil;
    sizeValueArr = nil;
    timeNameArr = nil;
    timeValueArr = nil;
}

#pragma mark ui method


//show alert message.
- (void)showAlert:(NSString*)message {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"SingleTest"
                                               message:message
                                              delegate:self
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles:nil];
    [alert show];
 }

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
}

#pragma mark run test

//set single provider or set all.
- (void)setAllAdProviders:(BOOL)bVal Except:(int)type
{
    NSArray *keyArr = [self.adProviders allKeys];
    
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

//Set Label String, and set back button and cond buttons' state.
- (void)changeStartLabel {
    UIButton *btn = (UIButton*)[self.view viewWithTag:START_BTN_TAG];
    [btn setTitle:bInRun?@"Stop":@"Start" forState:UIControlStateNormal];

    if (nil != self.navigationController) {
        UINavigationBar *bar = self.navigationController.navigationBar;
        bar.userInteractionEnabled = !bInRun;
        bar.backItem.leftBarButtonItem.enabled = !bInRun;
    }
    int tags[] = {10, 11, 12};
    
    for (int i = 0; i < 3; i++) {
        UIButton *btn1 = ((UIButton*)[self.view viewWithTag:tags[i]]);
        btn1.enabled = !bInRun;
     
        [btn1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    }
}

- (void)setRunInfo:(NSString*)info {
    UITextView *tv = (UITextView*)[self.view viewWithTag:101];
    tv.text = info;
}

- (void)addRunInfo:(NSString*)info {
    UITextView *tv = (UITextView*)[self.view viewWithTag:101];
    tv.text = [NSString stringWithFormat:@"%@\n%@", tv.text, info];
}

- (void)stopRun {
    bToCancel = YES;
}

- (void)startRun {
    if (bInRun) {
        if (bToCancel) return;
        else [self stopRun];
    } else {
        [self initRun];
        [adRunStateMgr clear];
        [self setRunInfo:@""];
        
        bInRun = YES;
        [self performSelector:@selector(run)];
        
        [self changeStartLabel];
    }
}

//do end things.
- (void)execEnd {
    NSString *msg = bToCancel?@"User cancelled.":@"Finished run.";
    
    bInRun = NO;
    bToCancel = NO;
    
    [self showAlert:msg];
    [self changeStartLabel];
}

//run one step.
- (void)run {
    runTimer = nil;
    
    [self releaseAdView];   //release now.
    
    NSString *condName = [self getConditionName];
    AdRunStateItem *item1 = [adRunStateMgr lastRunStateItem:condName];
    if (nil == item1) {
        [self addRunInfo:[condName stringByAppendingString:@":"]];
    } else {
        [self addRunInfo:[item1 getInfo]];
    }
    
    if (bToCancel) {
        [self execEnd];
        return;
    }
    
    //start one.
    ++nAdProviderIndex;
    NSInteger count = [[self.adProviders allKeys] count];
    if (nAdProviderIndex >= count) {
        nAdProviderIndex = 0;
        
        //next condition, get condition.
        BOOL    bFind = NO;
        for (NSInteger i = [condKeyArr count] - 1; i >=0; i--) {
            NSString *key1 = [condKeyArr objectAtIndex:i];
            int     index1 = [[runDict objectForKey:key1] intValue];
            
            NSArray  *condArr = [conDict objectForKey:key1];
            if (index1 < [condArr count] - 1) {
                index1++;
                [runDict setObject:[NSNumber numberWithInt:index1] forKey:key1];
                bFind = YES;
                break;
            } else {    //set to first.
                index1 = 0;
                [runDict setObject:[NSNumber numberWithInt:index1] forKey:key1];
            }
        }
        if (!bFind) {       //finished.
            [self execEnd];
            return;
        }
        condName = [self getConditionName];     //changed.
        [self addRunInfo:[condName stringByAppendingString:@":"]];
    }
    
    AdRunStateItem *stateItem = [adRunStateMgr addOneRunStateItem:condName];
    stateItem.nIndex = nAdProviderIndex;

    NSNumber *keyNum = [[self.adProviders allKeys] objectAtIndex:nAdProviderIndex];
    [self setAllAdProviders:NO Except:[keyNum intValue]];
    
    NSString *strVal = [self.adProviders objectForKey:keyNum];
    NSArray *strItems = [strVal componentsSeparatedByString:@","];
    stateItem.platName = [strItems objectAtIndex:0];
    
    [self addAdView:self];
    
    
    int     nTime = [[[conDict objectForKey:COND_KEY_TIME] objectAtIndex:
                      [[runDict objectForKey:COND_KEY_TIME] intValue]] intValue];
    
    //if not finished, continue
    runTimer = [NSTimer scheduledTimerWithTimeInterval:nTime target:self
                                              selector:@selector(run) userInfo:nil repeats:NO];
}

//send info to email.
+ (void) sendEmail:(NSString *)to cc:(NSString*)cc subject:(NSString*)subject body:(NSString*)body
{
    NSString* str = [NSString stringWithFormat:@"mailto:%@?cc=%@&subject=%@&body=%@",
                     to, cc, subject, body];
    
    str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    
}

#pragma mark control action

//start button.
- (IBAction)adStartSingleTest:(id)sender
{
    [self startRun];
}

//show result info, to be into email.
- (IBAction)adShowTestResult:(id)sender
{
    if ([adRunStateMgr isEmpty]) {
        [self showAlert:@"Result is empty, don't send."];
        return;
    }
    
    [AdSingleTestViewController sendEmail:@"" cc:@"" subject:@"AdView SingleTest Result" body:[adRunStateMgr getResultInfo]];
}

//get index of number value in arry.
+ (int)indexOfObject:(NSNumber*)number inarray:(NSArray*)arr
{
    for (int i = 0; i < [arr count]; i++) {
        if ([[arr objectAtIndex:i] intValue] == [number intValue])
            return i;
    }
    
    return -1;
}


//condition select.
- (void)showSelectView:(NSArray*)names
{
    NSInteger idx = -1;
    if ([condArrForSelect count] > 1)
        idx = [valueArrForSelect count] - 1;
    else {
        idx = [AdSingleTestViewController indexOfObject:(NSNumber*)[condArrForSelect objectAtIndex:0]
                                                 inarray:valueArrForSelect];
    }
    
    CGRect rect = self.view.frame;
    rect.origin = CGPointMake(0, 0);
    UIView *view1 = [[UIView alloc] initWithFrame:rect];
    view1.backgroundColor = [UIColor lightGrayColor];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [btn1 setTitle:@"OK" forState:UIControlStateNormal];
    [btn2 setTitle:@"Cancel" forState:UIControlStateNormal];
    
    CGRect btnRt1 = CGRectMake(40, rect.size.height*2/3, 100, 30);
    CGRect btnRt2 = CGRectMake(200, rect.size.height*2/3, 100, 30);
    btn1.frame = btnRt1;
    btn2.frame = btnRt2;
    
    btn1.tag = OK_BTN_TAG;
    btn2.tag = CANCEL_BTN_TAG;
    
    CGRect segRt = CGRectMake(10, rect.size.height*1/3, rect.size.width-20, 40);
    UISegmentedControl *segView = [[UISegmentedControl alloc] initWithItems:names];
    segView.frame = segRt;
    segView.tag = SEG_VIEW_TAG;
    
    if (idx >= 0) segView.selectedSegmentIndex = idx;
    
    [btn1 addTarget:self action:@selector(adConfirmAction:) forControlEvents:UIControlEventTouchUpInside];
    [btn2 addTarget:self action:@selector(adConfirmAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [view1 addSubview:btn1];
    [view1 addSubview:btn2];
    [view1 addSubview:segView];
    
    [self.view addSubview:view1];
}


//select time condition
- (IBAction)adSelectTime:(id)sender
{
    condArrForSelect = [conDict objectForKey:COND_KEY_TIME];
    valueArrForSelect = timeValueArr;
    
    [self showSelectView:timeNameArr];
}

//select mode, test or real or both.
- (IBAction)adSelectMode:(id)sender
{
    condArrForSelect = [conDict objectForKey:COND_KEY_MODE];
    valueArrForSelect = modeValueArr;

    [self showSelectView:modeNameArr];
}

//select ad size.
- (IBAction)adSelectSize:(id)sender
{
    condArrForSelect = [conDict objectForKey:COND_KEY_SIZE];
    valueArrForSelect = sizeValueArr;
    
    [self showSelectView:sizeNameArr];
}


//button action in select view.
- (IBAction)adConfirmAction:(id)sender
{
    UIView *view1 = (UIView*)sender;
    
    switch (view1.tag) {
        case OK_BTN_TAG:
        {
            UISegmentedControl *segView = (UISegmentedControl*)[self.view viewWithTag:SEG_VIEW_TAG];
            NSInteger nSel = segView.selectedSegmentIndex;
            if (nSel == [valueArrForSelect count] - 1) {//all
                [condArrForSelect removeAllObjects];
                
                for (int i = 0; i < nSel; i++)
                    [condArrForSelect addObject:[valueArrForSelect objectAtIndex:i]];
            } else if (-1 != nSel) {
                [condArrForSelect removeAllObjects];
                
                [condArrForSelect addObject:[valueArrForSelect objectAtIndex:nSel]];
            }
            
            [view1.superview removeFromSuperview];
        }
            break;
        case CANCEL_BTN_TAG:
            [view1.superview removeFromSuperview];
            break;
    }
}

- (void)clearAdFunc {
    AdViewController *controller = [AdViewController sharedControllerIfExists];
    [controller.adView clearAdsAndStopAutoRefresh];
}

#pragma mark AdViewControllerDelegate methods

//got notify from ad.
- (void)didGotNotify:(NSString *)code Info:(NSString *)content
{
    AdRunStateItem *stateItem = [adRunStateMgr lastRunStateItem:[self getConditionName]];
    if ([code isEqualToString:@"toGetAd"]) {
        stateItem.nGet = stateItem.nGet + 1;
        
        //[self performSelector:@selector(clearAdFunc) withObject:nil afterDelay:0.5];
    }
    if ([code isEqualToString:@"show"]) {
        stateItem.nSuc = stateItem.nSuc + 1;
        
        //to get size.
        NSArray *strItems = [content componentsSeparatedByString:@";"];
        if ([strItems count] > 1) {
            if (stateItem.sizeInfo) 
                stateItem.sizeInfo = [NSString stringWithFormat:@"%@,%@", stateItem.sizeInfo, [strItems objectAtIndex:1]];
            else stateItem.sizeInfo = [strItems objectAtIndex:1];
        }
    }
    if ([code isEqualToString:@"failReq"]) {
        stateItem.nFail = stateItem.nFail + 1;
        if (nil != content)
            stateItem.failInfo = content;
    }
    if ([code isEqualToString:@"failGot"]) {
        //stateItem.nFail = stateItem.nFail + 1;
    }
    if ([code isEqualToString:@"adsAreOff"]) {
        stateItem.nOff = stateItem.nOff + 1;
    }
    
    UILabel *label = (UILabel*)[self.view viewWithTag:100];
    label.text = [NSString stringWithFormat:@"code:%@, info:%@", code, content];
}

@end

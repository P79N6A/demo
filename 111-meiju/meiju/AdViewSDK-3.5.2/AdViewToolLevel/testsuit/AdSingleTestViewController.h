//
//  AdSingleTestViewController.h
//  AdViewSDK
//
//  Created by zhiwen on 13-1-10.
//
//

#import <UIKit/UIKit.h>
#import "AdViewController.h"

@class AdRunStateManager;

@interface AdSingleTestViewController : UIViewController<AdViewControllerDelegate,
UIAlertViewDelegate> {
    NSMutableDictionary *conDict;
    //condition dictory, like:
    //"mode" -> mode array, like "test", "real", one or all these,
    //"size" -> size array, like "auto", "320x50", "300x250", "480x60", "728x90" one or all.
    //"wait" -> wait array, like "1", "5", "15", "50", "90"
    
    NSMutableDictionary *runDict;
    //like:
    //"mode" --> -1, to next, + 1
    //"size" --> -1, to next, + 1
    //"wait" --> -1, to next, + 1
    
    NSArray         *condKeyArr;     //for condition sort.
    
    NSTimer         *runTimer;
    
    BOOL            bInRun;
    BOOL            bToCancel;
    
    
    int             nAdProviderIndex;
    
    AdRunStateManager   *adRunStateMgr;
    
    
    NSArray     *sizeNameArr;
    NSArray     *sizeValueArr;
    
    NSArray     *modeNameArr;
    NSArray     *modeValueArr;
    
    NSArray     *timeNameArr;
    NSArray     *timeValueArr;
    
    
    NSMutableArray  *condArrForSelect;
    NSArray         *valueArrForSelect;
}

@property (retain) NSDictionary *adProviders;

- (IBAction)adStartSingleTest:(id)sender;
- (IBAction)adShowTestResult:(id)sender;

- (IBAction)adSelectTime:(id)sender;
- (IBAction)adSelectMode:(id)sender;
- (IBAction)adSelectSize:(id)sender;

@end

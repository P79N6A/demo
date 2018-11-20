//
//  Created by cq on 14-2-15.
//  Copyright (c) 2014年 cq. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PobAppFrameDelegate <NSObject,NSURLConnectionDelegate>
@optional
-(void)showPobFrameSucess;//插屏弹出成功
-(void)showPobFrameFail;//插屏弹出失败
-(void)closePobAppFrame;//插屏关闭
-(void)initPobFrameSuccess;//获取数据成功
-(void)initPobFrameFail;//获取数据失败
@end




@interface PobAppFrame : UIViewController<PobAppFrameDelegate>
{
    id<PobAppFrameDelegate> _delegate;
    NSMutableArray *_array;
    NSMutableData *_receivedData;
    UIViewController *_viewController;
    NSString *_orientation;
    NSString *_imagePath;
    NSString *_uniquePath;
    NSString *_gushowtag;
    NSMutableString *_initPar;
    
}
@property CGRect picFrame;
@property CGRect uiFrame;


-(id)orientation:(NSString *)orientations andDelegate:(id<PobAppFrameDelegate>)pobdelegate;
/**
 *  展示广告
 */
- (void)showpobFrame:(UIViewController*) mviewController;;
@end

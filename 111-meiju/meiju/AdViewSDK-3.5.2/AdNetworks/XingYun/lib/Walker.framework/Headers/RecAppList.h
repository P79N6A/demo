//
//  Created by cq on 14-2-15.
//  Copyright (c) 2014年 cq. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RecAppListDelegate <NSObject>

@optional
-(void)OpenRecAppList;//墙展示
-(void)CloseRecAppList;//墙关闭
@end

@interface RecAppList : UIViewController<UIWebViewDelegate,UIAlertViewDelegate>


@property (assign) id<RecAppListDelegate> delegate;

@end

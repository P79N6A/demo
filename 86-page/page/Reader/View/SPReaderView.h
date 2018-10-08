//
//  SPReaderView.h
//  page
//
//  Created by xin on 2018/10/6.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum : NSInteger {
    SPReaderShowTypeNone = 0,
    SPReaderShowTypeSet,
    SPReaderShowTypeMenu,
} SPReaderShowType;


@interface LightViewController : UIViewController @end
@interface SPReaderView : UIView
@property (nonatomic,copy) NSString *content;
@property (nonatomic, copy) NSString *progressTitle;
@property (nonatomic, assign) SPReaderShowType isShow;
@end

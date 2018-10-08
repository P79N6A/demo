//
//  SPReaderView.h
//  page
//
//  Created by xin on 2018/10/6.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPReaderView : UIView
@property (nonatomic,copy) NSString *content;
@property (nonatomic, copy) NSString *progressTitle;
@property (nonatomic, assign) BOOL isShow;

@end

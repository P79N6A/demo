//
//  EmptyView.h
//  bbox
//
//  Created by 何川 on 2018/3/15.
//  Copyright © 2018年 何川. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EmptyViewDelegate <NSObject>
-(void)clickEmptyViewWithAction:(UIView*)sender;
@end

@interface EmptyView : UIView
@property(nonatomic,weak) id<EmptyViewDelegate> delegates;
@property(nonatomic,copy) NSString *title;
-(instancetype)initWithFrame:(CGRect)frame;
@end


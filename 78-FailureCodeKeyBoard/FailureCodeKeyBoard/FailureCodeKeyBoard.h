//
//  FailureCodeKeyBoard.h
//  FailureCodeKeyBoard
//
//  Created by Jay on 25/6/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FailureCodeKeyBoard : UIView
@property (nonatomic, strong) NSArray *codes;
@property (nonatomic, copy) void(^clickBlock)(NSDictionary *codeObj);
@end

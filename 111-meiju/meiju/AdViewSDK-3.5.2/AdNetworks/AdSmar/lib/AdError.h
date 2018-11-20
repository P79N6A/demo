//
//  ErrorDescription.h
//  AD_Demo
//
//  Created by cheng ping on 14/11/27.
//  Copyright (c) 2014年 faf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdError : NSObject

@property (strong,nonatomic) NSString * errorDescription;
@property (assign,nonatomic) int        errorCode;

@end

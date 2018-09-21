//
//  SPExceptionHandler.h
//  SPExceptionHandler
//
//  Created by Jay on 21/9/18.
//  Copyright © 2018年 SP. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SPExceptionHandler : NSObject

@property (nonatomic, assign) BOOL isShowExceptionMessage;
@property (nonatomic, assign) BOOL isShowAlertView;

@property (nonatomic, copy) NSString * alertViewMessage;
@property (nonatomic, copy) NSString * alertViewTitle;

@property (nonatomic, copy) void (^doBlock)(NSString *message);
@property (nonatomic, copy) void (^logHandleBlock)(NSString *logFilePath);

@property (nonatomic, retain) NSString *exceptionFilePath;

+ (instancetype)defaultHandler;

void ExceptionHandlerFinishNotify();
SPExceptionHandler* InstallUncaughtExceptionHandler(void);
@end

NS_ASSUME_NONNULL_END

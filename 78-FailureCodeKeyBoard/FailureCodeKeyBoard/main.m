//
//  main.m
//  FailureCodeKeyBoard
//
//  Created by Jay on 25/6/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

#define __i386__

#ifdef __i386__
#import "DebugView.h"
#endif

int main(int argc, char *argv[])
{
    @autoreleasepool {
#ifdef __i386__
        return UIApplicationMain(argc, argv, @"DebugView", NSStringFromClass([AppDelegate class]));
#else
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
#endif
    }
}

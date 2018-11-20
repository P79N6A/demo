//
//  AdViewToolX.c
//  AdViewCocos2dxHello
//
//  Created by the user on 12-8-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#include "AdViewToolX.h"
#import "AdViewController.h"

extern "C"
void doAdViewNotifyApp(NSString *code, NSString *content)       //call to app.
{
    AdVLogInfo(@"code:%@, string:%@", code, content);
}

void AdViewToolX::setAdHidden(bool bHidden)
{
    AdViewController *controller = [AdViewController sharedControllerIfExists];
    [controller setAdHidden:bHidden];
}

void AdViewToolX::setAdPosition(int x, int y)
{
    AdViewController *controller = [AdViewController sharedControllerIfExists];
    [controller setAdPosition:CGPointMake(x, y)];
}

void AdViewToolX::requestNewAd()
{
    AdViewController *controller = [AdViewController sharedControllerIfExists];
    [controller requestNewAd];
}

void AdViewToolX::rollOver()
{
    AdViewController *controller = [AdViewController sharedControllerIfExists];
    [controller rollOver];
}

//
//  AdViewToolX.h
//  AdViewCocos2dxHello
//
//  Created by the user on 12-8-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#ifndef AdViewCocos2dxHello_AdViewToolX_h
#define AdViewCocos2dxHello_AdViewToolX_h

class AdViewToolX {
public:
    const static int AD_POS_TOP = 0;
    const static int AD_POS_LEFT = 0;
    const static int AD_POS_CENTER = -1;
    const static int AD_POS_RIGHT = -2;
    const static int AD_POS_BOTTOM = -2;
    
    static void setAdPosition(int x, int y);
    static void setAdHidden(bool bHidden);
    
    static void requestNewAd();
    static void rollOver();
};


#endif

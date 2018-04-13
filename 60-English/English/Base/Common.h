//
//  Common.h
//  English
//
//  Created by czljcb on 2018/4/13.
//  Copyright © 2018年 Jay. All rights reserved.
//

#ifndef Common_h
#define Common_h

#define kRandomColor kRGBColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

#define kColorWithHexString(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0 green:((float)((hex & 0xFF00) >> 8)) / 255.0 blue:((float)(hex & 0xFF)) / 255.0 alpha:1]


#endif /* Common_h */

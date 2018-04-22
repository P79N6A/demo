//
//  UIBarButtonItem+Button.h
//  LiZhiFM
//
//  Created by czljcb on 2018/4/22.
//  Copyright © 2018年 czljcb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Button)
+(UIBarButtonItem *)itemWithImage:(NSString *)image
//                  higlightedImage:(NSString *)hilight
                           target:(id)target
                           action:(SEL)action;
@end

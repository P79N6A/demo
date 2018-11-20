
//
//  Created by 深海 on 16/3/3.
//  Copyright © 2016年 faf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NativeAdDataModel : NSObject
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *image;
@property (nonatomic,copy) NSString *click_url;
@property (nonatomic,copy) NSString *landing_url;
@property (nonatomic,copy) NSString *impr_url;
@property (nonatomic,copy) NSString *adtype;

@property (nonatomic,copy) NSString *js_click;
@property (nonatomic,copy) NSString *js_imp;
@property (nonatomic,copy) NSString *js_con;
@end

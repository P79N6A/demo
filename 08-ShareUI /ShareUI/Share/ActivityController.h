//
//  Share.h
//  ShareUI
//
//  Created by pkss on 2017/5/10.
//  Copyright © 2017年 J. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemModel : NSObject

@property(nonatomic, copy,readonly)NSString *name;
@property(nonatomic, copy,readonly)NSString *logo;

- (instancetype)initWithLogo:(NSString *)logo Name:(NSString *)name;

@end

@interface ActivityController : UIViewController
@property(nonatomic, strong) NSArray <ItemModel *>*topItems;
@property(nonatomic, strong) NSArray <ItemModel *>*buttomItems;
@property(nonatomic, copy)void (^didSelect)(NSIndexPath*);
@end



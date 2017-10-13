//
//  PlayItem.h
//  FreeStreamerDemo
//
//  Created by FEIWU888 on 2017/10/12.
//  Copyright © 2017年 FEIWU888. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSPlayer.h"

@interface PlayItem : NSObject<FSPlayItemList>

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *author;

@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *pic;
@end

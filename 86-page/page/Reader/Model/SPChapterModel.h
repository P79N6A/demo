//
//  SPChapterModel.h
//  page
//
//  Created by Jay on 9/8/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPChapterModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong) NSMutableArray <NSNumber *>*pages;
@property (nonatomic, assign) NSInteger pageCount;
-(NSString *)stringOfPage:(NSUInteger)index;
-(void)updateFont;
@end

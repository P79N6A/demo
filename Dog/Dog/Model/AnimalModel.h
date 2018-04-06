//
//  AnimalModel.h
//  Dog
//
//  Created by czljcb on 2018/4/6.
//  Copyright © 2018年 czljcb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnimalModel : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *voice;


+ (NSMutableArray <AnimalModel *>*)modelFormArray:(NSArray <NSDictionary *>*)objs;
@end

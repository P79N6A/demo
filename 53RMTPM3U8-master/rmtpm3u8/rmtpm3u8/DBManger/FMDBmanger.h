//
//  FMDBmanger.h
//  rmtpm3u8
//  不进行并发操作ok
//  Created by 何川 on 2018/3/21.
//  Copyright © 2018年 何川. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TVmodel.h"
@interface FMDBmanger : NSObject

//做一次创建操作
+(instancetype)shareManger;
-(void)insertTVmodelData:(TVmodel*)model;
-(NSArray*)getAllTvModels;
-(BOOL)deleateTvModel:(TVmodel*)model;

@end

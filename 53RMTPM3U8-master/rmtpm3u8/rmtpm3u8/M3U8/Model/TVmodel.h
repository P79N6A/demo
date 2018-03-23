//
//  TVmodel.h
//  rmtpm3u8
//
//  Created by 何川 on 2018/3/20.
//  Copyright © 2018年 何川. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface TVmodel : JSONModel
@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *urlString;
@property(nonatomic,strong) NSNumber *itemId;
@end

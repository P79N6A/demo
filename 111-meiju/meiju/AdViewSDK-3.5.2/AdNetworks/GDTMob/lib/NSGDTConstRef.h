//
//  NSGDTConstRef.h
//  KuaiYouAdHello
//
//  Created by maming on 2018/6/19.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    GDTConstRefTitle,
    GDTConstRefDesc,
    GDTConstRefIconUrl,
    GDTConstRefImgUrl,
    GDTConstRefAppRating,
    GDTConstRefAppPrice,
} GDTConstRefName;

@interface NSGDTConstRef : NSObject

+(NSString*)refConst:(GDTConstRefName)refName;

@end

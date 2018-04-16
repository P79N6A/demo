
#import <Foundation/Foundation.h>

@interface XYYModel : NSObject

@property (nonatomic, strong) NSString *des;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *dizhi;

@property (nonatomic, strong) NSString *url;

@property (nonatomic, strong) NSString *img;

@property (nonatomic, strong) NSString *id;

@property (nonatomic, strong) NSString *bofang;

@property (nonatomic, strong) NSString *m3u8;

@property (nonatomic, strong) NSString *zhuti;

@property (nonatomic, strong) NSString *downbofang;

@property (nonatomic, strong) NSArray *data;

+ (NSMutableArray <XYYModel *>*)objFormArray:(NSArray <NSDictionary *>*)arrays;

@end


#import <Foundation/Foundation.h>

@interface XYYF : NSObject

+ (void)removeDirectoryPath:(NSString *)directoryPath;

+ (void)calculateCache:(NSString *)directoryPath
            completion:(void(^)(NSInteger))completion;

@end

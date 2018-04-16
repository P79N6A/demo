
#import "XYYModel.h"

@implementation XYYModel

//MJCodingImplementation

+ (NSMutableArray <XYYModel *>*)objFormArray:(NSArray <NSDictionary *>*)arrays{
    NSMutableArray *temps = [NSMutableArray arrayWithCapacity:arrays.count];
    [arrays enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        XYYModel *model = [XYYModel new];
        [model setValuesForKeysWithDictionary:obj];
        [temps addObject:model];
    }];
    return temps;
}

@end

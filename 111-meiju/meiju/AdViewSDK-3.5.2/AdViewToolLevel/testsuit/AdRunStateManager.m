//
//  AdRunStateManager.m
//  AdViewSDK
//
//  Created by zhiwen on 13-1-10.
//
//

#import "AdRunStateManager.h"

@implementation AdRunStateItem

@synthesize platName;
@synthesize sizeInfo;
@synthesize failInfo;
@synthesize nIndex, nFail, nSuc, nGet, nOff;

- (NSString *)getInfo {
    NSString *ret = [NSString stringWithFormat:@"%d\t%@\t%d\t%d\t%d\t%d\t%@\t%@", nIndex,
                     platName, nOff, nGet, nSuc, nFail, sizeInfo,
                     (nil!=failInfo)?failInfo:@""];
    return ret;
}

@end

@implementation AdRunStateManager

- (id)init {
    self = [super init];
    if (nil != self) {
        stateDict = [[NSMutableDictionary alloc] initWithCapacity:3];
    }
    return self;
}

- (void)clear {
    [stateDict removeAllObjects];
}

- (void)dealloc {
    [self clear];
    
    
}

- (void)setCondition:(NSString*)name {
    NSMutableArray *arr1 = [stateDict objectForKey:name];
    if (nil != arr1) return;
    arr1 = [NSMutableArray arrayWithCapacity:4];
    [stateDict setObject:arr1 forKey:name];
}

- (AdRunStateItem*)lastRunStateItem:(NSString*)name {
    NSMutableArray *arr1 = [stateDict objectForKey:name];
    if (nil == arr1) return nil;
    
    return [arr1 lastObject];
}

- (AdRunStateItem*)addOneRunStateItem:(NSString*)name {
    [self setCondition:name];
    
    NSMutableArray *arr1 = [stateDict objectForKey:name];
    if (nil == arr1) return nil;
    
    AdRunStateItem *item = [[AdRunStateItem alloc] init];
    [arr1 addObject:item];
    return item;
}

- (BOOL)isEmpty {
    NSArray *keyArr = [stateDict allKeys];
    return ([keyArr count] < 1);
}

- (NSString*)getResultInfo {
    NSMutableString *ret = [NSMutableString stringWithString:@"empty"];
    
    NSArray *keyArr = [stateDict allKeys];
    if ([keyArr count] < 1) return ret;
    [ret setString:@""];
    
    for (NSString *key1 in keyArr) {
        [ret appendString:key1];
        [ret appendString:@":\n"];
        
        NSMutableArray *arr1 = [stateDict objectForKey:key1];
        for (AdRunStateItem *item in arr1) {
            [ret appendString:[item getInfo]];
            [ret appendString:@"\n"];
        }
    }
    
    return ret;
}

@end

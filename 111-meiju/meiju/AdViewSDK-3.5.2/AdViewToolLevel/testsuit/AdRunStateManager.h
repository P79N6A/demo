//
//  AdRunStateManager.h
//  AdViewSDK
//
//  Created by zhiwen on 13-1-10.
//
//

#import <Foundation/Foundation.h>

@interface AdRunStateItem : NSObject {
    
}

@property (retain) NSString  *platName;
@property (assign) int       nIndex;
@property (assign) int       nFail;
@property (assign) int       nSuc;
@property (assign) int       nGet;
@property (assign) int       nOff;
@property (retain) NSString  *sizeInfo;     //get size.
@property (retain) NSString  *failInfo;     //the last fail info.

- (NSString *)getInfo;

@end

@interface AdRunStateManager : NSObject {
    NSMutableDictionary     *stateDict;     //run state. NSMutableArray for condition name.
}

- (void)setCondition:(NSString*)name;
- (AdRunStateItem*)lastRunStateItem:(NSString*)name;
- (AdRunStateItem*)addOneRunStateItem:(NSString*)name;

- (NSString*)getResultInfo;

- (BOOL)isEmpty;

- (void)clear;

@end

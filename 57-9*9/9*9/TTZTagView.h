//
//  TTZTagView.h
//  9*9
//
//  Created by Jay on 2018/4/3.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTZMoveView : UILabel
@property (nonatomic, copy) void(^moveBlock)(UIView*);
@end

@interface TTZModel : NSObject
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, weak) TTZMoveView *view;

@end



@interface NSMutableArray (Shuffling)
- (void)shuffle;
@end


@interface TTZTagView : UIView
/** 2*2 .... */
@property (nonatomic, assign) NSInteger ladder;
-(void)reset;
@end

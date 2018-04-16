//
//  HTMLManager.h
//  getHTML
//
//  Created by czljcb on 2017/11/25.
//  Copyright © 2017年 czljcb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTMLManager : NSObject
+ (instancetype)sharedInstance;
- (void)getHtmlWithURL:(NSString *)urlString
                sucess:(void (^)(NSString *html))htmlBlock
                 error:(void (^)( NSError *error))errorBlock;
@end

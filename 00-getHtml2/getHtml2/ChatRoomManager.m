//
//  ChatRoomManager.m
//  getHtml2
//
//  Created by czljcb on 2017/12/30.
//  Copyright © 2017年 czljcb. All rights reserved.
//

#import "ChatRoomManager.h"

@implementation ChatRoomManager


+ (void)getChatRoomTokenSuccess:(void(^)(NSString* accessToken))success failure:(void(^)(NSString *error))failure{


    
    
    NSURL *url = [NSURL URLWithString:@"https://a1.easemob.com/1157170419178547/tv/token"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    request.HTTPBody = [@"{\"grant_type\":\"client_credentials\",\"client_id\":\"YXA6zzLdQCUJEeebLlUL7cvnFA\",\"client_secret\":\"YXA66SG7hwTE89cz-zH3RPb_7klRjQU\"}" dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSession *session = [NSURLSession sharedSession];
    // 由于要先对request先行处理,我们通过request初始化task
    NSURLSessionTask *task = [session dataTaskWithRequest:request
                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                            
                                            if (error) {
                                                failure(error.localizedDescription);
                                                return ;
                                            }
                                            
                                            NSLog(@"%@", [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]);
                                            
                                            NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                                            
                                            
                                            success([obj valueForKey:@"access_token"]);
                                            
                                        }];
    [task resume];

}


+ (void)getChatRoomSuccess:(void(^)(NSArray* datas))success failure:(void(^)(NSString *error))failure{
    
    NSURL *url = [NSURL URLWithString:@"https://a1.easemob.com/1157170419178547/tv/chatrooms?pagenum=1&pagesize=999999"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";
    NSString *author = [NSString stringWithFormat:@"Bearer YWMtz-GYRCUJEeeCw08-ZIeQIAAAAAAAAAAAAAAAAAAAAAHPMt1AJQkR55suVQvty-cUAgMAAAFbhov9jQBPGgCczdnz2kopha-tXI763U039EVN2wFD17WO0e27o7TYpA"];
    [request setValue:author forHTTPHeaderField:@"Authorization"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    // 由于要先对request先行处理,我们通过request初始化task
    NSURLSessionTask *task = [session dataTaskWithRequest:request
                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                            
                                            if (error) {
                                                failure(error.localizedDescription);
                                                return ;
                                            }
                                            
                                            NSLog(@"%@", [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]);
                                            
                                            NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                                            
                                            
                                            success([obj valueForKey:@"data"]);
                                            
                                        }];
    [task resume];

}

+ (void)createChatRoomName:(NSString *)name Success:(void(^)(NSString* roomId))success failure:(void(^)(NSString *error))failure{
    
    NSURL *url = [NSURL URLWithString:@"https://a1.easemob.com/1157170419178547/tv/chatrooms"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSString *author = [NSString stringWithFormat:@"Bearer YWMtz-GYRCUJEeeCw08-ZIeQIAAAAAAAAAAAAAAAAAAAAAHPMt1AJQkR55suVQvty-cUAgMAAAFbhov9jQBPGgCczdnz2kopha-tXI763U039EVN2wFD17WO0e27o7TYpA"];
    [request setValue:author forHTTPHeaderField:@"Authorization"];
    

    NSString *body = [NSString stringWithFormat:@"{\"name\":\"%@\",\"description\":\"server create chatroom\",\"owner\":\"Jayson\"}",name];
    request.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];

    NSURLSession *session = [NSURLSession sharedSession];
    // 由于要先对request先行处理,我们通过request初始化task
    NSURLSessionTask *task = [session dataTaskWithRequest:request
                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                            
                                            if (error) {
                                                failure(error.localizedDescription);
                                                return ;
                                            }
                                            
                                            NSLog(@"%@", [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]);
                                            
                                            NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                                            
                                            
                                            success([[obj valueForKey:@"data"] valueForKey:@"id"]);
                                            
                                        }];
    [task resume];
    
}

@end

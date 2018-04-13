//
//  YHBackgroundService.m
//  YHWanGuoTechnicians
//
//  Created by Jay on 2018/3/7.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHBackgroundService.h"

#import "AppDelegate.h"

//分隔符
#define Boundary @"--------------------------392190892696659155307772"//@"1a2b3c"
//一般换行
#define Wrap1 @"\r\n"
//key-value换行
#define Wrap2 @"\r\n\r\n"
//开始分割
#define StartBoundary [NSString stringWithFormat:@"--%@%@",Boundary,Wrap1]
//文件分割完成
#define EndBody [NSString stringWithFormat:@"--%@--%@",Boundary,Wrap1]



@interface YHBackgroundService()
<NSURLSessionDelegate,NSURLSessionTaskDelegate,NSURLSessionDataDelegate>

@property (nonatomic, strong) NSURLSession * backgroundSession;

@property (nonatomic, strong) NSMutableData *responseData;

@property (nonatomic, copy) ProgressType progress;

@property (nonatomic, copy) CompleteType complete;

/** 临时文件路径 */
@property (nonatomic, copy) NSString *tempPath;

@end

@implementation YHBackgroundService


#pragma mark  -   创建后台请求session

- (void)creatBackgroundSession{
    
    
    NSDate *nowDate = [NSDate date];
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    
    dateFormatter.dateFormat = @"YYYYMMddHHMMSS";
    NSString *dateStr = [dateFormatter stringFromDate:nowDate];
    
    CFTimeInterval curTime = CFAbsoluteTimeGetCurrent();

    
    NSInteger randomNum = random()%10000+1;
    NSString *configrationIdentifier = [NSString stringWithFormat:@"XY-%@-%ld-%f",dateStr,(long)randomNum,curTime];
    NSURLSessionConfiguration *backgroundSessionConfigration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:configrationIdentifier];
    
    NSLog(@"%s--%@", __func__,configrationIdentifier);
    //设置后台上传时的超时timeoutIntervalForResource，默认值为1周
    backgroundSessionConfigration.timeoutIntervalForResource = 24*60*60;
    
    backgroundSessionConfigration.HTTPMaximumConnectionsPerHost = 1;
    self.backgroundSession = [NSURLSession sessionWithConfiguration:backgroundSessionConfigration delegate:self delegateQueue:NSOperationQueue.mainQueue];
    
    
}

#pragma mark  -   构建请求头
-(NSMutableURLRequest*)uploadTaskRequest:(NSString *)url
{
    NSURL *PdefaultUrl = [NSURL URLWithString:url];//
    
    //NSURL *PdefaultUrl = [NSURL URLWithString:@"https://sm.ms/api/upload"];//
    //    NSURL *PdefaultUrl = [NSURL URLWithString:@"http://192.168.1.59/upload_file.php"];
    NSMutableURLRequest* request=[NSMutableURLRequest requestWithURL:PdefaultUrl];
    request.HTTPMethod=@"POST";
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@",Boundary]
   forHTTPHeaderField:@"Content-Type"];
    
    
    //设置请求头
    return request;
    
}
#pragma mark  - 构建目标文件的路径2
-(NSString*)uploadTaskRequestBody2:(NSData *)data
                       parameters:(NSDictionary *)dictionary
                             name:(NSString *)name
                         fileName:(NSString *)fileName{
    
    NSMutableData* totlData=[NSMutableData new];
    NSArray* allKeys=[dictionary allKeys];
    for (int i=0; i<allKeys.count; i++)
    {
        
        NSString *disposition = [NSString stringWithFormat:@"%@Content-Disposition: form-data; name=\"%@\"%@",StartBoundary,allKeys[i],Wrap2];
        NSString* object=[dictionary objectForKey:allKeys[i]];
        disposition =[disposition stringByAppendingString:object];
        disposition =[disposition stringByAppendingString:Wrap1];
        [totlData appendData:[disposition dataUsingEncoding:NSUTF8StringEncoding]];
        
    }
    NSString *body=[NSString stringWithFormat:@"%@Content-Disposition: form-data; name=\"%@\"; filename=\"%@\" %@Content-Type: image/png%@",StartBoundary,name,fileName,Wrap1,Wrap2];
    
    [totlData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];

    [totlData appendData:data];
    
    [totlData appendData:[Wrap1 dataUsingEncoding:NSUTF8StringEncoding]];
    [totlData appendData:[EndBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"uploadTemp"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:NULL]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path
                                  withIntermediateDirectories:YES
                                                   attributes:NULL
                                                        error:NULL];
    }
    
    
    NSString *tempFilePath = [path stringByAppendingPathComponent:fileName];
    self.tempPath = tempFilePath;
    
    [totlData writeToFile:tempFilePath atomically:YES];
    
    return tempFilePath;//totlData;
}

#pragma mark  - 构建目标文件的路径
-(NSString*)uploadTaskRequestBody:(NSData *)data
                         parameters:(NSDictionary *)dictionary
                               name:(NSString *)name
                           fileName:(NSString *)fileName{
    
    
    //NSString *fileName = [NSString stringWithFormat:@"%d",rand()/10000];
    NSMutableData* totlData=[NSMutableData new];
//    dictionary=@{@"name":@"testname",
//                 @"APPversion":@"3.2.3",
//                 @"serverIp":@"127.0.0.1",
//                 @"clientType":@"2"};
    NSArray* allKeys=[dictionary allKeys];
    for (int i=0; i<allKeys.count; i++)
    {
        
        NSString *disposition = [NSString stringWithFormat:@"%@Content-Disposition: form-data; name=\"%@\"%@",StartBoundary,allKeys[i],Wrap2];
        NSString* object=[dictionary objectForKey:allKeys[i]];
        disposition =[disposition stringByAppendingString:object];
        disposition =[disposition stringByAppendingString:Wrap1];
        //        NSLog(@"%s\n%@",__FUNCTION__,disposition);
        [totlData appendData:[disposition dataUsingEncoding:NSUTF8StringEncoding]];
        
    }
//    NSString *body=[NSString stringWithFormat:@"%@Content-Disposition: form-data; name=\"%@\"; filename=\"%@\";Content-Type:application/octet-stream%@",StartBoundary,name,fileName,Wrap2];// ok的
    NSString *body=[NSString stringWithFormat:@"%@Content-Disposition: form-data; name=\"%@\"; filename=\"%@\";Content-Type:image/png%@",StartBoundary,name,fileName,Wrap2];

    [totlData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    //NSData* data = [[NSData alloc] initWithContentsOfURL:file];
    //    NSData *data = UIImagePNGRepresentation([UIImage imageNamed:@"1.png"]);
    [totlData appendData:data];
    [totlData appendData:[Wrap1 dataUsingEncoding:NSUTF8StringEncoding]];
    [totlData appendData:[EndBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"uploadTemp"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:NULL]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path
                                  withIntermediateDirectories:YES
                                                   attributes:NULL
                                                        error:NULL];
    }

    
    NSString *tempFilePath = [path stringByAppendingPathComponent:fileName];
    self.tempPath = tempFilePath;
    
    [totlData writeToFile:tempFilePath atomically:YES];
    
    return tempFilePath;//totlData;
}

//MARK: - 单个文件上传
- (void)uploadFormData:(NSData *)data
                   url:(NSString *)url
            parameters:(NSDictionary*)parameters
                  name:(NSString *)name
              fileName:(NSString *)fileName
              currentProgress:(ProgressType)progress
              didComplete:(CompleteType)complete
                        {
    
                            self.progress = progress;
                            self.complete = complete;
                            
    [self creatBackgroundSession];
    
    NSString *tempFilePath  = [self uploadTaskRequestBody2:data parameters:parameters name:name fileName:fileName];
    NSURL *fileURL = [NSURL fileURLWithPath:tempFilePath];
    NSMutableURLRequest * request = [self uploadTaskRequest:url];
    
    NSURLSessionUploadTask* backgroundTask = [self.backgroundSession uploadTaskWithRequest:request fromFile:fileURL];
    
    // 开始下载
    [backgroundTask resume];
    
}


#pragma mark  -  NSURLSessionTaskDelegate
#pragma mark  -  上传进度
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
   didSendBodyData:(int64_t)bytesSent
    totalBytesSent:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend{
    CGFloat  currentProgress = (totalBytesSent * 1.0) / totalBytesExpectedToSend;
    !(_progress)? : _progress(currentProgress);
    
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error{
    
    if (error != nil){
        !(_complete)? : _complete(nil,error);
    }else{
        id obj = [NSJSONSerialization JSONObjectWithData:self.responseData
                                                            options:NSJSONReadingMutableContainers
                                                              error:NULL];
        [[NSFileManager defaultManager] removeItemAtPath:self.tempPath error:NULL];
        self.responseData = nil;
        self.tempPath = nil;
        
        !(_complete)? : _complete(obj,nil);
    }
}


#pragma mark  -  NSURLSessionDelegate
#pragma mark  -  后台处理
- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session{
    
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if((appDelegate.handler) != nil) {
        // 执行上传完成delegate
        appDelegate.handler();
        appDelegate.handler = nil;
        
    }
    
}
#pragma mark  -  NSURLSessionDataDelegate
#pragma mark  -  响应数据

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data{
    if (self.responseData == nil) {
        self.responseData = [NSMutableData dataWithData:data];
    }else{
        [self.responseData appendData:data];
    }
    
    
}

- (void)stop{
    [self.backgroundSession finishTasksAndInvalidate];
}


@end

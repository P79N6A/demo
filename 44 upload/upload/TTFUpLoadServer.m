//
//  TTFUpLoadServer.m
//  upload
//
//  Created by Jay on 2018/3/1.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "TTFUpLoadServer.h"
#import "AppDelegate.h"

//分隔符
#define Boundary @"1a2b3c"
//一般换行
#define Wrap1 @"\r\n"
//key-value换行
#define Wrap2 @"\r\n\r\n"
//开始分割
#define StartBoundary [NSString stringWithFormat:@"--%@%@",Boundary,Wrap1]
//文件分割完成
#define EndBody [NSString stringWithFormat:@"--%@--",Boundary]


@interface TTFUpLoadServer ()<NSURLSessionDelegate,NSURLSessionTaskDelegate,NSURLSessionDataDelegate>

@property (nonatomic, strong) NSURLSession * backgroundSession;

@property (nonatomic, strong) NSMutableData *responseData;

@end


@implementation TTFUpLoadServer
//MARK: - 创建后台请求session
- (void)creatBackgroundSession{
    
    
    NSDate *nowDate = [NSDate date];
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    
    dateFormatter.dateFormat = @"YYYYMMddHHMMSS";
    NSString *dateStr = [dateFormatter stringFromDate:nowDate];
    
    NSInteger randomNum = random()%10000+1;
    NSString *configrationIdentifier = [NSString stringWithFormat:@"XY%@%ld",dateStr,(long)randomNum];
    NSURLSessionConfiguration *backgroundSessionConfigration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:configrationIdentifier];
    
    //设置后台上传时的超时timeoutIntervalForResource，默认值为1周
    backgroundSessionConfigration.timeoutIntervalForResource = 24*60*60;
    
    backgroundSessionConfigration.HTTPMaximumConnectionsPerHost = 1;
    self.backgroundSession = [NSURLSession sessionWithConfiguration:backgroundSessionConfigration delegate:self delegateQueue:NSOperationQueue.mainQueue];
    
    
}
-(NSMutableURLRequest*)TSuploadTaskRequest:(NSString *)url
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

-(NSString*)TSuploadTaskRequestBody:(NSData *)data
                         parameters:(NSDictionary *)dictionary
                         name:(NSString *)name
                         fileName:(NSString *)fileName{
    
    
    //NSString *fileName = [NSString stringWithFormat:@"%d",rand()/10000];
    NSMutableData* totlData=[NSMutableData new];
    dictionary=@{@"name":@"testname",
                               @"APPversion":@"3.2.3",
                               @"serverIp":@"127.0.0.1",
                               @"clientType":@"2"};
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
    NSString *body=[NSString stringWithFormat:@"%@Content-Disposition: form-data; name=\"%@\"; filename=\"%@\";Content-Type:application/octet-stream%@",StartBoundary,name,fileName,Wrap2];
    [totlData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    //NSData* data = [[NSData alloc] initWithContentsOfURL:file];
    //    NSData *data = UIImagePNGRepresentation([UIImage imageNamed:@"1.png"]);
    [totlData appendData:data];
    [totlData appendData:[Wrap1 dataUsingEncoding:NSUTF8StringEncoding]];
    [totlData appendData:[EndBody dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    NSString *tempFilePath = [path stringByAppendingPathComponent:fileName];
    
    [totlData writeToFile:tempFilePath atomically:YES];
    
    return tempFilePath;//totlData;
}

//MARK: - 单个文件上传
- (void)uploadFormData:(NSData *)data
                       url:(NSString *)url
                parameters:(NSDictionary*)parameters
                      name:(NSString *)name
                  fileName:(NSString *)fileName{
    
    [self creatBackgroundSession];
    
    NSString *tempFilePath  = [self TSuploadTaskRequestBody:data parameters:parameters name:name fileName:fileName];
    NSURL *fileURL = [NSURL fileURLWithPath:tempFilePath];
    NSMutableURLRequest * request = [self TSuploadTaskRequest:url];
    
    NSURLSessionUploadTask* backgroundTask = [self.backgroundSession uploadTaskWithRequest:request fromFile:fileURL];
    
    // 开始下载
    [backgroundTask resume];
    
}



- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
   didSendBodyData:(int64_t)bytesSent
    totalBytesSent:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend{
    CGFloat  currentProgress = (totalBytesSent * 100.0) / totalBytesExpectedToSend;
    NSLog(@"%s----%f", __func__,currentProgress);
    
    //self.progress.progress = currentProgress * 0.01;
}


- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session{
    
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if((appDelegate.handler) != nil) {
        // 执行上传完成delegate
        appDelegate.handler();
        appDelegate.handler = nil;
        
    }
    
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data{
    if (self.responseData == nil) {
        self.responseData = [NSMutableData dataWithData:data];
    }else{
        [self.responseData appendData:data];
    }
    
    
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error{
    
    if (error != nil){
        NSLog(@"%s---error:%@", __func__,error);
    }else{
        
        
        NSString *msg = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
        self.responseData = nil;
        NSLog(@"%s---上传成功:%@", __func__,msg);
        
        
    }
    
}



@end

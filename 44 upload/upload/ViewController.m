//
//  ViewController.m
//  upload
//
//  Created by Jay on 2018/2/28.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "ViewController.h"
#import "TTFUpLoadServer.h"
#import "AppDelegate.h"
#import <AFNetworking.h>
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


@interface ViewController ()<NSURLSessionDelegate,NSURLSessionTaskDelegate,NSURLSessionDataDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) NSURLSession * backgroundSession;

@property (nonatomic, strong) NSMutableData *responseData;
/** <##> */
@property (nonatomic, strong) NSData *data;
@property (weak, nonatomic) IBOutlet UIProgressView *progress;

@end

@implementation ViewController
-(NSString*)TSuploadTaskRequestBody{


    NSString *fileName = [NSString stringWithFormat:@"%d",rand()/10000];
    NSMutableData* totlData=[NSMutableData new];
    NSDictionary* dictionary=@{@"name":@"testname",
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
    NSString *body=[NSString stringWithFormat:@"%@Content-Disposition: form-data; name=\"smfile\"; filename=\"%@\";Content-Type:application/octet-stream%@",StartBoundary,fileName,Wrap2];
    [totlData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    NSData* data = self.data;//[[NSData alloc] initWithContentsOfURL:file];
//    NSData *data = UIImagePNGRepresentation([UIImage imageNamed:@"1.png"]);
    [totlData appendData:data];
    [totlData appendData:[Wrap1 dataUsingEncoding:NSUTF8StringEncoding]];
    [totlData appendData:[EndBody dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    NSString *tempFilePath = [path stringByAppendingPathComponent:fileName];

    [totlData writeToFile:tempFilePath atomically:YES];

    return tempFilePath;//totlData;
}
-(NSMutableURLRequest*)TSuploadTaskRequest
{
    NSURL *PdefaultUrl = [NSURL URLWithString:@"https://sm.ms/api/upload"];//
//    NSURL *PdefaultUrl = [NSURL URLWithString:@"http://127.0.0.1/upload_file.php"];
    NSMutableURLRequest* request=[NSMutableURLRequest requestWithURL:PdefaultUrl];
    request.HTTPMethod=@"POST";
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@",Boundary]
   forHTTPHeaderField:@"Content-Type"];


    //设置请求头



    return request;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    NSURLSession *se = [NSURLSession sharedSession];
    
    NSURLSessionUploadTask* backgroundTask = [se uploadTaskWithRequest:[self TSuploadTaskRequest] fromFile:[NSURL fileURLWithPath:@"/Users/jay/Desktop/曹志.pdf"] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

        NSLog(@"%s", __func__);
    }];
    
    [backgroundTask resume];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;//sourcetype有三种分别是camera，photoLibrary和photoAlbum
    NSArray *availableMedia = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];//Camera所支持的Media格式都有哪些,共有两个分别是@"public.image",@"public.movie"
//    ipc.mediaTypes = [NSArray arrayWithObject:availableMedia[0]];//设置媒体类型为public.movie
    [self presentViewController:ipc animated:YES completion:nil];
    ipc.delegate = self;//设置委托

    

}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSLog(@"%s", __func__);
    
    NSURL * url = info[@"UIImagePickerControllerMediaURL"];
    UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
    NSData *data =  UIImagePNGRepresentation(image);

    [self startBackgroudUpdload];

//    NSDictionary* dictionary=@{@"name":@"testname",
//                 @"APPversion":@"3.2.3",
//                 @"serverIp":@"127.0.0.1",
//                 @"clientType":@"2"};
//
//    [[TTFUpLoadServer new] uploadFormData:data
//                                      url:@"http://192.168.1.59/upload_file.php"//@"https://sm.ms/api/upload"
//                                   parameters:dictionary
//                                         name:@"smfile"
//                                 fileName:@"112.png"];
//
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}

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



//MARK: - 准备开始后台上传
- (void)startBackgroudUpdload{


    //当点击上传时，创建session
    [self creatBackgroundSession];

    [self uploadFile];
}

//MARK: - 单个文件上传
- (void)uploadFile {

    NSString *tempFilePath  = [self TSuploadTaskRequestBody];
    NSURL *url = [NSURL fileURLWithPath:tempFilePath];
    NSMutableURLRequest * request = [self TSuploadTaskRequest];

    NSURLSessionUploadTask* backgroundTask = [self.backgroundSession uploadTaskWithRequest:request fromFile:url];

    // 开始下载
    [backgroundTask resume];

}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
   didSendBodyData:(int64_t)bytesSent
    totalBytesSent:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend{
    CGFloat  currentProgress = (totalBytesSent * 100.0) / totalBytesExpectedToSend;
    NSLog(@"%s----%f", __func__,currentProgress);

    self.progress.progress = currentProgress * 0.01;
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

//
//  ViewController.m
//  download
//
//  Created by czljcb on 2017/8/23.
//  Copyright © 2017年 czljcb. All rights reserved.
//

#import "ViewController.h"

#import <AFNetworking.h>

@interface ViewController ()
@property (nonatomic, strong) NSOperationQueue *queue;
/** <##> */
@property (nonatomic, strong) NSMutableArray *TASKS;
@property (nonatomic, strong) NSArray *tasks;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _TASKS = [NSMutableArray array];
    // Do any additional setup after loading the view, typically from a nib.
//     _queue = [[NSOperationQueue alloc] init];
//     _queue.maxConcurrentOperationCount = 2;
    for (int i = 0; i < 15; i++) {
        
//        NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
            [self d:i t:nil g:nil];

//        }];
        
        
//        [_queue addOperation:operation];

        
        
    }
    
    _tasks = _TASKS.mutableCopy;
    [self.TASKS.lastObject resume];
    [self.TASKS removeLastObject];
    [self.TASKS.lastObject resume];


}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    return;
    dispatch_group_t group = dispatch_group_create();
    dispatch_semaphore_t  semaphore = dispatch_semaphore_create(2);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    for (int i = 0; i < 5; i++) {
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_group_async(group, queue, ^{
            
            NSLog(@"-----------%d",i);
            //            [self d:i t:semaphore g:group];
            sleep(10);

            dispatch_semaphore_signal(semaphore);
            
        });
    }
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);

    
}

- (void)d:(int)i t:(dispatch_semaphore_t) semaphore g:(dispatch_group_t)group{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:@"http://i.snssdk.com/neihan/video/playback/?video_id=3bff9f1f1c7342d79247c18289f013e5&quality=480p&line=0&is_gif=0"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"%d----%f",i, 1.0 * downloadProgress.completedUnitCount/downloadProgress.totalUnitCount);
    }destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%d%@",i,[response suggestedFilename]]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
        //dispatch_semaphore_signal(semaphore);
        [self.TASKS removeLastObject];
        [self.TASKS.lastObject resume];

    }];
    [self.TASKS addObject:downloadTask];
//    [downloadTask resume];
    //dispatch_group_wait(group, DISPATCH_TIME_FOREVER);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

//
//  ViewController.m
//  局域网传文件
//
//  Created by czljcb on 2017/8/13.
//  Copyright © 2017年 czljcb. All rights reserved.
//




#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <GCDWebUploader.h>

@interface ViewController ()<GCDWebUploaderDelegate>


@property (nonatomic, strong) GCDWebUploader *webServer;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *fileNameAray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"添加配乐";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"从电脑下载" style:0 target:self action:@selector(wifi:)];
}
- (IBAction)wifi:(id)sender {
    
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    documentsPath = [documentsPath stringByAppendingPathComponent:@"addMusic"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentsPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:documentsPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    

    //开始服务器
    _webServer = [[GCDWebUploader alloc] initWithUploadDirectory:documentsPath];
    _webServer.delegate = self;
    _webServer.allowHiddenItems = YES;
    if ([_webServer start]) {
        NSLog(@"服务器启动");
    } else {
        NSLog(@"启动失败");
    }
    
    
 
    
    //获取IP
    NSString *ip = [_webServer.serverURL absoluteString];
    NSLog(@"%@",ip);

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSMutableArray *)fileNameAray {
    
    NSMutableArray *tempArray = [NSMutableArray array];
    
    NSString *fromPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    fromPath = [fromPath stringByAppendingPathComponent:@"addMusic"];
    NSArray *subpaths =  [[NSFileManager defaultManager] subpathsAtPath:fromPath];
    
    for (NSString *file in subpaths) {
        NSString *lastName = [file lastPathComponent];
        //if ([lastName containsString:@".mp3"]) {
            [tempArray addObject:[fromPath stringByAppendingPathComponent:file]];
        //}
    }
    _fileNameAray = tempArray;
    
    return _fileNameAray;
}
//根据视频的URL地址,获取音频的时长
- (long long)durationWithVideo:(NSURL *)videoUrl{
    
    NSDictionary *opts = [NSDictionary dictionaryWithObject:@(NO) forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:videoUrl options:opts]; // 初始化视频媒体文件
    long long second = 0;
    second = urlAsset.duration.value / urlAsset.duration.timescale; // 获取视频总时长,单位秒
    return second;
}
#pragma -mark 数据源代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.fileNameAray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"fileMusicCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    NSString *filePath = self.fileNameAray[indexPath.row];
    cell.textLabel.text = filePath.lastPathComponent;
    
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"已下载音乐";
}

- (void)webUploader:(GCDWebUploader*)uploader didUploadFileAtPath:(NSString*)path {
    NSLog(@"[UPLOAD] %@", path);
    [self.tableView reloadData];
}

- (void)webUploader:(GCDWebUploader*)uploader didMoveItemFromPath:(NSString*)fromPath toPath:(NSString*)toPath {
    NSLog(@"[MOVE] %@ -> %@", fromPath, toPath);
    [self.tableView reloadData];
}

- (void)webUploader:(GCDWebUploader*)uploader didDeleteItemAtPath:(NSString*)path {
    NSLog(@"[DELETE] %@", path);
    [self.tableView reloadData];
}

- (void)webUploader:(GCDWebUploader*)uploader didCreateDirectoryAtPath:(NSString*)path {
    NSLog(@"[CREATE] %@", path);
    [self.tableView reloadData];
}



@end

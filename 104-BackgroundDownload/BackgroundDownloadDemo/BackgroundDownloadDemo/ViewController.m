//
//  ViewController.m
//  BackgroundDownloadDemo
//
//  Created by HK on 16/9/10.
//  Copyright © 2016年 hkhust. All rights reserved.
//

#import "ViewController.h"
#import "TTDownloader.h"
#import <objc/runtime.h>

#import "TTT.h"

#import "NSObject+DB.h"


@interface ViewController ()

@property (strong, nonatomic) IBOutlet UIProgressView *downloadProgress;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *p2;

@end

@implementation ViewController
- (IBAction)p2:(id)sender {
    
    [TTDownloader.defaultDownloader beginDownload:@"http://sbslive.cnrmobile.com/storage/storage2/51/34/18/3e59db9bb51802c2ef7034793296b724.3gp" fileName:@"jlzg022677" progress:^(CGFloat progress,NSString *url) {
        self.p2.progress = progress;
    } speed:^(NSString *speed, NSString *url) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDownloadProgress:) name:kDownloadProgressNotification object:nil];
    
//    TTT *m = [TTT objectWithKeyValues:@{@"name":@"444",@"socre":@(99),@"age":@(88)}];
    
    TTT *ttt = [TTT new];
    ttt.name = @"ffff";
    ttt.socre = 9.9;
    ttt.info = @{@"name":@"gg",@"title":@"hh"};
    
    TT *tt1 = [TT new];
    tt1.title = @"kk11";
    tt1.age = 6;
    tt1.dict = @{@"name":@"gg",@"title":@"hh"};
    
    T *t = [T new];
    t.title = @"tttt";
    t.age = 66;
    t.dict = @{@"name":@"gg",@"title":@"hh"};
    
    TT *tt2 = [TT new];
    tt2.title = @"kk22";
    tt2.age = 6;
    tt2.model = t;
    
    ttt.models= @[tt1,tt2];
    ttt.strings = @[@"44",@"66"].mutableCopy;
    ttt.info1 = @{@"name":@"gg",@"title":@"hh"}.mutableCopy;
    
    TT *tt3 = [TT new];
    tt3.title = @"kk22";
    tt3.age = 44;
    tt3.dict = @{@"name":@"gg",@"title":@"hh"};

    ttt.model = tt2;

//    NSDictionary *obj = [self getObjectData:ttt];
//    [TT insertDatas:@[tt1,tt2]];
    [ttt save];
    NSArray *tttts = [TTT findWhere:@""];
    TTT *model = tttts.lastObject;
    model.name = @"更次年777";
    [model saveOrUpdate];
    ;
}


- (NSDictionary*)getObjectData:(id)obj{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int propsCount;
    objc_property_t *props = class_copyPropertyList([obj class], &propsCount);//获得属性列表
    for(int i = 0;i < propsCount; i++){
        
        objc_property_t prop = props[i];
        NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];//获得属性的名称
        id value = [obj valueForKey:propName];//kvc读值
        if(value == nil){
            value = [NSNull null];
        }
        else{
            value = [self getObjectInternal:value];//自定义处理数组，字典，其他类
        }
        [dic setObject:value forKey:propName];
    }
    return dic;
}

- (id)getObjectInternal:(id)obj{
    
    if([obj isKindOfClass:[NSString class]]
       || [obj isKindOfClass:[NSNumber class]]
       || [obj isKindOfClass:[NSNull class]]){
    
        return obj;
    }

    if([obj isKindOfClass:[NSArray class]]){
        
        NSArray *objarr = obj;
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:objarr.count];
        for(int i = 0;i < objarr.count; i++){
            
            [arr setObject:[self getObjectInternal:[objarr objectAtIndex:i]] atIndexedSubscript:i];
        }

        return arr;
    }
    
    if([obj isKindOfClass:[NSDictionary class]]){
        
        NSDictionary *objdic = obj;
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:[objdic count]];
        for(NSString *key in objdic.allKeys){
            
            [dic setObject:[self getObjectInternal:[objdic objectForKey:key]] forKey:key];
            
        }
        return dic;
    }
    
    return [self getObjectData:obj];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateDownloadProgress:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    CGFloat fProgress = [userInfo[@"progress"] floatValue];
    self.progressLabel.text = [NSString stringWithFormat:@"%.2f%%",fProgress * 100];
    self.downloadProgress.progress = fProgress;
}

#pragma mark Method
- (IBAction)download:(id)sender {
//    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [TTDownloader.defaultDownloader beginDownload:@"http://jlzg.cnrmobile.com/resource/index/sp/jlzg0226.mp4" fileName:@"jlzg0226" progress:^(CGFloat progress,NSString *url) {
        NSLog(@"%s---%f", __func__,progress);
    } speed:^(NSString *speed, NSString *url) {
        
    }];
}

- (IBAction)pauseDownlaod:(id)sender {
//    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [TTDownloader.defaultDownloader pauseDownload:@"http://jlzg.cnrmobile.com/resource/index/sp/jlzg0226.mp4"];
}

- (IBAction)continueDownlaod:(id)sender {
//    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [TTDownloader.defaultDownloader continueDownload:@"http://jlzg.cnrmobile.com/resource/index/sp/jlzg0226.mp4"];
}

@end

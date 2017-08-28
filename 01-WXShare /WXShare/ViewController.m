//
//  ViewController.m
//  WXShare
//
//  Created by pkss on 2017/5/19.
//  Copyright © 2017年 J. All rights reserved.
//

#import "ViewController.h"
#import <WXApi.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self sendLinkURL];
}

- (BOOL)sendTextContent {
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = YES;
    req.scene = WXSceneSession;
    req.text = @"acbbb";

    return [WXApi sendReq:req];
}

- (BOOL)sendLinkURL{
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = @"http://ishare.bthost.top";
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"title";
    message.description = @"description";
    message.mediaObject = ext;
    message.messageExt = nil;
    message.messageAction = nil;
    message.mediaTagName = @"tagName";
    [message setThumbImage:[UIImage imageNamed:@"res7"]];
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.scene = WXSceneSession;
    req.message = message;
    

    return [WXApi sendReq:req];
}



@end

//
//  HJManger.m
//  HJManger
//
//  Created by xin on 2018/7/2.
//  Copyright © 2018年 sdl. All rights reserved.
//

#import "RiJuTV.h"
//#import "TJData.h"


@implementation RiJuTV

+ (void)tvlist{
//    view-source:http://m.91kds.cn/
    
    NSURL * url = [NSURL URLWithString:@"http://m.91kds.cn/"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setTimeoutInterval:10.0];
    [request setValue:self.userAgent forHTTPHeaderField:@"User-Agent"];


    NSURLSession * session = [NSURLSession sharedSession];
    NSURLSessionDataTask * task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSString *searchText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSString *rString = @"<li><a href=\".*?\" data-ajax=\".*?\">.*?</a></li>";
        
        NSArray *rs = [self matchString:searchText toRegexString:rString];
        rString = @"<li><a href=\"(.*?)\" data-ajax=\".*?\">(.*?)</a></li>";
        
        NSMutableArray *list = [NSMutableArray array];
        
        [rs enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSArray * array = [self matchString:obj toRegexString:rString];
            NSString *url =  [NSString stringWithFormat:@"http://m.91kds.cn/%@",array[1]];
            NSString *name = array[2];
            
            
            NSString *json = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:NULL];
            NSString *lString = @"<li><a href=\".*?\" data-ajax=\".*?\">.*?</a></li>";
            NSArray *ls = [self matchString:json toRegexString:lString];
            lString = @"<li><a href=\"(.*?)\" data-ajax=\".*?\">(.*?)</a></li>";
           
            NSMutableArray *data = [NSMutableArray array];

            [ls enumerateObjectsUsingBlock:^(NSString * lobj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSArray * array = [self matchString:lobj toRegexString:lString];
                NSString *url =  [NSString stringWithFormat:@"http://m.91kds.cn/%@",array[1]];
                NSString *name = array[2];
                NSLog(@"%s", __func__);
                [data addObject:@{@"url":url,@"name":name}];
            }];
            
            [list addObject:@{@"url":url,@"name":name,@"list":data}];
        }];

        NSLog(@"%s", __func__);
    }];
    //开启网络任务
    [task resume];
}

+ (void)searchRiJu:(NSString *)kw
          pageNo:(NSInteger)page
         completed: (void(^)(NSArray <NSDictionary *>*objs,BOOL))block{
    
    if (self.isProtocolService){
        !(block)? : block(@[],NO);
        return;
    }
    page = page? page : 1;
    NSString* encodedString = [[NSString stringWithFormat:@"https://www.rijutv.com/index.php?c=so&module=&keyword=%@",kw] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    if (page>1) {
        encodedString = [[NSString stringWithFormat:@"https://www.rijutv.com/index.php?c=so&keyword=%@&page=%ld",kw,(long)page] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    NSURL * url = [NSURL URLWithString:encodedString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setTimeoutInterval:10.0];
    [request setValue:self.userAgent forHTTPHeaderField:@"User-Agent"];
    [request setValue:@"http://www.97taiju.com" forHTTPHeaderField:@"Origin"];
    //request.HTTPMethod = @"POST";
    
    //NSData *paramData = [[NSString stringWithFormat:@"keyword=%@",kw] dataUsingEncoding:NSUTF8StringEncoding];
    //request.HTTPBody = paramData;
    NSURLSession * session = [NSURLSession sharedSession];
    NSURLSessionDataTask * task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSString *searchText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if (!searchText || searchText.length < 5) {
//            NSArray *array = [TJData hanjuArray];
//
//            //模糊查询
//            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title CONTAINS %@", kw]; //
//            NSArray <NSDictionary *>*results = [array filteredArrayUsingPredicate:predicate];
//            if(page != 1 || !([TJNetwork defaultNetwork].isReachable)) results = @[];
            dispatch_async(dispatch_get_main_queue(), ^{
                !(block)? : block(@[],NO);
            });
            return;
        }
        

        
        NSString *rString = @"<div class=\"searchItem\">[\\w\\W]*?</h3>";
        
        NSArray *rs = [self matchString:searchText toRegexString:rString];
//        NSLog(@"%s", __func__);
//        NSString *rS = @"<dt><a href=\"(.*?)\" target=\"_blank\" title=\"(.*?)\"><img src=\"(.*?)\" onerror=\".*?\" alt=\".*?\"/></a></dt>";
//        
//        NSString *pString = @".*?&nbsp;当前:.*?/(.*?)页&nbsp;";
//        NSArray *ps = [self matchString:searchText toRegexString:pString];
//        NSInteger totalPage = [ps.lastObject integerValue];
        
        
        NSMutableArray *temps = [NSMutableArray array];
        
        for (NSString *r in rs) {
            
            
            NSString *url = [self matchString:r toRegexString:@"<a href=\"(.*?)\">"].lastObject;
            url = [NSString stringWithFormat:@"https://www.rijutv.com%@",url];

            NSString *title = [self matchString:r toRegexString:@"<h3 class=\"title\">(.*?)</h3>"].lastObject;

            NSString *imgRe = @"<img .*? src=\"(.*?)\" .*?>";
            NSString *img = [self matchString:r toRegexString:imgRe].lastObject;

            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"img"] = img;
            dict[@"url"] = url;
            dict[@"title"] = [self flattenHTML:title];
            

            [temps addObject:dict];
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            !(block)? : block(temps,temps.count<10);
        });
        
        
    }];
    //开启网络任务
    [task resume];
    
}


+ (void)riJuHls:(NSString *)urlStr
        completed: (void(^)(NSString *obj))block{
    
    
    if ([self isProtocolService]) {
        !(block)? : block(@"");
        return;
    }
    
    NSURL * url = [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setTimeoutInterval:10.0];
    
    [request setValue:self.userAgent forHTTPHeaderField:@"User-Agent"];
    
    NSURLSession * session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask * task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //        NSStringEncoding gb2312 = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        
        NSString *searchText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if (!searchText) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                !(block)? : block(@"");
            });
            
            return;
        }
        
        NSString *oneRe = @"url:'(.*?)',";
        NSString *hls = [self matchString:searchText toRegexString:oneRe].lastObject;
        dispatch_async(dispatch_get_main_queue(), ^{
            !(block)? : block(hls);
        });
        
    }];
    //开启网络任务
    [task resume];
}




+ (void)riJuPlayList:(NSString *)urlStr
            completed: (void(^)(NSArray *objs))block{

    
    if ([self isProtocolService]) {
        !(block)? : block(@[]);
        return;
    }
    
    NSURL * url = [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setTimeoutInterval:10.0];

    [request setValue:self.userAgent forHTTPHeaderField:@"User-Agent"];
    
    NSURLSession * session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask * task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        NSStringEncoding gb2312 = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        
        NSString *searchText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if (!searchText) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                !(block)? : block(@[]);
            });
            
            return;
        }
        
        NSString *oneRe = @"<iframe id=\".*?\" width=\".*?\" height=\".*?\" src=\"(.*?)\" frameborder=\".*?\" allowfullscreen=\".*?\" scrolling=\".*?\"></iframe>";
        NSString *oneStr = [self matchString:searchText toRegexString:oneRe].lastObject;
        oneStr = [NSString stringWithFormat:@"https:%@",oneStr];
        

        
        NSString *baseRe = @"playPath\"\\)\\.attr\\('src','(.*?)'\\+path\\)";
        NSString *baseStr = [self matchString:searchText toRegexString:baseRe].lastObject;
        baseStr = [NSString stringWithFormat:@"https:%@",baseStr];

        
        NSString *hlsRe = @"\\('.*?','.*?'\\)\">.*?</li>";
        NSArray *hlss = [self matchString:searchText toRegexString:hlsRe];
        hlsRe = @"\\('(.*?)','.*?'\\)\">(.*?)</li>";

        NSMutableArray *hls = [NSMutableArray array];
        [hls addObject:@{@"url":oneStr,@"title":@"默认"}];
        for (NSString *h in hlss) {
            
            NSArray *d = [self matchString:h toRegexString:hlsRe];
            if (d.count < 3) {
                continue;
            }
            NSString *url = [NSString stringWithFormat:@"%@%@",baseStr,d[1]];
            NSString *title = d[2];
            [hls addObject:@{@"url":url,@"title":title}];

        }
        
//        NSString *url = [NSString stringWithFormat:@"http://m.yueyuwz.com%@", dataStr];
//
//        NSString *m3u8 = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:gb2312 error:NULL];
//        m3u8 = [self replaceUnicode:m3u8];
//
//        NSString *hlsRegex = [NSString stringWithFormat:@"%@\\$.*?\\$",title];
//        NSArray *hls = [self matchString:m3u8 toRegexString:hlsRegex];
//        NSString *hlssRegex = @"\\$(.*?)\\$";
//
//        NSMutableArray *temp = [NSMutableArray array];
//        for (NSString *string in hls) {
//            NSString *hlsString = [self matchString:string toRegexString:hlssRegex].lastObject;
//            [temp addObject:hlsString];
//        }
//
//        NSArray *lists = [temp sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
//
//            BOOL b1 = [obj1 containsString:@"m3u8"];
//            BOOL b2 = [obj2 containsString:@"m3u8"];
//
//            return b1 < b2;
//        }];
//
//        NSMutableArray *live_streams = [NSMutableArray array];
//        [lists enumerateObjectsUsingBlock:^(NSString *   obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            [live_streams addObject:@{@"name":title,@"live_stream":obj}];
//        }];
//
        dispatch_async(dispatch_get_main_queue(), ^{
            !(block)? : block(hls);
        });
        
    }];
    //开启网络任务
    [task resume];
}



+ (void)riJuDetail:(NSString *)urlStr
           completed: (void(^)(NSDictionary *obj))block{
    
    if (self.isProtocolService) {
        !(block)? : block(@{});
        return;
    }
    
    NSURL * url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:self.userAgent forHTTPHeaderField:@"User-Agent"];
    [request setTimeoutInterval:10.0];

    NSURLSession * session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask * task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        //NSStringEncoding enc =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString *searchText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        if (searchText.length==0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                !(block)? : block(@{});
                
            });
            return;
        }
        NSString *iconRegex = @"<img src=\"(.*?)\" alt=\".*?\">";
        NSString *icon = [self matchString:searchText toRegexString:iconRegex].lastObject;
        
        NSString *nameRegex = @"<h1 class=\".*?\">(.*?)</h1>";
        NSString *name = [self matchString:searchText toRegexString:nameRegex].lastObject;
        
        NSString *mainShow = @"<li>主演：([\\w\\W]*?)</li>";
        NSString *main = [self matchString:searchText toRegexString:mainShow].lastObject;
        
        NSString *statusRegex = @"<li>.*?集.*?</li>";
        NSString *status = [self matchString:searchText toRegexString:statusRegex].lastObject;
        status = [self flattenHTML:status];
        
        NSString *typeRegex = @"<DD class=left>类型：<a href=\".*?\">(.*?)</a></DD>";
        NSString *type = [self matchString:searchText toRegexString:typeRegex].lastObject;
        
        NSString *yearRegex = @"<li>年代：(.*?)</li>";
        NSString *year = [self matchString:searchText toRegexString:yearRegex].lastObject;
        
        //NSString *languageRegex = @"<DD class=left>语言：<span class=\".*?\">(.*?)</span></DD>";
        NSString *language = @"日语";//[self matchString:searchText toRegexString:languageRegex].lastObject;
        
        NSString *desRegex = @"<meta name=\"description\" content=\"(.*?)\">";
        NSString *des = [self matchString:searchText toRegexString:desRegex].lastObject;
        des = [self flattenHTML:des];
        des = [des stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        NSString *hlsRegex = @"<li><a href=\".*?\">.*?</a></li>";
        NSString *m3u8Regex = @"<li><a href=\"(.*?)\">(.*?)</a></li>";
        NSArray *hlss = [self matchString:searchText toRegexString:hlsRegex];
        
        NSMutableArray *m3u8s = [NSMutableArray array];
        for (NSString *hlsHtml in hlss) {
            NSArray *urls = [self matchString:hlsHtml toRegexString:m3u8Regex];
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"title"] = urls[2];
            dict[@"url"] = [NSString stringWithFormat:@"https://www.rijutv.com%@", urls[1]];
            [m3u8s addObject:dict];
        }
        
        NSDictionary *obj = @{
                              @"img":icon.length?icon : @"",
                              @"title":name.length?name : @"未知",
                              @"status":status.length? status : @"未知",
                              @"type":type.length?type : @"未知",
                              @"year":year.length?year : @"未知",
                              @"des":des.length? des : @"暂无介绍",
                              @"vlist":m3u8s.count? m3u8s : @[],
                              @"main" : main.length? main:@"未知",
                              @"url":urlStr,
                              @"language" : language.length?language:@"未知"
                              };
        dispatch_async(dispatch_get_main_queue(), ^{
            !(block)? : block(obj);
        });
    }];
    //开启网络任务
    [task resume];
}


+ (NSArray *)getRanArray:(NSArray *)array{
    
    
    
    NSMutableArray *shuffleArray = array.mutableCopy;
    for (int i =0; i < shuffleArray.count; i++) {
        
        int n = (arc4random() % (shuffleArray.count - i)) + i;
        
        [shuffleArray exchangeObjectAtIndex:i withObjectAtIndex:n];
        
    }
    
    return [shuffleArray subarrayWithRange:NSMakeRange(0,shuffleArray.count-1)];
}

//FIXME:  -  泰剧列表
+ (void)riJuList:(NSInteger)page
                 completed: (void(^)(NSArray <NSDictionary *>*objs))block{

    
    if (self.isProtocolService) {
        !(block)? : block(@[]);
        return;
    }
    
    NSString *str =  @"https://www.rijutv.com/v_all/list-catid-7.html";
    if (page > 1) {
        str = [NSString stringWithFormat:@"https://www.rijutv.com/v_all/list-catid-7-page-%ld.html",(long)page];
    }
    
    NSURL * url = [NSURL URLWithString:str];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setTimeoutInterval:10.0];

    [request setValue:self.userAgent forHTTPHeaderField:@"User-Agent"];
    
    NSURLSession * session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask * task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        //NSStringEncoding enc =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString *searchText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        if (!searchText || searchText.length < 10) {
//            NSArray *array = [TJData hanjuArray];
//            array = [self getRanArray:array];
//            if(page != 1 || !([TJNetwork defaultNetwork].isReachable)) array = @[];
            dispatch_async(dispatch_get_main_queue(), ^{
                !(block)? : block(@[]);
            });
            return;
        }
        
        NSString *rString = @"<a class=\".*?\" href=\".*?\" target=\".*?\" title=\".*?\">[\\w\\W].*?<div class=\".*?\" data-original=\".*?\"></div>";
        
        NSArray *rs = [self matchString:searchText toRegexString:rString];
        NSLog(@"%s", __func__);
        NSString *rS = @"<a class=\".*?\" href=\"(.*?)\" target=\".*?\" title=\"(.*?)\">[\\w\\W].*?<div class=\".*?\" data-original=\"(.*?)\"></div>";

        
        NSMutableArray *temps = [NSMutableArray array];
        
    
        for (NSString *r in rs) {
            NSArray *d = [self matchString:r toRegexString:rS];
            if (d.count < 4) {
                continue;
            }
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"img"] = d[3];

            dict[@"url"] = [NSString stringWithFormat:@"https://www.rijutv.com%@",d[1]];
            dict[@"title"] = d[2];
            [temps addObject:dict];
            
        }

        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            !(block)? : block(temps);
        });
    }];
    //开启网络任务
    [task resume];
}


+ (BOOL)isProtocolService{
    
#ifdef DEBUG
    return NO;
#else
    NSDictionary *proxySettings = (__bridge NSDictionary *)(CFNetworkCopySystemProxySettings());
    NSArray *proxies = (__bridge NSArray *)(CFNetworkCopyProxiesForURL((__bridge CFURLRef _Nonnull)([NSURL URLWithString:@"http://www.baidu.com"]), (__bridge CFDictionaryRef _Nonnull)(proxySettings)));
    //NSLog(@"\n%@",proxies);
    
    NSDictionary *settings = proxies[0];
    //NSLog(@"%@",[settings objectForKey:(NSString *)kCFProxyHostNameKey]);
    //NSLog(@"%@",[settings objectForKey:(NSString *)kCFProxyPortNumberKey]);
    //NSLog(@"%@",[settings objectForKey:(NSString *)kCFProxyTypeKey]);
    
    if ([[settings objectForKey:(NSString *)kCFProxyTypeKey] isEqualToString:@"kCFProxyTypeNone"])
    {
        //NSLog(@"没代理");
        return NO;
    }
    else
    {
        NSLog(@"设置了代理");
        return YES;
    }
#endif

}

+ (NSString *)userAgent{
    
    
    NSArray *userAgents = @[
                            @"Mozilla/5.0 (Linux; Android 4.4.4; HTC D820u Build/KTU84P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/40.0.2214.89 Mobile Safari/537.36",
                            @"Mozilla/5.0 (Linux; U; Android 4.4.4; zh-cn; HTC_D820u Build/KTU84P) AppleWebKit/534.30 (KHTML, like Gecko) Version/4.0 Mobile Safari/534.30",
                            @"Mozilla/5.0 (Linux; Android 4.4.4; HTC D820u Build/KTU84P) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/33.0.0.0 Mobile Safari/537.36 ACHEETAHI/2100501044",
                            @"Mozilla/5.0 (Linux; Android 4.4.4; HTC D820u Build/KTU84P) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/33.0.0.0 Mobile Safari/537.36 bdbrowser_i18n/4.6.0.7",
                            @"Mozilla/5.0 (Linux; U; Android 4.4.4; zh-CN; HTC D820u Build/KTU84P) AppleWebKit/534.30 (KHTML, like Gecko) Version/4.0 UCBrowser/10.1.0.527 U3/0.8.0 Mobile Safari/534.30",
                            @"Mozilla/5.0 (Android; Mobile; rv:35.0) Gecko/35.0 Firefox/35.0",
                            @"Mozilla/5.0 (Linux; U; Android 4.4.4; zh-cn; HTC D820u Build/KTU84P) AppleWebKit/534.30 (KHTML, like Gecko) Version/4.0 Mobile Safari/534.30 SogouMSE,SogouMobileBrowser/3.5.1",
                            @"Mozilla/5.0 (Linux; U; Android 4.4.4; zh-CN; HTC D820u Build/KTU84P) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Oupeng/10.2.3.88150 Mobile Safari/537.36",
                            @"Mozilla/5.0 (Linux; U; Android 4.4.4; zh-cn; HTC D820u Build/KTU84P) AppleWebKit/537.36 (KHTML, like Gecko)Version/4.0 MQQBrowser/5.6 Mobile Safari/537.36",
                            @"Mozilla/5.0 (Linux; U; Android 4.4.4; zh-cn; HTC D820u Build/KTU84P) AppleWebKit/534.24 (KHTML, like Gecko) Version/4.0 Mobile Safari/534.24 T5/2.0 baidubrowser/5.3.4.0 (Baidu; P1 4.4.4)",
                            @"Mozilla/5.0 (Linux; U; Android 4.4.4; zh-cn; HTC D820u Build/KTU84P) AppleWebKit/535.19 (KHTML, like Gecko) Version/4.0 LieBaoFast/2.28.1 Mobile Safari/535.19",
                            @"Mozilla/5.0 (iPhone; CPU iPhone OS 8_0 like Mac OS X) AppleWebKit/600.1.4 (KHTML, like Gecko) Version/8.0 Mobile/12A365 Safari/600.1.4",
                            @"Mozilla/5.0 (iPhone; CPU iPhone OS 8_0 like Mac OS X; zh-CN) AppleWebKit/537.51.1 (KHTML, like Gecko) Mobile/12A365 UCBrowser/10.2.5.551 Mobile",
                            @"Mozilla/5.0 (iPhone 5SGLOBAL; CPU iPhone OS 8_0 like Mac OS X) AppleWebKit/600.1.4 (KHTML, like Gecko) Version/6.0 MQQBrowser/5.6 Mobile/12A365 Safari/8536.25",
                            @"Mozilla/5.0 (iPhone; CPU iPhone OS 8_0 like Mac OS X) AppleWebKit/600.1.4 (KHTML, like Gecko) Version/7.0 Mobile/12A365 Safari/9537.53",
                            @"Mozilla/5.0 (iPhone; CPU iPhone OS 8_0 like Mac OS X) AppleWebKit/600.1.4.9 (KHTML, like Gecko) Version/6.0 Mobile/10A523 Safari/8536.25",
                            @"Mozilla/5.0 (iPhone; CPU iPhone OS 7_0_4 like Mac OS X) AppleWebKit/537.51.1 (KHTML, like Gecko) Mercury/8.9.4 Mobile/11B554a Safari/9537.53",
                            @"Mozilla/5.0 (iPhone; CPU iPhone OS 8_0 like Mac OS X) AppleWebKit/600.1.4 (KHTML, like Gecko) Mobile/12A365 SogouMobileBrowser/3.5.1",
                            @"Mozilla/5.0 (iPhone; CPU iPhone OS 7_1 like Mac OS X) AppleWebKit/537.51.2 (KHTML, like Gecko) Version/7.0 Mobile/11D167 Safari/9537.53",
                            @"Mozilla/5.0 (iPhone; CPU iPhone OS 8_0 like Mac OS X) AppleWebKit/600.1.4 (KHTML, like Gecko) Coast/4.01.88243 Mobile/12A365 Safari/7534.48.3",
                            @"Mozilla/5.0 (iPhone; CPU iPhone OS 8_0 like Mac OS X) AppleWebKit/600.1.4 (KHTML, like Gecko) CriOS/40.0.2214.69 Mobile/12A365 Safari/600.1.4",
                            @"Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_2 like Mac OS X) AppleWebKit/603.2.4 (KHTML, like Gecko) Version/10.0 Mobile/14F89 Safari/602.1",
                            @"Mozilla/5.0 (iPhone; CPU iPhone OS 11_1_1 like Mac OS X) AppleWebKit/603.2.4 (KHTML, like Gecko) Version/10.0 Mobile/15F89 Safari/602.1",
                            ];
    
    NSInteger index = arc4random() % userAgents.count;
    return  userAgents[index];
}


+ (NSArray *)matchString:(NSString *)string toRegexString:(NSString *)regexStr
{
    
    if(!string) return @[];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSArray * matches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSTextCheckingResult *match in matches) {
        
        for (int i = 0; i < [match numberOfRanges]; i++) {
            //以正则中的(),划分成不同的匹配部分
            NSString *component = [string substringWithRange:[match rangeAtIndex:i]];
            
            [array addObject:component];
            
        }
        
    }
    
    return array;
}

+(NSString *)flattenHTML:(NSString *)html {
    
    if(!html) return @"";
    NSScanner *theScanner;
    NSString *text = nil;
    theScanner = [NSScanner scannerWithString:html];
    while ([theScanner isAtEnd] == NO) {
        
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        
        [theScanner scanUpToString:@">" intoString:&text] ;
        
        html=[html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text] withString:@""];
    }
    return html;
}

+ (void)getJianShuObj:(NSString *)urlStr
           completed: (void(^)(id obj))block{
    
    
    if ([self isProtocolService]) {
        !(block)? : block(nil);
        return;
    }
    
    NSURL * url = [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setTimeoutInterval:10.0];
    
    [request setValue:self.userAgent forHTTPHeaderField:@"User-Agent"];
    
    NSURLSession * session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask * task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSString *searchText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if (!searchText) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                !(block)? : block(nil);
            });
            return;
        }
        NSString *json = [self matchString:searchText toRegexString:@"####(.*?)####"].lastObject;
 
        dispatch_async(dispatch_get_main_queue(), ^{
            !(block)? : block(json);
        });
        
    }];
    //开启网络任务
    [task resume];
}



@end

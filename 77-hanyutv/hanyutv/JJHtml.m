
#import "JJHtml.h"
//#import "JJHttp.h"

@implementation JJHtml

//FIXME:  -  韩剧详情
+ (void)getHanYuTVDetail:(NSString *)urlStr
            completeBlock: (void(^)(NSDictionary *))block{
    //https://m.y3600.com/411/index.html
    if (self.isProtocolService) {
            !(block)? : block(@{});
            return;
        }
    
    NSURL * url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:self.userAgent forHTTPHeaderField:@"User-Agent"];
    
    NSURLSession * session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask * task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSString *searchText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if (!searchText) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                !(block)? : block(@{});
            });
            
            return;
        }

        NSString *iconRegex = @"<p><img src=\"(.*?)\" alt=\".*?\" /></p>";
        NSString *icon = [self matchString:searchText toRegexString:iconRegex].lastObject;
        icon = [icon containsString:@"http"]?icon:[NSString stringWithFormat:@"https:%@",icon];

        
        NSString *nameRegex = @"<div class=\"ui-content\"><h1>(.*?)</h1>";
        NSString *name = [self matchString:searchText toRegexString:nameRegex].lastObject;
        
//        NSString *mainShow = @"<p>【主要演员.*?</p>";
//        mainShow = @"<p>【主要演员】(.*?)</p>";
//        NSString *mainStr = [self matchString:searchText toRegexString:mainShow].lastObject;
//
//        NSString *mainRegex = @"class=infotextkey>(.*?)</a>";
//        NSArray *mainContents = [self matchString:mainStr toRegexString:mainRegex];
        

//        NSMutableString *main = [NSMutableString string];
//        for (NSInteger i = 1;i < mainContents.count; i+=2) {
//            [main appendString:@"/"];
//            [main appendString:mainContents[i]];
//        }
//        main = [main substringFromIndex:1];
        
        NSString *statusRegex = @"<p>【集 数】(.*?)</p>";
        NSString *status = [self matchString:searchText toRegexString:statusRegex].lastObject;
        
        NSString *typeRegex = @"<p>类型：(.*?)</p>";
        NSString *type = [self matchString:searchText toRegexString:typeRegex].lastObject;
        
        NSString *yearRegex = @"<p>【首播时间】(.*?)</p>";
        NSString *year = [self matchString:searchText toRegexString:yearRegex].lastObject;
        
        NSString *languageRegex = @"<div>语言：(.*?)</div>";
        NSString *language = [self matchString:searchText toRegexString:languageRegex].lastObject;
        
        NSString *desRegex = @"<p>【剧情简介】(.*?)</p>";
        NSString *des = [self matchString:searchText toRegexString:desRegex].lastObject;
        des = [self filterHtmlTag:des];
        
        NSString *hlsRegex = @"<li><a href=\"#play\" onclick=\"ck_m3u8.*?\'.*?\'.*?\" title=\".*?\">.*?</a></li>";
        NSString *m3u8Regex = @"<li><a href=\"#play\" onclick=\"ck_m3u8.*?\'(.*?)\'.*?\" title=\".*?\">(.*?)</a></li>";
        NSArray *hlss = [self matchString:searchText toRegexString:hlsRegex];
        
     
        NSString *hlsRegex1 = @"<li><a onclick=\"ck_m3u8.*?\'.*?\'.*?\" href=\"#play\" title=\".*?\">.*?</a></li>";
        NSString *m3u8Regex1 = @"<li><a onclick=\"ck_m3u8.*?\'(.*?)\'.*?\" href=\"#play\" title=\".*?\">(.*?)</a></li>";
        NSArray *hlss1 = [self matchString:searchText toRegexString:hlsRegex1];
        
        NSMutableArray *m3u8s = [NSMutableArray array];
        for (NSString *hlsHtml in hlss) {
            NSArray *urls = [self matchString:hlsHtml toRegexString:m3u8Regex];
            NSString *title = urls[2];
            __block  NSMutableArray * values;
            [m3u8s enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([[obj valueForKey:@"title"] isEqualToString:title]) {
                    values = obj[@"url"];
                }
            }];
            if (values) {
                [values addObject:urls[1]];
            }else{
                NSDictionary *v = @{@"title":urls[2],@"url":@[urls[1]].mutableCopy};
                [m3u8s addObject:v];
            }
        }
        for (NSString *hlsHtml in hlss1) {
            NSArray *urls = [self matchString:hlsHtml toRegexString:m3u8Regex1];
            NSString *title = urls[2];
            __block  NSMutableArray * values;
            [m3u8s enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([[obj valueForKey:@"title"] isEqualToString:title]) {
                    values = obj[@"url"];
                }
            }];
            if (values) {
                [values addObject:urls[1]];
            }else{
                NSDictionary *v = @{@"title":urls[2],@"url":@[urls[1]].mutableCopy};
                [m3u8s addObject:v];
            }
        }
        
        
        
        NSDictionary *obj = @{
                              @"img":icon.length?icon : @"",
                              @"title":name.length?name : @"未知",
                              @"status":status.length? status : @"未知",
                              @"type":type.length?type : @"未知",
                              @"year":year.length?year : @"未知",
                              @"des":des.length? des : @"暂无介绍",
                              @"vlist":m3u8s.count? m3u8s : @[],
                              //@"main" : main.length? main:@"未知",
                              @"language" : language.length?language:@"未知"
                              };
        dispatch_async(dispatch_get_main_queue(), ^{
            !(block)? : block(obj);
        });
    }];
    //开启网络任务
    [task resume];
}

//FIXME:  -  韩剧列表
+ (void)getHanYuTVPage:(NSInteger)page
                 block: (void(^)(NSArray <NSDictionary *>*))block{
    
    
    if (self.isProtocolService) {
            !(block)? : block(@[]);
            return;
        }
    
    NSString *str =  @"https://m.y3600.com/hanju/index.html";
    if (page > 1) {
        str = [NSString stringWithFormat:@"https://m.y3600.com/hanju/index_%ld.html",(long)page];
    }    
    
    NSURL * url = [NSURL URLWithString:str];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setValue:self.userAgent forHTTPHeaderField:@"User-Agent"];
    
    NSURLSession * session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask * task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSString *searchText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if (!searchText) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                !(block)? : block(@[]);
            });
            
            return;
        }
        
        NSString *rString = @"<li>.*?</p></a></li>";
        NSArray *rs = [self matchString:searchText toRegexString:rString];
        
        NSLog(@"%s", __func__);
        NSString *rS = @"<li><a href=\"(.*?)\" title=\".*?\"><article><img src=\"(.*?)\" alt=\".*?\" /><span>(.*?)</span>.*?</article><h3>(.*?)</h3><p>.*?</p></a></li>";
        
        
        NSMutableArray *temps = [NSMutableArray array];
        
        for (NSString *r in rs) {
            NSArray *d = [self matchString:r toRegexString:rS];
            if (d.count < 5) {
                continue;
            }
            NSLog(@"%s--%@", __func__,d);
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"img"] = [(NSString*)d[2] containsString:@"http"]?d[2]:[NSString stringWithFormat:@"https:%@",d[2]];
            dict[@"live_stream"] = [NSString stringWithFormat:@"https://m.y3600.com%@", d[1]];
            dict[@"title"] = [self flattenHTML:d[4]];
            dict[@"status"] = d[3];
            [temps addObject:dict];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            !(block)? : block(temps);
        });
    }];
    //开启网络任务
    [task resume];
}
//////

+ (void)search:(NSString *)kw
          page:(NSInteger)page
         block: (void(^)(NSArray <NSDictionary *>*,BOOL))block{
    
    //www.yywssone.com
    
    
    if (self.isProtocolService){
        !(block)? : block(@[],NO);
        return;
    }
    
    if(page == 1){
        kw = [self URLEncodedString:kw];
        NSURL * url = [NSURL URLWithString:@"http://m.yueyuwz.com/search.asp"];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setValue:self.userAgent forHTTPHeaderField:@"User-Agent"];
        [request setValue:@"http://m.yueyuwz.com" forHTTPHeaderField:@"Origin"];
        request.HTTPMethod = @"POST";
        
        NSData *paramData = [[NSString stringWithFormat:@"searchword=%@",kw] dataUsingEncoding:NSUTF8StringEncoding];
        request.HTTPBody = paramData;
        NSURLSession * session = [NSURLSession sharedSession];
        NSURLSessionDataTask * task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSStringEncoding gb2312 = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            
            NSString *searchText = [[NSString alloc] initWithData:data encoding:gb2312];
            if (!searchText) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    !(block)? : block(@[],NO);
                });
                
                return;
            }
            
            NSString *rString = @"<li><a href=\".*?\" title=\".*?\" class=\"apic\"><img src=\".*?\" alt=\".*?\" /></a><p><a href=\".*?\">.*?</a></p></li>";
            
            NSArray *rs = [self matchString:searchText toRegexString:rString];
            NSLog(@"%s", __func__);
            NSString *rS = @"<li><a href=\".*?\" title=\".*?\" class=\"apic\"><img src=\"(.*?)\" alt=\".*?\" /></a><p><a href=\"(.*?)\">(.*?)</a></p></li>";
            
            NSMutableArray *temps = [NSMutableArray array];
            
            for (NSString *r in rs) {
                NSArray *d = [self matchString:r toRegexString:rS];
                if (d.count < 4) {
                    continue;
                }
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                dict[@"img"] = [(NSString*)d[1] containsString:@"nopic.gif"]?@"":d[1];
                dict[@"live_stream"] = [NSString stringWithFormat:@"http://m.yueyuwz.com%@", d[2]];
                dict[@"title"] = d[3];
                [temps addObject:dict];
            }
            
            NSArray *nexts = [self matchString:searchText toRegexString:@"&searchtype=-1\" class=\"next\">下一页</a>"];
            dispatch_async(dispatch_get_main_queue(), ^{
                !(block)? : block(temps,[nexts count]);
            });
            
            NSLog(@"%s--%@", __func__,temps);
            
        }];
        //开启网络任务
        [task resume];
    }else{
        
        kw = [self URLEncodedString:kw];
        NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"http://m.yueyuwz.com/search.asp?page=%ld&searchword=%@&searchtype=-1",(long)page,kw]];
        //创建请求
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        [request setValue:self.userAgent forHTTPHeaderField:@"User-Agent"];
        [request setValue:@"http://m.yueyuwz.com" forHTTPHeaderField:@"Origin"];
        
        NSURLSession * session = [NSURLSession sharedSession];
        
        NSURLSessionDataTask * task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSStringEncoding gb2312 = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            
            NSString *searchText = [[NSString alloc] initWithData:data encoding:gb2312];
            if (!searchText) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    !(block)? : block(@[],NO);
                });
                
                return;
            }
            
            NSString *rString = @"<li><a href=\".*?\" title=\".*?\" class=\"apic\"><img src=\".*?\" alt=\".*?\" /></a><p><a href=\".*?\">.*?</a></p></li>";
            
            NSArray *rs = [self matchString:searchText toRegexString:rString];
            NSLog(@"%s", __func__);
            NSString *rS = @"<li><a href=\".*?\" title=\".*?\" class=\"apic\"><img src=\"(.*?)\" alt=\".*?\" /></a><p><a href=\"(.*?)\">(.*?)</a></p></li>";
            
            
            NSMutableArray *temps = [NSMutableArray array];
            
            for (NSString *r in rs) {
                NSArray *d = [self matchString:r toRegexString:rS];
                if (d.count < 4) {
                    continue;
                }
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                dict[@"img"] = [(NSString*)d[1] containsString:@"nopic.gif"]?@"":d[1];
                dict[@"live_stream"] = [NSString stringWithFormat:@"http://m.yueyuwz.com%@", d[2]];
                dict[@"title"] = d[3];
                [temps addObject:dict];
            }
            
            NSArray *nexts = [self matchString:searchText toRegexString:@"&searchtype=-1\" class=\"next\">下一页</a>"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                !(block)? : block(temps,[nexts count]);
            });
            
            NSLog(@"%s--%@", __func__,temps);
            
        }];
        //开启网络任务
        [task resume];
    }
}

+ (void)getTVM3u8:(NSString *)urlStr block: (void(^)(NSArray *))block{
    
    
    if (self.isProtocolService) {
        !(block)? : block(@[]);
        return;
    }
    
    
    NSURL * url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setValue:self.userAgent forHTTPHeaderField:@"User-Agent"];
    
    NSURLSession * session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask * task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSStringEncoding gb2312 = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        
        NSString *searchText = [[NSString alloc] initWithData:data encoding:gb2312];
        if (!searchText) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                !(block)? : block(@[]);
            });
            
            return;
        }
        
        NSString *dataRegex = @"<div class=\"player\"><script type=\"text/javascript\" src=\"(.*?)\">.*?</div>";
        NSString *dataStr = [self matchString:searchText toRegexString:dataRegex].lastObject;
        NSString *url = [NSString stringWithFormat:@"http://m.yueyuwz.com%@", dataStr];
        
        NSString *m3u8 = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:gb2312 error:NULL];
        
        NSString *hlsRegex = @"\\$.*?\\$";
        NSArray *hls = [self matchString:m3u8 toRegexString:hlsRegex];
        NSString *hlssRegex = @"\\$(.*?)\\$";
        
        NSMutableArray *temp = [NSMutableArray array];
        for (NSString *string in hls) {
            NSString *hlsString = [self matchString:string toRegexString:hlssRegex].lastObject;
            [temp addObject:hlsString];
        }
        
        NSArray *lists = [temp sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            
            BOOL b1 = [obj1 containsString:@"m3u8"];
            BOOL b2 = [obj2 containsString:@"m3u8"];
            
            return b1 < b2;
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            !(block)? : block(lists);
        });
        
        NSLog(@"%@",lists);
    }];
    //开启网络任务
    [task resume];
}

+ (void)getTVM3u8:(NSString *)urlStr title:(NSString *)title block: (void(^)(NSArray *))block{
    
    
    if (self.isProtocolService) {
        !(block)? : block(@[]);
        return;
    }
    
    NSURL * url = [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setValue:self.userAgent forHTTPHeaderField:@"User-Agent"];
    
    NSURLSession * session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask * task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSStringEncoding gb2312 = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        
        NSString *searchText = [[NSString alloc] initWithData:data encoding:gb2312];
        if (!searchText) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                !(block)? : block(@[]);
            });
            
            return;
        }
        
        NSString *dataRegex = @"<div class=\"player\"><script type=\"text/javascript\" src=\"(.*?)\">.*?</div>";
        NSString *dataStr = [self matchString:searchText toRegexString:dataRegex].lastObject;
        NSString *url = [NSString stringWithFormat:@"http://m.yueyuwz.com%@", dataStr];
        
        NSString *m3u8 = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:gb2312 error:NULL];
        m3u8 = [self replaceUnicode:m3u8];
        
        NSString *hlsRegex = [NSString stringWithFormat:@"%@\\$.*?\\$",title];
        NSArray *hls = [self matchString:m3u8 toRegexString:hlsRegex];
        NSString *hlssRegex = @"\\$(.*?)\\$";
        
        NSMutableArray *temp = [NSMutableArray array];
        for (NSString *string in hls) {
            NSString *hlsString = [self matchString:string toRegexString:hlssRegex].lastObject;
            [temp addObject:hlsString];
        }
        
        NSArray *lists = [temp sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            
            BOOL b1 = [obj1 containsString:@"m3u8"];
            BOOL b2 = [obj2 containsString:@"m3u8"];
            
            return b1 < b2;
        }];
        
        NSMutableArray *live_streams = [NSMutableArray array];
        [lists enumerateObjectsUsingBlock:^(NSString *   obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [live_streams addObject:@{@"name":title,@"live_stream":obj}];
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            !(block)? : block(live_streams);
        });
        
        NSLog(@"%@",lists);
    }];
    //开启网络任务
    [task resume];
}

+ (void)getTVDetail:(NSString *)urlStr block: (void(^)(NSDictionary *))block{
    
    
    if (self.isProtocolService) {
        !(block)? : block(@{});
        return;
    }
    
    NSURL * url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:self.userAgent forHTTPHeaderField:@"User-Agent"];
    
    NSURLSession * session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask * task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSStringEncoding gb2312 = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        
        NSString *searchText = [[NSString alloc] initWithData:data encoding:gb2312];
        if (!searchText) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                !(block)? : block(@{});
            });
            
            return;
        }
        
        NSString *iconRegex = @"<img src=\"(.*?)\" alt=\".*?\" class=\"pic l\" />";
        NSString *icon = [self matchString:searchText toRegexString:iconRegex].lastObject;
        icon =  [icon containsString:@"nopic.gif"]?@"":icon;
        
        NSString *nameRegex = @"<h1>(.*?)</h1>";
        NSString *name = [self matchString:searchText toRegexString:nameRegex].lastObject;
        
        NSString *mainShow = @"<a href=\".*?\">(.*?)</a>&nbsp;&nbsp;";
        NSArray *mains = [self matchString:searchText toRegexString:mainShow];
        
        NSMutableString *main = [NSMutableString string];
        for (NSInteger i = 1;i < mains.count; i+=2) {
            [main appendString:mains[i]];
        }
        
        NSString *statusRegex = @"<font class=\"note\">(.*?)</font>";
        NSString *status = [self matchString:searchText toRegexString:statusRegex].lastObject;
        
        NSString *typeRegex = @"<p>类型：(.*?)</p>";
        NSString *type = [self matchString:searchText toRegexString:typeRegex].lastObject;
        
        NSString *yearRegex = @"<p>年份：(.*?)</p>";
        NSString *year = [self matchString:searchText toRegexString:yearRegex].lastObject;
        
        NSString *languageRegex = @"<div>语言：(.*?)</div>";
        NSString *language = [self matchString:searchText toRegexString:languageRegex].lastObject;
        
        NSString *desRegex = @"<div class=\"description\">([\\w\\W]*?)</div>";
        NSString *des = [self matchString:searchText toRegexString:desRegex].lastObject;
        des = [self filterHtmlTag:des];
        
        NSString *hlsRegex = @"<li><a .?title=\'.*?\' href=\'.*?\' target=\"_self\">.*?</a>";
        NSString *m3u8Regex = @"<li><a .?title=\'(.*?)\' href=\'(.*?)\' target=\"_self\">.*?</a>";
        NSArray *hlss = [self matchString:searchText toRegexString:hlsRegex];
        
        NSMutableArray *m3u8s = [NSMutableArray array];
        for (NSString *hlsHtml in hlss) {
            NSArray *urls = [self matchString:hlsHtml toRegexString:m3u8Regex];
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"vn"] = urls[1];
            dict[@"vurl"] = [NSString stringWithFormat:@"http://m.yueyuwz.com%@", urls[2]];
            dict[@"desc"] = des;
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
                              @"language" : language.length?language:@"未知"
                              };
        dispatch_async(dispatch_get_main_queue(), ^{
            !(block)? : block(obj);
        });
    }];
    //开启网络任务
    [task resume];
}


+ (void)getHKTVPage:(NSInteger)page
             urlStr:(NSString *)urlStr
              block: (void(^)(NSArray <NSDictionary *>*))block{
    
    
    if (self.isProtocolService) {
        !(block)? : block(@[]);
        return;
    }
    
    NSString *str =  urlStr;
    if (page > 1) {
        str = [NSString stringWithFormat:@"%@_%ld.html",[str componentsSeparatedByString:@".html"].firstObject,(long)page];
    }
    
    NSURL * url = [NSURL URLWithString:str];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setValue:self.userAgent forHTTPHeaderField:@"User-Agent"];
    
    NSURLSession * session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask * task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSStringEncoding gb2312 = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        
        NSString *searchText = [[NSString alloc] initWithData:data encoding:gb2312];
        if (!searchText) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                !(block)? : block(@[]);
            });
            
            return;
        }
        
        NSString *rString = @"<li><a href=\".*?\" title=\".*?\" class=\"apic\"><img src=\".*?\" alt=\".*?\" /></a><p><a href=\".*?\">.*?</a></p></li>";
        
        NSArray *rs = [self matchString:searchText toRegexString:rString];
        NSLog(@"%s", __func__);
        NSString *rS = @"<li><a href=\".*?\" title=\".*?\" class=\"apic\"><img src=\"(.*?)\" alt=\".*?\" /></a><p><a href=\"(.*?)\">(.*?)</a></p></li>";
        
        
        NSMutableArray *temps = [NSMutableArray array];
        
        for (NSString *r in rs) {
            NSArray *d = [self matchString:r toRegexString:rS];
            if (d.count < 4) {
                continue;
            }
            NSLog(@"%s--%@", __func__,d);
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"img"] = [(NSString*)d[1] containsString:@"nopic.gif"]?@"":d[1];
            dict[@"live_stream"] = [NSString stringWithFormat:@"http://m.yueyuwz.com%@", d[2]];
            dict[@"title"] = d[3];
            [temps addObject:dict];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            !(block)? : block(temps);
        });
    }];
    //开启网络任务
    [task resume];
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

+ (NSString *)filterHtmlTag:(NSString *)originHtmlStr{
    
    if(!originHtmlStr) return @"";
    
    NSString *result = nil;
    NSRange arrowTagStartRange = [originHtmlStr rangeOfString:@"<"];
    if (arrowTagStartRange.location != NSNotFound) { //如果找到
        NSRange arrowTagEndRange = [originHtmlStr rangeOfString:@">"];
        
        result = [originHtmlStr stringByReplacingCharactersInRange:NSMakeRange(arrowTagStartRange.location, arrowTagEndRange.location - arrowTagStartRange.location + 1) withString:@""];
        return [self filterHtmlTag:result];    //递归，过滤下一个标签
    }else{
        result = [originHtmlStr stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];  // 过滤&nbsp等标签
        result = [result stringByReplacingOccurrencesOfString:@"&ldquo;" withString:@""];  // 过滤&ldquo等标签
        result = [result stringByReplacingOccurrencesOfString:@"&rdquo;" withString:@""];  // 过滤&ldquo等标签
        result = [result stringByReplacingOccurrencesOfString:@"&middot;" withString:@""];  // 过滤&ldquo等标签
        result = [result stringByReplacingOccurrencesOfString:@"&hellip;" withString:@""];  // 过滤&ldquo等标签
        result = [result stringByReplacingOccurrencesOfString:@"&rsquo;" withString:@""];  // 过滤&ldquo等标签
        result = [result stringByReplacingOccurrencesOfString:@"&lsquo;" withString:@""];  // 过滤&ldquo等标签
    }
    return result;
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

+ (NSString *) utf8ToUnicode:(NSString *)string
{
    if(!string) return @"";
    NSUInteger length = [string length];
    NSMutableString *s = [NSMutableString stringWithCapacity:0];
    for (int i = 0;i < length; i++)
    {
        unichar _char = [string characterAtIndex:i];
        //判断是否为英文和数字
        if (_char <= '9' && _char >= '0')
        {
            [s appendFormat:@"%@",[string substringWithRange:NSMakeRange(i, 1)]];
        }
        else if(_char >= 'a' && _char <= 'z')
        {
            [s appendFormat:@"%@",[string substringWithRange:NSMakeRange(i, 1)]];
        }
        else if(_char >= 'A' && _char <= 'Z')
        {
            [s appendFormat:@"%@",[string substringWithRange:NSMakeRange(i, 1)]];
        }
        else
        {
            [s appendFormat:@"\\u%x",[string characterAtIndex:i]];
        }
    }
    return s;
}

+ (NSString *)replaceUnicode:(NSString *)unicodeStr {
    if(!unicodeStr) return @"";
    
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    NSString *tempStr3 = [[@"\""stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
}


+ (NSString *)URLEncodedString:(NSString *)str
{
    if(!str) return @"";
    
    NSStringEncoding gb2312 = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    NSString *unencodedString = str;
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)unencodedString,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              gb2312));
    
    return encodedString;
}


+ (BOOL)isProtocolService{
    
    NSDictionary *proxySettings = (__bridge NSDictionary *)(CFNetworkCopySystemProxySettings());
    NSArray *proxies = (__bridge NSArray *)(CFNetworkCopyProxiesForURL((__bridge CFURLRef _Nonnull)([NSURL URLWithString:@"http://www.baidu.com"]), (__bridge CFDictionaryRef _Nonnull)(proxySettings)));
    //NSLog(@"\n%@",proxies);

    NSDictionary *settings = proxies[0];
    //    NSLog(@"%@",[settings objectForKey:(NSString *)kCFProxyHostNameKey]);
    //    NSLog(@"%@",[settings objectForKey:(NSString *)kCFProxyPortNumberKey]);
    //    NSLog(@"%@",[settings objectForKey:(NSString *)kCFProxyTypeKey]);

    if ([[settings objectForKey:(NSString *)kCFProxyTypeKey] isEqualToString:@"kCFProxyTypeNone"])
    {
        NSLog(@"没代理");
        return NO;

    }else{
        NSLog(@"设置了代理");

        return YES;
    }
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


//
//
//
///* -------------------- kkData ----------------------*/
//
//+(NSArray *)kkBaseDataBlock: (void(^)(NSArray <NSDictionary *>*))block {
//
//   NSArray *lists = [[NSUserDefaults standardUserDefaults] objectForKey:@"567it"];
//    lists = lists? lists : @[];
//    if ([JJHttp defaultHttp].isProtocolService) {
//        !(block)? : block(@[]);
//        return lists;
//    }
//
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//
//        NSString *CC = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://m.567it.com/"] encoding:NSUTF8StringEncoding error:nil];
//        if(!CC) return ;
//        NSArray *allKK = [CC componentsSeparatedByString:@"<a href=\""];
//
//        NSMutableArray *dicts = [NSMutableArray array];
//        [allKK enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            if (idx != 0) {
//
//                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//
//                dict[@"live_stream"] = [obj componentsSeparatedByString:@"\""].firstObject;
//                dict[@"img"] = @"https://upload-images.jianshu.io/upload_images/1274527-ebdc025cc33f855a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240";
//
//                if ([obj containsString:@"</font>"]) {
//
//                    dict[@"name"] = [[obj componentsSeparatedByString:@"</font>"].firstObject componentsSeparatedByString:@">"].lastObject;
//                }else {
//
//                    dict[@"name"] = [[obj componentsSeparatedByString:@"</a>"].firstObject componentsSeparatedByString:@">"].lastObject;
//                }
//
//                [dicts addObject:dict];
//                if(idx == 3) [dicts addObject:@{@"name":@"J2",@"live_stream":@"/?type=j2",@"img":@"https://upload-images.jianshu.io/upload_images/1274527-ebdc025cc33f855a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240"}];
//
//
//            }
//        }];
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [[NSUserDefaults standardUserDefaults] setObject:dicts forKey:@"567it"];
//            !(block)? : block(dicts);
//        });
//    });
//
//    return lists;
//}
//
//+(void)kkBaseDataUrl:(NSString *)baseUrl Block: (void(^)(NSString *))block {
//
//    if ([JJHttp defaultHttp].isProtocolService) {
//        !(block)? : block(@"rtmp://live.hkstv.hk.lxdns.com/live/hks");
//
//        return;
//    }
//
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//
//        NSURL *url = nil;
//
//        if ([baseUrl containsString:@"/"]) {
//
//            url = [NSURL URLWithString:[NSString stringWithFormat:@"http://m.567it.com%@",baseUrl]];
//
//        }else {
//
//            url = [NSURL URLWithString:[NSString stringWithFormat:@"http://m.567it.com/%@",baseUrl]];
//        }
//
//        NSString *CC = [[NSString alloc] initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
//
//        NSString *vurl = @"";
//        if ([CC containsString:@"video:'"]) {
//
//            vurl = [[CC componentsSeparatedByString:@"video:'"].lastObject componentsSeparatedByString:@"'"].firstObject;
//        }else {
//
//            NSURL *ipURL = [NSURL URLWithString:@"http://ip.taobao.com/service/getIpInfo.php?ip=myip"];
//
//            NSString *ip = [[NSString alloc] initWithContentsOfURL:ipURL encoding:NSUTF8StringEncoding error:nil];
//
//            ip = [[ip componentsSeparatedByString:@"\"ip\":\""].lastObject componentsSeparatedByString:@"\","].firstObject;
//
//            vurl = [NSString stringWithFormat:@"http://m.567it.com%@%@",[[CC componentsSeparatedByString:@"video=['"].lastObject componentsSeparatedByString:@"'+"].firstObject,ip];
//        }
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//            !(block)? : block(vurl);
//        });
//    });
//}

@end

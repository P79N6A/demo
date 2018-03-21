//
//  ZZYueYuTV.m
//  ZZCategory_Example
//
//  Created by Jay on 2018/2/26.
//  Copyright © 2018年 czljcb@163.com. All rights reserved.
//

#import "ZZYueYuTV.h"


@implementation ZZYueYuTV

+ (void)search:(NSString *)kw
          page:(NSInteger)page
         block: (void(^)(NSArray <NSDictionary *>*,BOOL))block{
    
    
    
    if(page == 1){
        //kw = @"三个";
        
        kw = [self URLEncodedString:kw];
        
        NSURL * url = [NSURL URLWithString:@"http://m.yueyuwz.com/search.asp"];
        //创建请求
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        [request setValue:@"Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Mobile Safari/537.36" forHTTPHeaderField:@"User-Agent"];
        [request setValue:@"http://m.yueyuwz.com" forHTTPHeaderField:@"Origin"];
        
        request.HTTPMethod = @"POST";
        
        
        NSData *paramData = [[NSString stringWithFormat:@"searchword=%@",kw] dataUsingEncoding:NSUTF8StringEncoding];
        
        request.HTTPBody = paramData;
        //创建Session
        NSURLSession * session = [NSURLSession sharedSession];
        //创建任务
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
                dict[@"icon"] = d[1];
                dict[@"provinceUrl"] = [NSString stringWithFormat:@"http://m.yueyuwz.com%@", d[2]];
                dict[@"province"] = d[3];
                [temps addObject:dict];
            }
            
            NSArray *nexts = [self matchString:searchText toRegexString:@"&searchtype=-1\" class=\"next\">下一页</a>"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                !(block)? : block(temps,[nexts count]);
            });

            
            ///< class="next">下一页</span>
            ///< href="?page=22&searchword=ff&searchtype=-1" class="next">下一页</a>
            NSLog(@"%s--%@", __func__,temps);
            
        }];
        //开启网络任务
        [task resume];

    }
    else{
        
        //kw = @"三个";
        
        kw = [self URLEncodedString:kw];
        
        NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"http://m.yueyuwz.com/search.asp?page=%ld&searchword=%@&searchtype=-1",(long)page,kw]];
        //创建请求
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        [request setValue:@"Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Mobile Safari/537.36" forHTTPHeaderField:@"User-Agent"];
        [request setValue:@"http://m.yueyuwz.com" forHTTPHeaderField:@"Origin"];
        //[request setValue:@"http://m.yueyuwz.com" forHTTPHeaderField:@"Origin"];
        
        //request.HTTPMethod = @"POST";
        
        
        //NSData *paramData = [[NSString stringWithFormat:@"searchword=%@",kw] dataUsingEncoding:gb2312];
        
        //request.HTTPBody = paramData;
        //创建Session
        NSURLSession * session = [NSURLSession sharedSession];
        //创建任务
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
                dict[@"icon"] = d[1];
                dict[@"provinceUrl"] = [NSString stringWithFormat:@"http://m.yueyuwz.com%@", d[2]];
                dict[@"province"] = d[3];
                [temps addObject:dict];
            }
            
            NSArray *nexts = [self matchString:searchText toRegexString:@"&searchtype=-1\" class=\"next\">下一页</a>"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                !(block)? : block(temps,[nexts count]);
            });

            ///< class="next">下一页</span>
            ///< href="?page=22&searchword=ff&searchtype=-1" class="next">下一页</a>
            NSLog(@"%s--%@", __func__,temps);
            
        }];
        //开启网络任务
        [task resume];
        
    }
    
}

+ (void)getTVM3u8:(NSString *)urlStr block: (void(^)(NSArray *))block{
    
    
    NSURL * url = [NSURL URLWithString:urlStr];
    //创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //    User-Agent: Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Mobile Safari/537.36
    
    [request setValue:@"Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Mobile Safari/537.36" forHTTPHeaderField:@"User-Agent"];
    //创建Session
    NSURLSession * session = [NSURLSession sharedSession];
    //创建任务
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
    
    
    NSURL * url = [NSURL URLWithString:urlStr];
    //创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //    User-Agent: Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Mobile Safari/537.36
    
    [request setValue:@"Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Mobile Safari/537.36" forHTTPHeaderField:@"User-Agent"];
    //创建Session
    NSURLSession * session = [NSURLSession sharedSession];
    //创建任务
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
        //        NSString *unicode = [self utf8ToUnicode:title];
        
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
        
        dispatch_async(dispatch_get_main_queue(), ^{
            !(block)? : block(lists);
        });

        
        NSLog(@"%@",lists);
        
    }];
    //开启网络任务
    [task resume];
    
}

+ (void)getTVDetail:(NSString *)urlStr block: (void(^)(NSDictionary *))block{
    
    
    NSURL * url = [NSURL URLWithString:urlStr];
    //创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //    User-Agent: Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Mobile Safari/537.36
    
    [request setValue:@"Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Mobile Safari/537.36" forHTTPHeaderField:@"User-Agent"];
    //创建Session
    NSURLSession * session = [NSURLSession sharedSession];
    //创建任务
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
            dict[@"name"] = urls[1];
            dict[@"url"] = [NSString stringWithFormat:@"http://m.yueyuwz.com%@", urls[2]];
            [m3u8s addObject:dict];
        }
        
        
        
        
        //        NSLog(@"%s", __func__);
        
        
        
        NSDictionary *obj = @{
                              @"icon":icon.length?icon : @"",
                              @"name":name.length?name : @"未知",
                              @"status":status.length? status : @"未知",
                              @"type":type.length?type : @"未知",
                              @"year":year.length?year : @"未知",
                              @"des":des.length? des : @"暂无介绍",
                              @"hls":m3u8s.count? m3u8s : @[],
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


+ (void)getHKTVPage:(NSInteger)page block: (void(^)(NSArray <NSDictionary *>*))block{
    
    
    NSString *str =  @"http://m.yueyuwz.com/feifan/feifan7710.html";
    if (page > 1) {
        str = [NSString stringWithFormat:@"%@_%ld.html",[str componentsSeparatedByString:@".html"].firstObject,(long)page];
    }
    
    NSURL * url = [NSURL URLWithString:str];
    //创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //    User-Agent: Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Mobile Safari/537.36
    
    [request setValue:@"Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Mobile Safari/537.36" forHTTPHeaderField:@"User-Agent"];
    //创建Session
    NSURLSession * session = [NSURLSession sharedSession];
    //创建任务
    NSURLSessionDataTask * task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSStringEncoding gb2312 = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        
        
        
        
        //        NSLog(@"%@",[[NSString alloc] initWithData:data encoding:gb2312]);
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
            dict[@"icon"] = d[1];
            dict[@"provinceUrl"] = [NSString stringWithFormat:@"http://m.yueyuwz.com%@", d[2]];
            dict[@"province"] = d[3];
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
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSArray * matches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    
    //match: 所有匹配到的字符,根据() 包含级
    
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
    NSString *result = nil;
    NSRange arrowTagStartRange = [originHtmlStr rangeOfString:@"<"];
    if (arrowTagStartRange.location != NSNotFound) { //如果找到
        NSRange arrowTagEndRange = [originHtmlStr rangeOfString:@">"];
        //        NSLog(@"start-> %d   end-> %d", arrowTagStartRange.location, arrowTagEndRange.location);
        //        NSString *arrowSubString = [originHtmlStr substringWithRange:NSMakeRange(arrowTagStartRange.location, arrowTagEndRange.location - arrowTagStartRange.location)];
        result = [originHtmlStr stringByReplacingCharactersInRange:NSMakeRange(arrowTagStartRange.location, arrowTagEndRange.location - arrowTagStartRange.location + 1) withString:@""];
        // NSLog(@"Result--->%@", result);
        return [self filterHtmlTag:result];    //递归，过滤下一个标签
    }else{
        result = [originHtmlStr stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];  // 过滤&nbsp等标签
        result = [result stringByReplacingOccurrencesOfString:@"&ldquo;" withString:@""];  // 过滤&ldquo等标签
        result = [result stringByReplacingOccurrencesOfString:@"&rdquo;" withString:@""];  // 过滤&ldquo等标签
        result = [result stringByReplacingOccurrencesOfString:@"&middot;" withString:@""];  // 过滤&ldquo等标签
        result = [result stringByReplacingOccurrencesOfString:@"&hellip;" withString:@""];  // 过滤&ldquo等标签
        result = [result stringByReplacingOccurrencesOfString:@"&rsquo;" withString:@""];  // 过滤&ldquo等标签
        result = [result stringByReplacingOccurrencesOfString:@"&lsquo;" withString:@""];  // 过滤&ldquo等标签
        
        
        
        
        
        //result = [originHtmlStr stringByReplacingOccurrencesOf  ........
    }
    return result;
}


+(NSString *)flattenHTML:(NSString *)html {
    NSScanner *theScanner;
    NSString *text = nil;
    theScanner = [NSScanner scannerWithString:html];
    while ([theScanner isAtEnd] == NO) {
        // find start of tag
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        // find end of tag
        [theScanner scanUpToString:@">" intoString:&text] ;
        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
        html=[html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text] withString:@""];
    }
    return html;
}

+ (NSString *) utf8ToUnicode:(NSString *)string
{
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
    // CharactersToBeEscaped = @":/?&=;+!@#$()~',*";
    // CharactersToLeaveUnescaped = @"[].";
    
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

@end


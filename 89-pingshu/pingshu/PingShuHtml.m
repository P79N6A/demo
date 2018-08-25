//
//  HJManger.m
//  HJManger
//
//  Created by xin on 2018/7/2.
//  Copyright © 2018年 sdl. All rights reserved.
//

#import "PingShuHtml.h"

@implementation PingShuHtml


+ (void)test{
    NSString *str =  @"http://bddn.cn/zwgb.htm";//@"http://bddn.cn/gb.htm";
    //    if (page > 1) {
    //        str = [NSString stringWithFormat:@"http://www.97taiju.com/list/taiju/index-%ld.html",(long)page];
    //    }
    
    //next: 5
    //table: music
    //action: getmorenews
    //limit: 10
    //small_length: 120
    //classid: 8,9,16,17,18,64,66,65,67,68,69,70,71,72,73,74,75,76,77
    
    NSStringEncoding enc =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    NSURL * url = [NSURL URLWithString:str];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setTimeoutInterval:10.0];
    [request setValue:self.userAgent forHTTPHeaderField:@"User-Agent"];

    //6根据会话创建一个task（发送请求）
    
    
    NSURLSession * session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask * task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSStringEncoding enc =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString *searchText = [[NSString alloc] initWithData:data encoding:enc];
        searchText=[searchText stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        searchText=[searchText stringByReplacingOccurrencesOfString:@"\r" withString:@""];

        
        NSString *rString = @"<td width=\"72\" class=\"STYLE4\"><div align=\"center\"><a href=\".*?\" target=\"_blank\">.*?</a></div></td>";

        rString = @"</table><table width=\"770\" height=\"25\" border=\"0\" align=\"center\">  <tbody><tr>    <td width=\"72\" bgcolor=\"#.*?\" class=\"STYLE4\"><div align=\"center\">.*?：</div></td>[\\w\\W]*?</table>";
        
        NSArray *rs = [self matchString:searchText toRegexString:rString];
        
        NSString *rReg = @"<a href=\".*?\" target=\"_blank\">.*?</a>";

        
        NSMutableArray *array = [NSMutableArray array];
        for (NSString *r in rs) {
            NSArray *ms = [self matchString:r toRegexString:rReg];
            NSString*cate = [self matchString:r toRegexString:@"<div align=\"center\">(.*?)：</div>"].lastObject;
            NSMutableArray *list = [NSMutableArray array];
            for (NSString *m in ms) {
                NSArray*info = [self matchString:m toRegexString:@"<a href=\"(.*?)\" target=\"_blank\">(.*?)</a>"];
                
                NSString *html = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:info[1]] encoding:NSUTF8StringEncoding error:NULL];
                NSString*url = [self matchString:html toRegexString:@"showPlayer\\(\'(.*?)\', \'a1\'\\);"].lastObject;
                if (!html) {
                    url = info[1];
                    NSLog(@"--出差了----%@",info[1]);

                }
                
                [list addObject:@{@"url":url,@"name":info[2]}];
                NSLog(@"--%@----%@",info[2],url);

            }
            [array addObject:@{@"title":cate,@"list":list}];
        }
        
        ///NSLog(@"%s--%@", __func__,array);
        
        NSData *d = [NSJSONSerialization dataWithJSONObject:array options:NSJSONReadingAllowFragments error:NULL];
        NSString *josn = [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
        NSLog(@"%s", __func__);
        
    }];
    //开启网络任务
    [task resume];

}

//FIXME:  -  泰剧列表(百家---)
+ (void)searchPingShuKeyWord:(NSString *)kw
              completed: (void(^)(NSArray <NSDictionary *>*objs))block{
    
    if (self.isProtocolService) {
        !(block)? : block(@[]);
        return;
    }
    
    NSString *str =  @"http://mpublic.zgpingshu.com/search/index.php";
    //    if (page > 1) {
    //        str = [NSString stringWithFormat:@"http://www.97taiju.com/list/taiju/index-%ld.html",(long)page];
    //    }
    
    //next: 5
    //table: music
    //action: getmorenews
    //limit: 10
    //small_length: 120
    //classid: 8,9,16,17,18,64,66,65,67,68,69,70,71,72,73,74,75,76,77
    
    NSStringEncoding enc =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);

    NSURL * url = [NSURL URLWithString:str];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setTimeoutInterval:10.0];
    [request setValue:self.userAgent forHTTPHeaderField:@"User-Agent"];
    request.HTTPMethod = @"POST";
    //5,设置请求体
    NSString *parmages = //@"keyboard=44&orderby=3&show=title%2Cnewstext%2Cwriter%2Cbefrom";
    [NSString stringWithFormat:@"keyboard=%@&orderby=3&show=title,newstext,writer,befrom",kw];
//    keyboard=%C8%FD&orderby=3&show=title%2Cnewstext%2Cwriter%2Cbefrom
    parmages = [parmages stringByAddingPercentEscapesUsingEncoding:enc];
    request.HTTPBody = [parmages dataUsingEncoding:NSUTF8StringEncoding];
    //6根据会话创建一个task（发送请求）
    
    
    NSURLSession * session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask * task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSStringEncoding enc =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString *searchText = [[NSString alloc] initWithData:data encoding:enc];
        
        
        if (!searchText) {
            dispatch_async(dispatch_get_main_queue(), ^{
                !(block)? : block(@[]);
            });
            
            return;
        }
        
        NSString *rString = @"<li><a .*?</div></li>";
        NSArray *rs = [self matchString:searchText toRegexString:rString];
        NSLog(@"%s", __func__);
        
        
        NSString *rS = @"<li><a href=\"(.*?)\" class=\".*?\"><div class=\".*?\"><img class=\".*?\" src=\"(.*?)\" alt=\"(.*?)\"></div><div class=\".*?\"><p class=\".*?\"><span class=\".*?\">.*?</span><span class=\"product-show-distance huo\">(.*?)</span></p><p class=\".*?\">(.*?)</p></div></a><div class=\".*?\"><div class=\".*?\"><p class=\".*?\" align=\"center\"><span>(.*?)</span> <span>(.*?)</span> <span>(.*?)</span> <span>(.*?)</span></p></div></a></div><div class=\"interval\"></div></li>";
        
        rS = @"<li><a href=\"(.*?)\" class=\".*?\"><div class=\".*?\"><img class=\".*?\" src=\"(.*?)\" alt=\".*?\"></div><div class=\"weui_media_bd\"><p class=\"weui_media_title product-buttom\"><span class=\"product-show-title\">(.*?)</span><span class=\"product-show-distance huo\"><i class=\"iconfont icon-huo\"></i><i class=\"iconfont icon-huo\"></i><i class=\"iconfont icon-huo\"></i><i class=\"iconfont icon-huo\"></i></span></p><p class=\"weui_media_desc product-buttom\">(.*?)</p></div></a><div class=\"interval\"></div></li>";
        
        
//        NSString *hotS = @"<i class=\"iconfont icon-huo\"></i>";
        
        NSMutableArray *temps = [NSMutableArray array];
        
        
        for (NSString *r in rs) {
            NSArray *d = [self matchString:r toRegexString:rS];
            if (d.count < 5) {
                continue;
            }
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"img"] = [NSString stringWithFormat:@"http:%@", d[2]];//http://titlepic.zgpingshu.com/918475b4d7657d4c085a42aab22a7d14.jpg
            dict[@"url"] = [NSString stringWithFormat:@"http:%@", d[1]];
            dict[@"title"] = [self flattenHTML:d[3]];;
            dict[@"des"] = d[4];
            
            
            [temps addObject:dict];
            
        }
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            !(block)? : block(temps);
        });
    }];
    //开启网络任务
    [task resume];
    
}



+ (void)taiJuSearch:(NSString *)kw
          pageNo:(NSInteger)page
         completed: (void(^)(NSArray <NSDictionary *>*objs,BOOL))block{
    
    if (self.isProtocolService){
        !(block)? : block(@[],NO);
        return;
    }
    page = page? page : 1;
    NSString* encodedString = [[NSString stringWithFormat:@"http://www.97taiju.com/index.php?s=vod-search-wd-%@-p.html",kw] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    if (page>1) {
        encodedString = [[NSString stringWithFormat:@"http://www.97taiju.com/index.php?s=vod-search-wd-%@-p-%ld.html",kw,(long)page] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
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
        if (!searchText) {
            dispatch_async(dispatch_get_main_queue(), ^{
                !(block)? : block(@[],NO);
            });
            
            return;
        }
        
        NSString *rString = @"<dt><a href=\".*?\" target=\"_blank\" title=\".*?\"><img src=\".*?\" onerror=\".*?\" alt=\".*?\"/></a></dt>";
        
        NSArray *rs = [self matchString:searchText toRegexString:rString];
        NSLog(@"%s", __func__);
        NSString *rS = @"<dt><a href=\"(.*?)\" target=\"_blank\" title=\"(.*?)\"><img src=\"(.*?)\" onerror=\".*?\" alt=\".*?\"/></a></dt>";
        
        NSString *pString = @".*?&nbsp;当前:.*?/(.*?)页&nbsp;";
        NSArray *ps = [self matchString:searchText toRegexString:pString];
        NSInteger totalPage = [ps.lastObject integerValue];
        
        
        NSMutableArray *temps = [NSMutableArray array];
        
        for (NSString *r in rs) {
            NSArray *d = [self matchString:r toRegexString:rS];
            if (d.count < 4) {
                continue;
            }
            NSLog(@"%s--%@", __func__,d);
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"img"] = d[3];
            dict[@"url"] = [NSString stringWithFormat:@"http://www.97taiju.com/%@", d[1]];
            dict[@"title"] = d[2];
            

            [temps addObject:dict];
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            !(block)? : block(temps,page<totalPage);
        });
        
        
    }];
    //开启网络任务
    [task resume];
    
}





+ (void)pingShuMp3:(NSString *)urlStr
            completed: (void(^)(NSString *obj))block{

    
    if ([self isProtocolService]) {
        !(block)? : block(@"");
        return;
    }
    
    NSURL * url = [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setTimeoutInterval:10.0];

    [request setValue:@"Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Mobile Safari/537.36" forHTTPHeaderField:@"User-Agent"];
    
    NSURLSession * session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask * task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        NSStringEncoding gb2312 = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        
        //NSString *searchText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if (!data) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                !(block)? : block(@"");
            });
            
            return;
        }
        
//        NSString *dataRegex = @"<div id=\".*?\"><script charset=\".*?\" src=\"(.*?)\"></script><script charset=\".*?\" src=\".*?\"></script><script charset=\".*?\" src=\".*?\"></script>";
//        NSString *dataStr = [self matchString:searchText toRegexString:dataRegex].lastObject;
//        NSString *url = [NSString stringWithFormat:@"http://www.97taiju.com%@", dataStr];
//        NSString *jsContet = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:NULL];
//        NSString *jsonRegex = @"var ff_urls='(.*?)';";
//        NSString *json = [self matchString:jsContet toRegexString:jsonRegex].lastObject;
//
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:NULL];
//        NSArray *Data = dict[@"Data"];
//        NSMutableArray *hls = [NSMutableArray array];
//        [Data enumerateObjectsUsingBlock:^(NSDictionary  * obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            NSString *playname = [obj valueForKey:@"playname"];
//            NSArray <NSArray *>*playurls = obj[@"playurls"];
//            [[[playurls reverseObjectEnumerator] allObjects] enumerateObjectsUsingBlock:^(NSArray * _Nonnull playurl, NSUInteger idx, BOOL * _Nonnull stop) {
//                if ([playname isEqualToString:@"yuku"]) {
//                    [hls addObject:@{@"title":playurl[0],@"url":[NSString stringWithFormat:@"https://player.youku.com/embed/%@?&autoplay=true",playurl[1]]}];
//                }else{
//
//                    [hls addObject:@{@"title":playurl[0],@"url":[playurl[1] stringByReplacingOccurrencesOfString:@"&type=free" withString:@""]}];
//                }
//            }];
//
//        }];
//        NSLog(@"%s", __func__);
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
            NSString *urlpath = [dict valueForKey:@"urlpath"];
            if (!urlpath) {
                urlpath = @"";
            }
            !(block)? : block([urlpath stringByReplacingOccurrencesOfString:@"flv" withString:@"mp3"]);
        });
        
    }];
    //开启网络任务
    [task resume];
}



+ (void)getPingShuDetail:(NSString *)urlStr
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
        
        NSStringEncoding enc =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString *searchText = [[NSString alloc] initWithData:data encoding:enc];
        
        if (searchText.length==0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                !(block)? : block(@{});
                
            });
            return;
        }
        NSString *iconRegex = @"<img src=\"(.*?)\" alt=\".*?\" class=\"img-border img-resp \" height=\"300\" />";
        NSString *icon = [self matchString:searchText toRegexString:iconRegex].lastObject;
        
        NSString *nameRegex = @"<h1 class=\"weui-header-title\">(.*?)</h1>";
        NSString *name = [self matchString:searchText toRegexString:nameRegex].lastObject;
        
//
//        NSString *statusRegex = @"<DD>状态：<span class=\".*?\">(.*?)</span></DD>";
//        NSString *status = [self matchString:searchText toRegexString:statusRegex].lastObject;
//
//        NSString *typeRegex = @"<DD class=left>类型：<a href=\".*?\">(.*?)</a></DD>";
//        NSString *type = [self matchString:searchText toRegexString:typeRegex].lastObject;
//
//        NSString *yearRegex = @"<DD class=right>年份：<span class=\".*?\">(.*?)</span></DD>";
//        NSString *year = [self matchString:searchText toRegexString:yearRegex].lastObject;
//
//        NSString *languageRegex = @"<DD class=left>语言：<span class=\".*?\">(.*?)</span></DD>";
//        NSString *language = [self matchString:searchText toRegexString:languageRegex].lastObject;
        
        NSString *desRegex = @"<div class=\"weui-weixin-content\">([\\w\\W]*?)</div>";
        NSString *des = [self matchString:searchText toRegexString:desRegex].lastObject;
        des = [self flattenHTML:des];
        des = [des stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        
        NSString *tuijianReg = @"<div class=\"weui_cells_title\">评书推荐</div>([\\w\\W]*?)</div>\\r\\n</div>";
        NSString *tuijian = [self matchString:searchText toRegexString:tuijianReg].lastObject;

        NSString *rReg = @"<li><a .*?</div></li>";
        NSArray *rs = [self matchString:tuijian toRegexString:rReg];
        
        
        rReg = @"<li><a href=\"(.*?)\" class=\".*?\"><div class=\".*?\"><img class=\".*?\" src=\"(.*?)\" alt=\"(.*?)\"></div><div class=\".*?\"><p class=\".*?\"><span class=\".*?\">.*?</span><span class=\"product-show-distance huo\">(.*?)</span></p><p class=\".*?\">(.*?)</p></div></a><div class=\".*?\"><div class=\".*?\"><p class=\".*?\" align=\"center\"><span>(.*?)</span> <span>(.*?)</span> <span>(.*?)</span> <span>(.*?)</span></p></div></div><div class=\"interval\"></div></li>";
        
        
        NSString *hotReg = @"<i class=\"iconfont icon-huo\"></i>";
        
        NSMutableArray *hots = [NSMutableArray array];
        
        
        for (NSString *r in rs) {
            NSArray *d = [self matchString:r toRegexString:rReg];
            if (d.count < 10) {
                continue;
            }
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"img"] = [NSString stringWithFormat:@"http:%@", d[2]];//http://titlepic.zgpingshu.com/918475b4d7657d4c085a42aab22a7d14.jpg
            dict[@"url"] = [NSString stringWithFormat:@"http://m.zgpingshu.com%@", d[1]];
            dict[@"title"] = [self flattenHTML:d[3]];
            dict[@"des"] = d[5];
            
            dict[@"hot"] = @([self matchString:r toRegexString:hotReg].count);
            dict[@"number"] = d[6];
            dict[@"duration"] = d[7];
            dict[@"bit"] = d[8];
            dict[@"status"] = d[9];
            
            [hots addObject:dict];
            
        }
        
        
        NSString *listReg = @"<div class=\"weui_cells weui_cells_access\" id=\"alllist\">([\\w\\W]*?)<div id=\"changpages\"></div>";
        NSString *list = [self matchString:searchText toRegexString:listReg].lastObject;
        NSString *itemReg = @"<li .*?</a></li>";
        NSArray *items = [self matchString:list toRegexString:itemReg];

        itemReg = @"<li.*?class=\"border-bottom\"><a class=\"weui_cell \" href=\"(.*?)\"><div class=\"weui_cell_bd weui_cell_primary\"><p><i class=\"iconfont icon-bofang1 orange\"></i> (.*?)</p></div><div class=\"weui_cell_ft\">.*?</div></a></li>";
        NSMutableArray *lists = [NSMutableArray array];
        
        
        for (NSString *r in items) {
            NSArray *d = [self matchString:r toRegexString:itemReg];
            if (d.count < 3) {
                continue;
            }
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"url"] = [NSString stringWithFormat:@"http://m.zgpingshu.com%@", d[1]];
            dict[@"title"] = d[2];
            //http://m.zgpingshu.com/playdata/1030/index.h
            dict[@"murl"] = [dict[@"url"] stringByReplacingOccurrencesOfString:@"play" withString:@"playdata"];

            [lists addObject:dict];
            
        }


        
        
        NSDictionary *obj = @{
                              @"img":icon.length?icon : @"",
                              @"title":name.length?name : @"未知",
                              @"des":des.length? des : @"暂无介绍",
                              @"vlist":lists.count? lists : @[],
                              @"hlist" : hots.count? hots:@[],
                              };
        dispatch_async(dispatch_get_main_queue(), ^{
            !(block)? : block(obj);
        });
    }];
    //开启网络任务
    [task resume];
}


//FIXME:  -  泰剧列表(百家)
+ (void)getPingShuPageNo:(NSInteger)page
             completed: (void(^)(NSArray <NSDictionary *>*objs))block{
    
    if (self.isProtocolService) {
        !(block)? : block(@[]);
        return;
    }
    
    NSString *str =  @"http://m.zgpingshu.com/e/action/get_music_list.php";
    //    if (page > 1) {
    //        str = [NSString stringWithFormat:@"http://www.97taiju.com/list/taiju/index-%ld.html",(long)page];
    //    }
    
    //next: 5
    //table: music
    //action: getmorenews
    //limit: 10
    //small_length: 120
    //classid: 8,9,16,17,18,64,66,65,67,68,69,70,71,72,73,74,75,76,77
    
    
    NSURL * url = [NSURL URLWithString:str];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setTimeoutInterval:10.0];
    [request setValue:self.userAgent forHTTPHeaderField:@"User-Agent"];
    request.HTTPMethod = @"POST";
    //5,设置请求体
    NSString *parmages = [NSString stringWithFormat:@"next=%ld&table=music&action=getmorenews&limit=10&small_length=120&classid=%@",(long)page,@"4"];
    request.HTTPBody = [parmages dataUsingEncoding:NSUTF8StringEncoding];
    //6根据会话创建一个task（发送请求）
    
    
    NSURLSession * session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask * task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSStringEncoding enc =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString *searchText = [[NSString alloc] initWithData:data encoding:enc];
        
        
        if (!searchText) {
            dispatch_async(dispatch_get_main_queue(), ^{
                !(block)? : block(@[]);
            });
            
            return;
        }
        
        NSString *rString = @"<li><a .*?</div></li>";
        NSArray *rs = [self matchString:searchText toRegexString:rString];
        NSLog(@"%s", __func__);
        
        
        NSString *rS = @"<li><a href=\"(.*?)\" class=\".*?\"><div class=\".*?\"><img class=\".*?\" src=\"(.*?)\" alt=\"(.*?)\"></div><div class=\".*?\"><p class=\".*?\"><span class=\".*?\">.*?</span><span class=\"product-show-distance huo\">(.*?)</span></p><p class=\".*?\">(.*?)</p></div></a><div class=\".*?\"><div class=\".*?\"><p class=\".*?\" align=\"center\"><span>(.*?)</span> <span>(.*?)</span> <span>(.*?)</span> <span>(.*?)</span></p></div></div><div class=\"interval\"></div></li>";
        
        
        NSString *hotS = @"<i class=\"iconfont icon-huo\"></i>";
        
        NSMutableArray *temps = [NSMutableArray array];
        
        
        for (NSString *r in rs) {
            NSArray *d = [self matchString:r toRegexString:rS];
            if (d.count < 10) {
                continue;
            }
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"img"] = [NSString stringWithFormat:@"http:%@", d[2]];//http://titlepic.zgpingshu.com/918475b4d7657d4c085a42aab22a7d14.jpg
            dict[@"url"] = [NSString stringWithFormat:@"http://m.zgpingshu.com%@", d[1]];
            dict[@"title"] = d[3];
            dict[@"des"] = d[5];
            
            dict[@"hot"] = @([self matchString:r toRegexString:hotS].count);
            dict[@"number"] = d[6];
            dict[@"duration"] = d[7];
            dict[@"bit"] = d[8];
            dict[@"status"] = d[9];
            
            [temps addObject:dict];
            
        }
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            !(block)? : block(temps);
        });
    }];
    //开启网络任务
    [task resume];
    
}

//FIXME:  -  泰剧列表(长篇)
+ (void)getLongPingShuPageNo:(NSInteger)page
               classId:(NSString *)class
                 completed: (void(^)(NSArray <NSDictionary *>*objs))block{

    
    if (self.isProtocolService) {
        !(block)? : block(@[]);
        return;
    }
    
    NSString *str =  @"http://m.zgpingshu.com/e/action/get_music_index.php";
//    if (page > 1) {
//        str = [NSString stringWithFormat:@"http://www.97taiju.com/list/taiju/index-%ld.html",(long)page];
//    }
    
//next: 5
//table: music
//action: getmorenews
//limit: 10
//small_length: 120
//classid: 8,9,16,17,18,64,66,65,67,68,69,70,71,72,73,74,75,76,77

    
    NSURL * url = [NSURL URLWithString:str];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setTimeoutInterval:10.0];
    [request setValue:self.userAgent forHTTPHeaderField:@"User-Agent"];
    request.HTTPMethod = @"POST";
    //5,设置请求体
    NSString *parmages = [NSString stringWithFormat:@"next=%ld&table=music&action=getmorenews&limit=10&small_length=120&classid=%@",(long)page,class];
    request.HTTPBody = [parmages dataUsingEncoding:NSUTF8StringEncoding];
    //6根据会话创建一个task（发送请求）

    
    NSURLSession * session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask * task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSStringEncoding enc =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString *searchText = [[NSString alloc] initWithData:data encoding:enc];
        
        
        if (!searchText) {
            dispatch_async(dispatch_get_main_queue(), ^{
                !(block)? : block(@[]);
            });
            
            return;
        }
        
        NSString *rString = @"<li><a .*?</div></li>";
        NSArray *rs = [self matchString:searchText toRegexString:rString];
        NSLog(@"%s", __func__);
        
        
        NSString *rS = @"<li><a href=\"(.*?)\" class=\".*?\"><div class=\".*?\"><img class=\".*?\" src=\"(.*?)\" alt=\"(.*?)\"></div><div class=\".*?\"><p class=\".*?\"><span class=\".*?\">.*?</span><span class=\"product-show-distance huo\">(.*?)</span></p><p class=\".*?\">(.*?)</p></div></a><div class=\".*?\"><div class=\".*?\"><p class=\".*?\" align=\"center\"><span>(.*?)</span> <span>(.*?)</span> <span>(.*?)</span> <span>(.*?)</span></p></div></div><div class=\"interval\"></div></li>";
        
        
        NSString *hotS = @"<i class=\"iconfont icon-huo\"></i>";

        NSMutableArray *temps = [NSMutableArray array];
        
    
        for (NSString *r in rs) {
            NSArray *d = [self matchString:r toRegexString:rS];
            if (d.count < 10) {
                continue;
            }
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"img"] = [NSString stringWithFormat:@"http:%@", d[2]];//http://titlepic.zgpingshu.com/918475b4d7657d4c085a42aab22a7d14.jpg
            dict[@"url"] = [NSString stringWithFormat:@"http://m.zgpingshu.com%@", d[1]];
            dict[@"title"] = d[3];
            dict[@"des"] = d[5];
            
            dict[@"hot"] = @([self matchString:r toRegexString:hotS].count);
            dict[@"number"] = d[6];
            dict[@"duration"] = d[7];
            dict[@"bit"] = d[8];
            dict[@"status"] = d[9];

            [temps addObject:dict];
            
        }

        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            !(block)? : block(temps);
        });
    }];
    //开启网络任务
    [task resume];
}




//FIXME:  -  泰剧列表(百家---)
+ (void)getPingShuURL:(NSString *)str
             completed: (void(^)(NSArray <NSDictionary *>*objs))block{
    
    if (self.isProtocolService) {
        !(block)? : block(@[]);
        return;
    }
    
    //NSString *str =  @"http://m.zgpingshu.com/e/action/get_music_list.php";
    //    if (page > 1) {
    //        str = [NSString stringWithFormat:@"http://www.97taiju.com/list/taiju/index-%ld.html",(long)page];
    //    }
    
    //next: 5
    //table: music
    //action: getmorenews
    //limit: 10
    //small_length: 120
    //classid: 8,9,16,17,18,64,66,65,67,68,69,70,71,72,73,74,75,76,77
    
    
    NSURL * url = [NSURL URLWithString:str];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setTimeoutInterval:10.0];
    [request setValue:self.userAgent forHTTPHeaderField:@"User-Agent"];
    //request.HTTPMethod = @"POST";
    //5,设置请求体
    //NSString *parmages = [NSString stringWithFormat:@"next=%ld&table=music&action=getmorenews&limit=10&small_length=120&classid=%@",(long)page,@"4"];
    //request.HTTPBody = [parmages dataUsingEncoding:NSUTF8StringEncoding];
    //6根据会话创建一个task（发送请求）
    
    
    NSURLSession * session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask * task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSStringEncoding enc =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString *searchText = [[NSString alloc] initWithData:data encoding:enc];
        
        
        if (!searchText) {
            dispatch_async(dispatch_get_main_queue(), ^{
                !(block)? : block(@[]);
            });
            
            return;
        }
        
        NSString *rString = @"<li><a .*?</div></li>";
        NSArray *rs = [self matchString:searchText toRegexString:rString];
        NSLog(@"%s", __func__);
        
        
        NSString *rS = @"<li><a href=\"(.*?)\" class=\".*?\"><div class=\".*?\"><img class=\".*?\" src=\"(.*?)\" alt=\"(.*?)\"></div><div class=\".*?\"><p class=\".*?\"><span class=\".*?\">.*?</span><span class=\"product-show-distance huo\">(.*?)</span></p><p class=\".*?\">(.*?)</p></div></a><div class=\".*?\"><div class=\".*?\"><p class=\".*?\" align=\"center\"><span>(.*?)</span> <span>(.*?)</span> <span>(.*?)</span> <span>(.*?)</span></p></div></div><div class=\"interval\"></div></li>";
        
        
        NSString *hotS = @"<i class=\"iconfont icon-huo\"></i>";
        
        NSMutableArray *temps = [NSMutableArray array];
        
        
        for (NSString *r in rs) {
            NSArray *d = [self matchString:r toRegexString:rS];
            if (d.count < 10) {
                continue;
            }
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"img"] = [NSString stringWithFormat:@"http:%@", d[2]];//http://titlepic.zgpingshu.com/918475b4d7657d4c085a42aab22a7d14.jpg
            dict[@"url"] = [NSString stringWithFormat:@"http://m.zgpingshu.com%@", d[1]];
            dict[@"title"] = d[3];
            dict[@"des"] = d[5];
            
            dict[@"hot"] = @([self matchString:r toRegexString:hotS].count);
            dict[@"number"] = d[6];
            dict[@"duration"] = d[7];
            dict[@"bit"] = d[8];
            dict[@"status"] = d[9];
            
            [temps addObject:dict];
            
        }
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            !(block)? : block(temps);
        });
    }];
    //开启网络任务
    [task resume];
    
}


//FIXME:  -  泰剧列表(名家)
+ (void)getMingRenTangCompleted: (void(^)(NSArray <NSDictionary *>*objs))block{
    
    
    if (self.isProtocolService) {
        !(block)? : block(@[]);
        return;
    }
    
    NSString *str =  @"http://m.zgpingshu.com/mingrentang/";
    //    if (page > 1) {
    //        str = [NSString stringWithFormat:@"http://www.97taiju.com/list/taiju/index-%ld.html",(long)page];
    //    }
    
    //next: 5
    //table: music
    //action: getmorenews
    //limit: 10
    //small_length: 120
    //classid: 8,9,16,17,18,64,66,65,67,68,69,70,71,72,73,74,75,76,77
    
    
    NSURL * url = [NSURL URLWithString:str];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setTimeoutInterval:10.0];
    [request setValue:self.userAgent forHTTPHeaderField:@"User-Agent"];
    //request.HTTPMethod = @"POST";
    //5,设置请求体
    //NSString *parmages = [NSString stringWithFormat:@"next=%ld&table=music&action=getmorenews&limit=10&small_length=120&classid=%@",(long)page,class];
    //request.HTTPBody = [parmages dataUsingEncoding:NSUTF8StringEncoding];
    //6根据会话创建一个task（发送请求）
    
    
    NSURLSession * session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask * task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSStringEncoding enc =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString *searchText = [[NSString alloc] initWithData:data encoding:enc];
        
        
        if (!searchText) {
            dispatch_async(dispatch_get_main_queue(), ^{
                !(block)? : block(@[]);
            });
            
            return;
        }
        
        NSString *indexReg = @"<a name=\".*?\" dd_name=\".*?\" rel=\".*?\"><li class=\".*?\">.*?</li></a>";
        NSArray *indexs = [self matchString:searchText toRegexString:indexReg];
        indexReg = @"<a name=\"(.*?)\" dd_name=\"(.*?)\" rel=\".*?\"><li class=\".*?\">.*?</li></a>";

        
        NSString *seReg = @"<div class=\"weui_panel_bd\">";//@"<div.*?id=\"cate_lev2_.*?\">[\\w\\W]*?</h4><p class=\"weui_media_desc\"></p></div>";
        NSArray *ses = [searchText componentsSeparatedByString:seReg];//[self matchString:searchText toRegexString:seReg];
        seReg = @"<a.*?>[\\w\\W]*?</a>";
        NSString *DDReg = @"<a.*?href=\"(.*?)\".*?>[\\w\\W]*?<img class=\"weui_media_appmsg_thumb\".*?src=\"(.*?)\"[\\w\\W]*?<h4 class=\"weui_media_title\">(.*?)</h4>[\\w\\W]*?<p class=\"weui_media_desc\">(.*?)</p>[\\w\\W]*?</a>";
        NSMutableArray *names = [NSMutableArray array];

        [indexs enumerateObjectsUsingBlock:^(NSString * s, NSUInteger idx, BOOL * _Nonnull stop) {
            NSArray *d = [self matchString:s toRegexString:indexReg];
          
            NSArray *DD = [self matchString:ses[idx+1] toRegexString:seReg];
            NSMutableArray *temps = [NSMutableArray array];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];

            for (NSString  *r  in DD) {
                NSArray *D = [self matchString:r toRegexString:DDReg];
                if (D.count < 5) {
                    continue;
                 }
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                dict[@"img"] = [NSString stringWithFormat:@"http://m.zgpingshu.com%@", D[2]];
                dict[@"url"] = [NSString stringWithFormat:@"http://m.zgpingshu.com%@", D[1]];
                dict[@"title"] = D[3];
                dict[@"des"] = D[4];
                [temps addObject:dict];
                
                NSLog(@"%s", __func__);
            }
            
            dic[@"title"] = d[2];
            dic[@"list"] = temps;

            [names addObject:dic];
NSLog(@"%s", __func__);
        }];
        
        NSLog(@"%s", __func__);
        
//
//        NSString *rS = @"<li><a href=\"(.*?)\" class=\".*?\"><div class=\".*?\"><img class=\".*?\" src=\"(.*?)\" alt=\"(.*?)\"></div><div class=\".*?\"><p class=\".*?\"><span class=\".*?\">.*?</span><span class=\"product-show-distance huo\">(.*?)</span></p><p class=\".*?\">(.*?)</p></div></a><div class=\".*?\"><div class=\".*?\"><p class=\".*?\" align=\"center\"><span>(.*?)</span> <span>(.*?)</span> <span>(.*?)</span> <span>(.*?)</span></p></div></div><div class=\"interval\"></div></li>";
//
//
//        NSString *hotS = @"<i class=\"iconfont icon-huo\"></i>";
//
//        NSMutableArray *temps = [NSMutableArray array];
//
//
//        for (NSString *r in rs) {
//            NSArray *d = [self matchString:r toRegexString:rS];
//            if (d.count < 10) {
//                continue;
//            }
//            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//            dict[@"img"] = [NSString stringWithFormat:@"http:%@", d[2]];//http://titlepic.zgpingshu.com/918475b4d7657d4c085a42aab22a7d14.jpg
//            dict[@"url"] = [NSString stringWithFormat:@"http://m.zgpingshu.com%@", d[1]];
//            dict[@"title"] = d[3];
//            dict[@"des"] = d[5];
//
//            dict[@"hot"] = @([self matchString:r toRegexString:hotS].count);
//            dict[@"number"] = d[6];
//            dict[@"duration"] = d[7];
//            dict[@"bit"] = d[8];
//            dict[@"status"] = d[9];
//
//            [temps addObject:dict];
//
//        }
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            !(block)? : block(names);
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



@end

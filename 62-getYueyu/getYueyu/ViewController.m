//
//  ViewController.m
//  getYueyu
//
//  Created by czljcb on 2018/4/15.
//  Copyright © 2018年 czljcb. All rights reserved.
//

#import "ViewController.h"

#ifdef DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"%s\n",[[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(...)
#endif

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self test3];
    return;
    NSURL * url = [NSURL URLWithString:@"http://api.jiefu.tv/app2/api/dt/shareItem/newList.html?pageNum=2&pageSize=10000"];
    //创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    
    [request setValue:@"Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Mobile Safari/537.36" forHTTPHeaderField:@"User-Agent"];
    [request setValue:@"http://m.yueyuwz.com" forHTTPHeaderField:@"Origin"];
    
    //创建Session
    NSURLSession * session = [NSURLSession sharedSession];
    //创建任务
    NSURLSessionDataTask * task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
      NSDictionary *obj =  [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:NULL];
//        NSLog(@"%s", __func__);
        NSArray *array = [obj valueForKey:@"data"];
        [array enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSLog(@"@{@\"gifPath\":@\"%@\",@\"picPath\":@\"%@\",@\"id\":@\"%@\",@\"name\":@\"%@\"},",model[@"gifPath"],model[@"picPath"],model[@"id"],model[@"name"]);

        }];
        
        
        NSLog(@"%s", __func__);
        
        
    }];
    //开启网络任务
    [task resume];

    
    return;
    // Do any additional setup after loading the view, typically from a nib.
    
    //NSString *json = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://api.jiefu.tv/app2/api/dt/shareItem/newList.html?pageNum=0&pageSize=1000"] encoding:NSUTF8StringEncoding error:NULL];
    
    //NSError *error;
   //BOOL falg = [json writeToFile:@"users/czljcb/desktop/cz.json" atomically:YES encoding:NSUTF8StringEncoding error:&error];
    
//    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://api.jiefu.tv/app2/api/dt/shareItem/newList.html?pageNum=0&pageSize=1000"]];
//    [data writeToFile:@"users/czljcb/desktop/cz.json" atomically:YES];
//    NSLog(@"%s", __func__);
//    return;
    NSArray *lists = @[
//                       @{@"url":@"http://m.qingting.fm/channel/list/54",@"title":@"国家"},
//                       @{@"url":@"http://m.qingting.fm/channel/list/60",@"title":@"网络"},
//                       @{@"url":@"http://m.qingting.fm/channel/list/11",@"title":@"北京"},
//                       @{@"url":@"http://m.qingting.fm/channel/list/10",@"title":@"上海"},
//                       @{@"url":@"http://m.qingting.fm/channel/list/23",@"title":@"天津"},
//                       @{@"url":@"http://m.qingting.fm/channel/list/26",@"title":@"重庆"},
//                       @{@"url":@"http://m.qingting.fm/channel/list/22",@"title":@"广东"},
//                       @{@"url":@"http://m.qingting.fm/channel/list/19",@"title":@"浙江"},
//                       @{@"url":@"http://m.qingting.fm/channel/list/17",@"title":@"江苏"},
//                       @{@"url":@"http://m.qingting.fm/channel/list/20",@"title":@"湖南"},
//                       @{@"url":@"http://m.qingting.fm/channel/list/18",@"title":@"四川"},
//                       @{@"url":@"http://m.qingting.fm/channel/list/24",@"title":@"山西"},
//                       @{@"url":@"http://m.qingting.fm/channel/list/25",@"title":@"河南"},
//                       @{@"url":@"http://m.qingting.fm/channel/list/27",@"title":@"湖北"},
//                       @{@"url":@"http://m.qingting.fm/channel/list/28",@"title":@"黑龙江"},
//                       @{@"url":@"http://m.qingting.fm/channel/list/21",@"title":@"辽宁"},
//                       @{@"url":@"http://m.qingting.fm/channel/list/30",@"title":@"河北"},
//                       @{@"url":@"http://m.qingting.fm/channel/list/31",@"title":@"山东"},
//                       @{@"url":@"http://m.qingting.fm/channel/list/32",@"title":@"安徽"},
//                       @{@"url":@"http://m.qingting.fm/channel/list/34",@"title":@"福建"},
//                       @{@"url":@"http://m.qingting.fm/channel/list/36",@"title":@"广西"},
//                       @{@"url":@"http://m.qingting.fm/channel/list/37",@"title":@"贵州"},
//                       @{@"url":@"http://m.qingting.fm/channel/list/46",@"title":@"云南"},
//                       @{@"url":@"http://m.qingting.fm/channel/list/38",@"title":@"江西"},
//                       @{@"url":@"http://m.qingting.fm/channel/list/39",@"title":@"吉林"},
//                       @{@"url":@"http://m.qingting.fm/channel/list/33",@"title":@"甘肃"},
//                       @{@"url":@"http://m.qingting.fm/channel/list/51",@"title":@"陕西"},
//                       @{@"url":@"http://m.qingting.fm/channel/list/40",@"title":@"宁夏"},
//                       @{@"url":@"http://m.qingting.fm/channel/list/44",@"title":@"内蒙古"},
//                       @{@"url":@"http://m.qingting.fm/channel/list/43",@"title":@"海南"},
//                       @{@"url":@"http://m.qingting.fm/channel/list/42",@"title":@"西藏"},
//                       @{@"url":@"http://m.qingting.fm/channel/list/41",@"title":@"青海"},
                       @{@"url":@"http://m.qingting.fm/channel/list/45",@"title":@"新疆"},
                       ];
    
    
    
    
    [lists enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull pro, NSUInteger idx, BOOL * _Nonnull stop) {
        
        
        NSString *urlStr = pro[@"url"];
        
        NSString *html0 = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:urlStr] encoding:NSUTF8StringEncoding error:NULL];
        NSMutableArray *as = (NSMutableArray *)[html0 componentsSeparatedByString:@"</div>\n</div>"];
        [as removeLastObject];
        [as removeObjectAtIndex:0];
        
        [as enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSString *urlString = @"<a href=\"(.*?)\">";
            NSString *url = [NSString stringWithFormat:@"http://i.qingting.fm/wapi%@",[self matchString:obj toRegexString:urlString].lastObject];//[self matchString:obj toRegexString:urlString].lastObject;
            
            NSString *titleString = @"<p style=\"font-size:16px; color: #394148\">(.*?)</p>";
            NSString *title = [self matchString:obj toRegexString:titleString].lastObject;
            
            NSString *deschtml = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:NULL];
            
            NSString *desc = [self matchString:deschtml toRegexString:@"\"desc\":\"(.*?)\""].lastObject;
            
            
            
            //NSLog(@"@{@\"desc\":@\"%@\",@\"title\":@\"%@\"},",desc,title);
            NSLog(@"@\"%@\":@\"%@\",",title,desc);

            
        }];
        
        NSLog(@"%s----%@", __func__,pro[@"title"]);
    }];
    
    
    NSLog(@"%s---", __func__);
    
    return;
}



- (void)test2{
    NSString *urlStr = @"http://m.qingting.fm/category/list/9";
    NSString *html0 = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:urlStr] encoding:NSUTF8StringEncoding error:NULL];
    NSMutableArray *as = (NSMutableArray *)[html0 componentsSeparatedByString:@"</div>\n</div>"];
    [as removeLastObject];
    [as removeObjectAtIndex:0];
    
    [as enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *urlString = @"<a href=\"(.*?)\">";
        NSString *url = [NSString stringWithFormat:@"http://m.qingting.fm%@",[self matchString:obj toRegexString:urlString].lastObject];//[self matchString:obj toRegexString:urlString].lastObject;
        
        NSString *titleString = @"<h3>(.*?)</h3>";
        NSString *title = [self matchString:obj toRegexString:titleString].lastObject;
        
        NSLog(@"@{@\"url\":@\"%@\",@\"title\":@\"%@\"},",url,title);
        
    }];
    
    NSLog(@"%s---%@", __func__,html0);
    
}

//{
//    "img": "http://pic7.qiyipic.com/image/20180414/b3/38/a_100137605_m_601_m3_180_236.jpg",
//    "title": "泰语入门学习",
//    "type": "爱课堂",
//    "des": "喜欢记得点赞 留下你的专属评论哟 持续更新中...",
//    "language": "其它",
//    "vlist": [
//              {
//                  "vpic": "http://pic5.qiyipic.com/image/20180606/b2/e1/v_116549462_m_601.jpg",
//                  "shortTitle": "初恋这件小事",
//                  "vurl": "http://www.iqiyi.com/v_19rr0cmp7g.html",
//                ]
//}
- (NSString *)encodeToPercentEscapeString: (NSString *) input

{
    
    // Encode all the reserved characters, per RFC 3986
    
    // (<http://www.ietf.org/rfc/rfc3986.txt>)
    
    NSString *outputStr = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                                
                                                                                                (CFStringRef)input,
                                                                                                
                                                                                                NULL,
                                                                                                
                                                                                                (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                
                                                                                                kCFStringEncodingUTF8));
    
    return outputStr;
    
}


-(void)test3{
    NSString *url = @"http://www.iqiyi.com/playlist268438002.html";
    url = @"http://www.iqiyi.com/playlist405588902.html";
    url = @"http://www.iqiyi.com/u/2394136908/v";
    
    NSString *html = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:NULL];
    
    
    
    NSString *ul = [html componentsSeparatedByString:@"wrapper-piclist site-piclist site-piclist-180101 site-piclist-180101_indivi site-piclist-180101_threeline wrapper-piclist-auto "].lastObject;
    
    NSMutableArray *lis = (NSMutableArray *)[ul componentsSeparatedByString:@"<div class=\"site-piclist_pic\">"];
    [lis removeObjectAtIndex:0];
    
    
    NSMutableArray *objs = [NSMutableArray array];
    
    [lis enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *urlString = @"<a href=\"(.*?)\" class=\"site-piclist_pic_link";
        NSString *url = [self matchString:obj toRegexString:urlString].lastObject;
        
        NSString *titleString = @"title=\"(.*?)\" target=\"iqiyiblank\"";
        NSString *title = [self matchString:obj toRegexString:titleString].lastObject;
        title = [self encodeToPercentEscapeString:title];
        
//            NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        
//        NSData *data = [title dataUsingEncoding:enc];
//            NSString *retStr = [[NSString alloc] initWithData:data encoding:enc];
        


        //中文转unicode

        
        NSString *imgString = @"src=\"(.*?)\" alt";
        NSString *img = [self matchString:obj toRegexString:imgString].lastObject;
        
        NSString *timeString = @"mod-listTitle_right\">(.*?)<\/span>";
        NSString *time = [self matchString:obj toRegexString:timeString].lastObject;
        //NSString *countString = @"1341729209>(.*?)<\/em>";
        //NSString *count = [self matchString:obj toRegexString:countString].lastObject;
        
        [objs addObject:@{@"vurl":url,@"shortTitle":title,@"vpic":img}];
        //        NSLog(@"@{@\"vurl\":@\"%@\",@\"shortTitle\":@\"%@\",@\"vpic\":@\"%@\",@\"time\":@\"%@\"},",url,title ,img,time);
        
        //        NSLog(@"%s", __func__);
    }];
    
    NSData *date = [NSJSONSerialization dataWithJSONObject:objs options:NSJSONWritingPrettyPrinted error:NULL];
    NSString *json = [[NSString alloc] initWithData:date encoding:NSUTF8StringEncoding];
    NSLog(@"%@",json);
}

- (void)test{
    NSString *url = @"http://www.iqiyi.com/playlist268438002.html";
    url = @"http://www.iqiyi.com/playlist405588902.html";
//    url = @"http://www.iqiyi.com/u/1379702113/v";
    
    NSString *html = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:NULL];
    
    
    
    NSString *ul = [html componentsSeparatedByString:@"site-piclist site-piclist-180101 site-piclist-180101-twoLine clearfix"].lastObject;
    
    NSMutableArray *lis = (NSMutableArray *)[ul componentsSeparatedByString:@"</li>"];
    [lis removeLastObject];
    
    
    NSMutableArray *objs = [NSMutableArray array];
    
    [lis enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *urlString = @"<a href=\"(.*?)\" target=\"_blank\"";
        NSString *url = [self matchString:obj toRegexString:urlString].lastObject;
        
        NSString *titleString = @"title=\"(.*?)\">";
        NSString *title = [self matchString:obj toRegexString:titleString].lastObject;
        
        NSString *imgString = @"src=\"(.*?)\" alt";
        NSString *img = [self matchString:obj toRegexString:imgString].lastObject;
        
        NSString *timeString = @"mod-listTitle_right\">(.*?)<\/span>";
        NSString *time = [self matchString:obj toRegexString:timeString].lastObject;
        //NSString *countString = @"1341729209>(.*?)<\/em>";
        //NSString *count = [self matchString:obj toRegexString:countString].lastObject;
        
        [objs addObject:@{@"vurl":url,@"shortTitle":title,@"vpic":img}];
//        NSLog(@"@{@\"vurl\":@\"%@\",@\"shortTitle\":@\"%@\",@\"vpic\":@\"%@\",@\"time\":@\"%@\"},",url,title ,img,time);
        
        //        NSLog(@"%s", __func__);
    }];
    
    NSData *date = [NSJSONSerialization dataWithJSONObject:objs options:NSJSONWritingPrettyPrinted error:NULL];
    NSString *json = [[NSString alloc] initWithData:date encoding:NSUTF8StringEncoding];
    NSLog(@"%@",json);
    
}

- (NSArray *)matchString:(NSString *)string toRegexString:(NSString *)regexStr
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

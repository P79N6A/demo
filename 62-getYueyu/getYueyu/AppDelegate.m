//
//  AppDelegate.m
//  getYueyu
//
//  Created by czljcb on 2018/4/15.
//  Copyright © 2018年 czljcb. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSArray *s = @[
                   ///0
                   @[
                       @{@"url":@"http://www.iqiyi.com/w_19rqzv5n11.html?list=19rrmvbt0e",@"title":@"粤语学习 广东话学习 看电影学粤语49",@"img":@"http://u6.qiyipic.com/image/20140418/ae/3b/61/uv_565171805_m_601_m0_180_101.jpg",@"time":@"02:31"},
                       @{@"url":@"http://www.iqiyi.com/w_19rqzv5er1.html?list=19rrmvbt0e",@"title":@"粤语学习 广东话学习 看电影学粤语48",@"img":@"http://u6.qiyipic.com/image/20140418/36/d2/a8/uv_565172301_m_601_m0_180_101.jpg",@"time":@"02:35"},
                       @{@"url":@"http://www.iqiyi.com/w_19rqzv5ubx.html?list=19rrmvbt0e",@"title":@"粤语学习 广东话学习 看电影学粤语47",@"img":@"http://u8.qiyipic.com/image/20140418/a3/4d/7a/uv_565171371_m_601_m0_180_101.jpg",@"time":@"02:57"},
                       @{@"url":@"http://www.iqiyi.com/w_19rqzv7c81.html?list=19rrmvbt0e",@"title":@"粤语学习 广东话学习 看电影学粤语45",@"img":@"http://u6.qiyipic.com/image/20140418/99/69/ba/uv_565170316_m_601_m0_180_101.jpg",@"time":@"02:15"},
                       @{@"url":@"http://www.iqiyi.com/w_19rqzv5j75.html?list=19rrmvbt0e",@"title":@"粤语学习 广东话学习 看电影学粤语44",@"img":@"http://u4.qiyipic.com/image/20140418/d3/99/6d/uv_565172879_m_601_m0_180_101.jpg",@"time":@"02:55"},
                       @{@"url":@"http://www.iqiyi.com/w_19rqzv5tk9.html?list=19rrmvbt0e",@"title":@"粤语学习 广东话学习 看电影学粤语43",@"img":@"http://u9.qiyipic.com/image/20140418/ac/aa/7f/uv_565171105_m_601_m0_180_101.jpg",@"time":@"02:05"},
                       @{@"url":@"http://www.iqiyi.com/w_19rqzv7sk1.html?list=19rrmvbt0e",@"title":@"粤语学习 广东话学习 看电影学粤语42",@"img":@"http://u4.qiyipic.com/image/20140418/08/47/31/uv_565169170_m_601_m0_180_101.jpg",@"time":@"02:54"},
                       @{@"url":@"http://www.iqiyi.com/w_19rqzv7pjt.html?list=19rrmvbt0e",@"title":@"粤语学习 广东话学习 看电影学粤语41",@"img":@"http://u5.qiyipic.com/image/20140418/14/97/4f/uv_565169164_m_601_m0_180_101.jpg",@"time":@"02:18"},
                       @{@"url":@"http://www.iqiyi.com/w_19rqzv80e1.html?list=19rrmvbt0e",@"title":@"粤语学习 广东话学习 看电影学粤语40",@"img":@"http://u7.qiyipic.com/image/20140418/f4/7b/fc/uv_565168761_m_601_m0_180_101.jpg",@"time":@"02:46"},
                       @{@"url":@"http://www.iqiyi.com/w_19rqzv6r6h.html?list=19rrmvbt0e",@"title":@"粤语学习 广东话学习 看电影学粤语39",@"img":@"http://u0.qiyipic.com/image/20140418/e3/ee/52/uv_565168164_m_601_m0_180_101.jpg",@"time":@"02:58"},
                       @{@"url":@"http://www.iqiyi.com/w_19rqzv6rx1.html?list=19rrmvbt0e",@"title":@"粤语学习 广东话学习 看电影学粤语38",@"img":@"http://u5.qiyipic.com/image/20140418/03/c8/51/uv_565168112_m_601_m0_180_101.jpg",@"time":@"01:54"},
                       @{@"url":@"http://www.iqiyi.com/w_19rqzv6max.html?list=19rrmvbt0e",@"title":@"粤语学习 广东话学习 看电影学粤语37",@"img":@"http://u2.qiyipic.com/image/20140418/53/9b/68/uv_565167624_m_601_m0_180_101.jpg",@"time":@"02:39"},
                       @{@"url":@"http://www.iqiyi.com/w_19rqzv6xu1.html?list=19rrmvbt0e",@"title":@"粤语学习 广东话学习 看电影学粤语36",@"img":@"http://u1.qiyipic.com/image/20140418/16/e2/7b/uv_565167450_m_601_m0_180_101.jpg",@"time":@"03:10"},
                       @{@"url":@"http://www.iqiyi.com/w_19rqzv7l1p.html?list=19rrmvbt0e",@"title":@"粤语学习 广东话学习 看电影学粤语34",@"img":@"http://u8.qiyipic.com/image/20140418/31/61/20/uv_565169994_m_601_m0_180_101.jpg",@"time":@"03:57"},
                       @{@"url":@"http://www.iqiyi.com/w_19rqzv7005.html?list=19rrmvbt0e",@"title":@"粤语学习 广东话学习 看电影学粤语33",@"img":@"http://u9.qiyipic.com/image/20140418/b1/be/49/uv_565166059_m_601_m0_180_101.jpg",@"time":@"02:23"},
                       @{@"url":@"http://www.iqiyi.com/w_19rqzv797p.html?list=19rrmvbt0e",@"title":@"粤语学习 广东话学习 看电影学粤语32",@"img":@"http://u0.qiyipic.com/image/20140418/9e/4b/8c/uv_565165729_m_601_m0_180_101.jpg",@"time":@"02:43"},
                       @{@"url":@"http://www.iqiyi.com/w_19rqzv38q5.html?list=19rrmvbt0e",@"title":@"粤语学习 广东话学习 看电影学粤语31",@"img":@"http://u5.qiyipic.com/image/20140418/f3/55/be/uv_565165319_m_601_m0_180_101.jpg",@"time":@"02:52"},
                       @{@"url":@"http://www.iqiyi.com/w_19rqzv34ux.html?list=19rrmvbt0e",@"title":@"粤语学习 广东话学习 看电影学粤语30",@"img":@"http://u2.qiyipic.com/image/20140418/6d/68/e8/uv_565164654_m_601_m0_180_101.jpg",@"time":@"03:17"},
                       @{@"url":@"http://www.iqiyi.com/w_19rqzv6ohh.html?list=19rrmvbt0e",@"title":@"粤语学习 广东话学习 看电影学粤语29",@"img":@"http://u3.qiyipic.com/image/20140418/17/db/db/uv_565167737_m_601_m0_180_101.jpg",@"time":@"02:12"},
                       @{@"url":@"http://www.iqiyi.com/w_19rqzv3ctl.html?list=19rrmvbt0e",@"title":@"粤语学习 广东话学习 看电影学粤语28",@"img":@"http://u7.qiyipic.com/image/20140418/f2/51/0f/uv_565164194_m_601_m0_180_101.jpg",@"time":@"03:07"},
                       @{@"url":@"http://www.iqiyi.com/w_19rqzv3cp9.html?list=19rrmvbt0e",@"title":@"粤语学习 广东话学习 看电影学粤语27",@"img":@"http://u2.qiyipic.com/image/20140418/2e/ec/e1/uv_565164188_m_601_m0_180_101.jpg",@"time":@"02:56"},
                       @{@"url":@"http://www.iqiyi.com/w_19rqzv3m7l.html?list=19rrmvbt0e",@"title":@"粤语学习 广东话学习 看电影学粤语26",@"img":@"http://u9.qiyipic.com/image/20140418/20/b6/39/uv_565163849_m_601_m0_180_101.jpg",@"time":@"03:34"},
                       @{@"url":@"http://www.iqiyi.com/w_19rqzv73g5.html?list=19rrmvbt0e",@"title":@"粤语学习 广东话学习 看电影学粤语25",@"img":@"http://u4.qiyipic.com/image/20140418/75/fd/cc/uv_565166735_m_601_m0_180_101.jpg",@"time":@"02:51"},
                       @{@"url":@"http://www.iqiyi.com/w_19rqzxk37h.html?list=19rrmvbt0e",@"title":@"粤语学习 广东话学习 看电影学粤语24",@"img":@"http://u6.qiyipic.com/image/20140417/b2/84/9b/uv_564829365_m_601_m0_180_101.jpg",@"time":@"03:01"},
                       @{@"url":@"http://www.iqiyi.com/w_19rqzxk9dp.html?list=19rrmvbt0e",@"title":@"粤语学习 广东话学习 看电影学粤语23",@"img":@"http://u5.qiyipic.com/image/20140417/d9/87/fe/uv_564828800_m_601_m0_180_101.jpg",@"time":@"03:27"},
                       @{@"url":@"http://www.iqiyi.com/w_19rqzxk9s9.html?list=19rrmvbt0e",@"title":@"粤语学习 广东话学习 看电影学粤语21",@"img":@"http://u5.qiyipic.com/image/20140417/94/05/6e/uv_564828787_m_601_m0_180_101.jpg",@"time":@"02:49"},
                       @{@"url":@"http://www.iqiyi.com/w_19rqzxix0x.html?list=19rrmvbt0e",@"title":@"粤语学习 广东话学习 看电影学粤语20",@"img":@"http://u3.qiyipic.com/image/20140417/40/11/45/uv_564827681_m_601_m0_180_101.jpg",@"time":@"03:09"},
                       @{@"url":@"http://www.iqiyi.com/w_19rqzxj99p.html?list=19rrmvbt0e",@"title":@"粤语学习 广东话学习 看电影学粤语19",@"img":@"http://u6.qiyipic.com/image/20140417/63/37/4b/uv_564826540_m_601_m0_180_101.jpg",@"time":@"02:33"},
                       @{@"url":@"http://www.iqiyi.com/w_19rqzxjbsl.html?list=19rrmvbt0e",@"title":@"粤语学习 广东话学习 看电影学粤语18",@"img":@"http://u9.qiyipic.com/image/20140417/3b/87/87/uv_564826578_m_601_m0_180_101.jpg",@"time":@"03:21"},
                       @{@"url":@"http://www.iqiyi.com/w_19rqzxjhmh.html?list=19rrmvbt0e",@"title":@"粤语学习 广东话学习 看电影学粤语17",@"img":@"http://u3.qiyipic.com/image/20140417/d5/9e/08/uv_564826080_m_601_m0_180_101.jpg",@"time":@"02:01"},
                       @{@"url":@"http://www.iqiyi.com/w_19rqzybhj5.html?list=19rrmvbt0e",@"title":@"粤语学习 广东话学习 看电影学粤语16",@"img":@"http://u4.qiyipic.com/image/20140417/11/23/ad/uv_564774625_m_601_m0_180_101.jpg",@"time":@"02:46"},
                       @{@"url":@"http://www.iqiyi.com/w_19rqzybnu9.html?list=19rrmvbt0e",@"title":@"粤语学习 广东话学习 看电影学粤语15",@"img":@"http://u4.qiyipic.com/image/20140417/04/a8/93/uv_564774056_m_601_m0_180_101.jpg",@"time":@"02:39"},
                       @{@"url":@"http://www.iqiyi.com/w_19rqzybjxl.html?list=19rrmvbt0e",@"title":@"粤语学习 广东话学习 看电影学粤语14",@"img":@"http://u2.qiyipic.com/image/20140417/20/31/a3/uv_564773596_m_601_m0_180_101.jpg",@"time":@"03:06"},
                       @{@"url":@"http://www.iqiyi.com/w_19rqzy7m1x.html?list=19rrmvbt0e",@"title":@"粤语学习 广东话学习 看电影学粤语13",@"img":@"http://u2.qiyipic.com/image/20140417/4e/8e/c4/uv_564773554_m_601_m0_180_101.jpg",@"time":@"02:33"},
                       @{@"url":@"http://www.iqiyi.com/w_19rqzy7i1t.html?list=19rrmvbt0e",@"title":@"粤语学习 广东话学习 看电影学粤语12",@"img":@"http://u7.qiyipic.com/image/20140417/f3/55/9c/uv_564773078_m_601_m0_180_101.jpg",@"time":@"02:59"},
                       @{@"url":@"http://www.iqiyi.com/w_19rqzy7odl.html?list=19rrmvbt0e",@"title":@"粤语学习 广东话学习 看电影学粤语11",@"img":@"http://u8.qiyipic.com/image/20140417/f5/94/d8/uv_564772566_m_601_m0_180_101.jpg",@"time":@"02:21"},
                       @{@"url":@"http://www.iqiyi.com/w_19rqzy7vz9.html?list=19rrmvbt0e",@"title":@"粤语学习 广东话学习 看电影学粤语10",@"img":@"http://u6.qiyipic.com/image/20140417/c1/61/38/uv_564772201_m_601_m0_180_101.jpg",@"time":@"02:17"},
                       @{@"url":@"http://www.iqiyi.com/w_19rqzy83jd.html?list=19rrmvbt0e",@"title":@"粤语学习 广东话学习 看电影学粤语9",@"img":@"http://u9.qiyipic.com/image/20140417/d0/bc/cc/uv_564771799_m_601_m0_180_101.jpg",@"time":@"01:53"},
                       @{@"url":@"http://www.iqiyi.com/w_19rqzy83sx.html?list=19rrmvbt0e",@"title":@"粤语学习 广东话学习 看电影学粤语8",@"img":@"http://u0.qiyipic.com/image/20140417/02/da/d2/uv_564771758_m_601_m0_180_101.jpg",@"time":@"01:31"},
                       @{@"url":@"http://www.iqiyi.com/w_19rqzy6xhl.html?list=19rrmvbt0e",@"title":@"粤语学习 广东话学习 看电影学粤语7",@"img":@"http://u0.qiyipic.com/image/20140417/e5/f6/8f/uv_564771327_m_601_m0_180_101.jpg",@"time":@"01:25"},
                       @{@"url":@"http://www.iqiyi.com/w_19rqzy6xwd.html?list=19rrmvbt0e",@"title":@"粤语学习 广东话学习 看电影学粤语6",@"img":@"http://u4.qiyipic.com/image/20140417/59/63/75/uv_564771307_m_601_m0_180_101.jpg",@"time":@"01:55"},
                       @{@"url":@"http://www.iqiyi.com/w_19rqzy6vk9.html?list=19rrmvbt0e",@"title":@"粤语学习 广东话学习 看电影学粤语5",@"img":@"http://u2.qiyipic.com/image/20140417/a7/45/16/uv_564771251_m_601_m0_180_101.jpg",@"time":@"01:57"},
                       @{@"url":@"http://www.iqiyi.com/w_19rqzy79jt.html?list=19rrmvbt0e",@"title":@"粤语学习 广东话学习 看电影学粤语2",@"img":@"http://u0.qiyipic.com/image/20140417/e7/73/dd/uv_564770331_m_601_m0_180_101.jpg",@"time":@"03:14"},
                       @{@"url":@"http://www.iqiyi.com/w_19rqzy6ywt.html?list=19rrmvbt0e",@"title":@"粤语学习 广东话学习 看电影学粤语72",@"img":@"http://u7.qiyipic.com/image/20140417/be/83/ed/uv_564770426_m_601_m0_180_101.jpg",@"time":@"03:33"},
                       @{@"url":@"http://www.iqiyi.com/w_19rqzy7e2l.html?list=19rrmvbt0e",@"title":@"粤语学习 广东话学习 看电影学粤语71",@"img":@"http://u8.qiyipic.com/image/20140417/b7/1a/df/uv_564769704_m_601_m0_180_101.jpg",@"time":@"02:28"},
                       @{@"url":@"http://www.iqiyi.com/w_19rqzy7b6h.html?list=19rrmvbt0e",@"title":@"粤语学习 广东话学习 看电影学粤语70",@"img":@"http://u2.qiyipic.com/image/20140417/b8/b9/e8/uv_564769351_m_601_m0_180_101.jpg",@"time":@"02:19"},
                       @{@"url":@"http://www.iqiyi.com/w_19rqzy8wgl.html?list=19rrmvbt0e",@"title":@"粤语学习 广东话学习 看电影学粤语69",@"img":@"http://u0.qiyipic.com/image/20140417/ca/35/a6/uv_564768749_m_601_m0_180_101.jpg",@"time":@"03:11"},
                       @{@"url":@"http://www.iqiyi.com/w_19rqzy92x1.html?list=19rrmvbt0e",@"title":@"粤语学习 广东话学习 看电影学粤语67",@"img":@"http://u2.qiyipic.com/image/20140417/e8/c0/45/uv_564768161_m_601_m0_180_101.jpg",@"time":@"02:55"},
                       @{@"url":@"http://www.iqiyi.com/w_19rqzy92sd.html?list=19rrmvbt0e",@"title":@"粤语学习 广东话学习 看电影学粤语66",@"img":@"http://u1.qiyipic.com/image/20140417/07/c2/16/uv_564768173_m_601_m0_180_101.jpg",@"time":@"02:53"},
                       @{@"url":@"http://www.iqiyi.com/w_19rqzy8c85.html?list=19rrmvbt0e",@"title":@"粤语学习 广东话学习 看电影学粤语65",@"img":@"http://u2.qiyipic.com/image/20140417/a2/70/8a/uv_564766747_m_601_m0_180_101.jpg",@"time":@"02:32"},
                       @{@"url":@"http://www.iqiyi.com/w_19rqzy87qp.html?list=19rrmvbt0e",@"title":@"粤语学习 广东话学习 看电影学粤语63",@"img":@"http://u9.qiyipic.com/image/20140417/86/fe/3f/uv_564766120_m_601_m0_180_101.jpg",@"time":@"02:32"},
                       @{@"url":@"http://www.iqiyi.com/w_19rqzy8g9x.html?list=19rrmvbt0e",@"title":@"粤语学习 广东话学习 看电影学粤语62",@"img":@"http://u8.qiyipic.com/image/20140417/17/dc/da/uv_564765951_m_601_m0_180_101.jpg",@"time":@"02:32"},
                       @{@"url":@"http://www.iqiyi.com/w_19rqzy8ott.html?list=19rrmvbt0e",@"title":@"粤语学习 广东话学习 看电影学粤语61",@"img":@"http://u0.qiyipic.com/image/20140417/8e/9e/bc/uv_564765364_m_601_m0_180_101.jpg",@"time":@"02:47"},
                       @{@"url":@"http://www.iqiyi.com/w_19rqzy8kdd.html?list=19rrmvbt0e",@"title":@"粤语学习 广东话学习 看电影学粤语60",@"img":@"http://u5.qiyipic.com/image/20140417/2c/e8/5d/uv_564764661_m_601_m0_180_101.jpg",@"time":@"02:30"},
                       @{@"url":@"http://www.iqiyi.com/w_19rqzy8owx.html?list=19rrmvbt0e",@"title":@"粤语学习 广东话学习 看电影学粤语59",@"img":@"http://u8.qiyipic.com/image/20140417/fd/01/1b/uv_564765346_m_601_m0_180_101.jpg",@"time":@"03:10"},
                       @{@"url":@"http://www.iqiyi.com/w_19rqzy8s31.html?list=19rrmvbt0e",@"title":@"粤语学习 广东话学习 看电影学粤语58",@"img":@"http://u8.qiyipic.com/image/20140417/a6/29/72/uv_564763982_m_601_m0_180_101.jpg",@"time":@"03:11"},
                       @{@"url":@"http://www.iqiyi.com/w_19rqzy55mx.html?list=19rrmvbt0e",@"title":@"粤语学习 广东话学习 看电影学粤语57",@"img":@"http://u6.qiyipic.com/image/20140417/d4/5e/7d/uv_564762776_m_601_m0_180_101.jpg",@"time":@"02:17"},
                       @{@"url":@"http://www.iqiyi.com/w_19rqzy4vf1.html?list=19rrmvbt0e",@"title":@"粤语学习 广东话学习 看电影学粤语55",@"img":@"http://u3.qiyipic.com/image/20140417/be/94/db/uv_564762818_m_601_m0_180_101.jpg",@"time":@"02:53"},
                       @{@"url":@"http://www.iqiyi.com/w_19rqzy566d.html?list=19rrmvbt0e",@"title":@"粤语学习 广东话学习 看电影学粤语54",@"img":@"http://u6.qiyipic.com/image/20140417/85/1a/78/uv_564762734_m_601_m0_180_101.jpg",@"time":@"03:02"},
                       @{@"url":@"http://www.iqiyi.com/w_19rqzy42a9.html?list=19rrmvbt0e",@"title":@"粤语学习 广东话学习 看电影学粤语53",@"img":@"http://u0.qiyipic.com/image/20140417/28/be/b9/uv_564761630_m_601_m0_180_101.jpg",@"time":@"02:34"},
                       @{@"url":@"http://www.iqiyi.com/w_19rqzy443x.html?list=19rrmvbt0e",@"title":@"粤语学习 广东话学习 看电影学粤语51",@"img":@"http://u0.qiyipic.com/image/20140417/f2/0d/11/uv_564761722_m_601_m0_180_101.jpg",@"time":@"02:36"},
                       @{@"url":@"http://www.iqiyi.com/w_19rqzy4g0x.html?list=19rrmvbt0e",@"title":@"粤语学习 广东话学习 看电影学粤语50",@"img":@"http://u5.qiyipic.com/image/20140417/0b/32/1d/uv_564759397_m_601_m0_180_101.jpg",@"time":@"02:42"}
                       ],
                   ///1
                   @[
                       @{@"url":@"http://www.iqiyi.com/w_19rrchsl5t.html?list=19rrmvbt0e",@"title":@"广东话学习 广东话教程 学习篇",@"img":@"http://u7.qiyipic.com/image/20140224/f7/46/1c/uv_540496362_m_601_m1_180_101.jpg",@"time":@"12:17"},
                       @{@"url":@"http://www.iqiyi.com/w_19rrchuill.html?list=19rrmvbt0e",@"title":@"广东话学习 广东话教程 问候篇",@"img":@"http://u3.qiyipic.com/image/20140224/95/1c/d2/uv_540494865_m_601_m1_180_101.jpg",@"time":@"07:56"},
                       @{@"url":@"http://www.iqiyi.com/w_19rrchskot.html?list=19rrmvbt0e",@"title":@"广东话学习 广东话教程 时间篇",@"img":@"http://u7.qiyipic.com/image/20140224/f0/18/9f/uv_540496421_m_601_m1_180_101.jpg",@"time":@"09:40"},
                       @{@"url":@"http://www.iqiyi.com/w_19rrchthd5.html?list=19rrmvbt0e",@"title":@"广东话学习 广东话教程 思想感情",@"img":@"http://u7.qiyipic.com/image/20140224/0a/fb/96/uv_540497855_m_601_m1_180_101.jpg",@"time":@"15:13"},
                       @{@"url":@"http://www.iqiyi.com/w_19rrchuue1.html?list=19rrmvbt0e",@"title":@"广东话学习 广东话教程 声韵调学习资料",@"img":@"http://u9.qiyipic.com/image/20140224/51/6e/dd/uv_540493659_m_601_m1_180_101.jpg",@"time":@"04:52"},
                       @{@"url":@"http://www.iqiyi.com/w_19rrchtywd.html?list=19rrmvbt0e",@"title":@"广东话学习 广东话教程 生活用品",@"img":@"http://u0.qiyipic.com/image/20140224/a2/a4/5a/uv_540492099_m_601_m1_180_101.jpg",@"time":@"12:58"},
                       @{@"url":@"http://www.iqiyi.com/w_19rrck0oqp.html?list=19rrmvbt0e",@"title":@"广东话学习 广东话教程 社交常用词汇",@"img":@"http://u6.qiyipic.com/image/20140223/b2/c7/5b/uv_540198357_m_601_m1_180_101.jpg",@"time":@"08:55"},
                       @{@"url":@"http://www.iqiyi.com/w_19rrck0hj9.html?list=19rrmvbt0e",@"title":@"广东话学习 广东话教程 社交篇",@"img":@"http://u4.qiyipic.com/image/20140223/aa/4d/7e/uv_540198702_m_601_m1_180_101.jpg",@"time":@"08:41"},
                       @{@"url":@"http://www.iqiyi.com/w_19rrcz92e9.html?list=19rrmvbt0e",@"title":@"广东话学习 广东话教程 舌尖上的粤语",@"img":@"http://u6.qiyipic.com/image/20140221/ac/27/44/uv_539636369_m_601_m3_180_101.jpg",@"time":@"02:39"},
                       @{@"url":@"http://www.iqiyi.com/w_19rrck1gxt.html?list=19rrmvbt0e",@"title":@"广东话学习 广东话教程 拼音入门",@"img":@"http://u9.qiyipic.com/image/20140223/ef/28/de/uv_540199665_m_601_m1_180_101.jpg",@"time":@"1:11:28"},
                       @{@"url":@"http://www.iqiyi.com/w_19rrcywj7h.html?list=19rrmvbt0e",@"title":@"广东话学习 广东话教程 交往篇",@"img":@"http://u2.qiyipic.com/image/20140221/4a/61/d5/uv_539573286_m_601_m1_180_101.jpg",@"time":@"14:00"},
                       @{@"url":@"http://www.iqiyi.com/w_19rrczgo4h.html?list=19rrmvbt0e",@"title":@"广东话学习 广东话教程 交通篇",@"img":@"http://u8.qiyipic.com/image/20140221/7a/c6/b8/uv_539438208_m_601_m1_180_101.jpg",@"time":@"10:08"},
                       @{@"url":@"http://www.iqiyi.com/w_19rrczgqnp.html?list=19rrmvbt0e",@"title":@"广东话学习 广东话教程 见面打招呼",@"img":@"http://u5.qiyipic.com/image/20140221/76/c7/99/uv_539438319_m_601_m1_180_101.jpg",@"time":@"09:19"},
                       @{@"url":@"http://www.iqiyi.com/w_19rrd009ph.html?list=19rrmvbt0e",@"title":@"广东话学习 广东话教程 购物篇",@"img":@"http://u2.qiyipic.com/image/20140221/ae/d3/98/uv_539534506_m_601_m1_180_101.jpg",@"time":@"10:48"},
                       @{@"url":@"http://www.iqiyi.com/w_19rrcz8zid.html?list=19rrmvbt0e",@"title":@"广东话学习 广东话教程 工作交际",@"img":@"http://u1.qiyipic.com/image/20140221/9f/2e/31/uv_539636348_m_601_m3_180_101.jpg",@"time":@"16:47"},
                       @{@"url":@"http://www.iqiyi.com/w_19rrczh4xt.html?list=19rrmvbt0e",@"title":@"广东话学习 广东话教程 副词虚词",@"img":@"http://u0.qiyipic.com/image/20140221/29/d5/31/uv_539436806_m_601_m1_180_101.jpg",@"time":@"11:21"},
                       @{@"url":@"http://www.iqiyi.com/w_19rrczgwzh.html?list=19rrmvbt0e",@"title":@"广东话学习 广东话教程 风俗篇",@"img":@"http://u0.qiyipic.com/image/20140221/f3/1f/3b/uv_539437452_m_601_m1_180_101.jpg",@"time":@"14:30"},
                       @{@"url":@"http://www.iqiyi.com/w_19rrczhand.html?list=19rrmvbt0e",@"title":@"广东话学习 广东话教程 动物植物",@"img":@"http://u6.qiyipic.com/image/20140221/44/68/2c/uv_539436048_m_601_m1_180_101.jpg",@"time":@"14:45"},
                       @{@"url":@"http://www.iqiyi.com/w_19rrcztk6h.html?list=19rrmvbt0e",@"title":@"广东话学习 广东话教程 第15章",@"img":@"http://u3.qiyipic.com/image/20140221/ea/81/6e/uv_539506373_m_601_m5_180_101.jpg",@"time":@"01:51"},
                       @{@"url":@"http://www.iqiyi.com/w_19rrd0m6y5.html?list=19rrmvbt0e",@"title":@"广东话学习 广东话教程 第11章",@"img":@"http://u1.qiyipic.com/image/20140221/48/28/23/uv_539435259_m_601_m1_180_101.jpg",@"time":@"01:28"},
                       @{@"url":@"http://www.iqiyi.com/w_19rrcztyfx.html?list=19rrmvbt0e",@"title":@"广东话学习 广东话教程 代词名称",@"img":@"http://u6.qiyipic.com/image/20140221/51/f8/36/uv_539505038_m_601_m11_180_101.jpg",@"time":@"18:20"},
                       @{@"url":@"http://www.iqiyi.com/w_19rrd0m835.html?list=19rrmvbt0e",@"title":@"广东话学习 广东话教程 出行篇",@"img":@"http://u1.qiyipic.com/image/20140221/08/ad/ef/uv_539435103_m_601_m1_180_101.jpg",@"time":@"08:50"},
                       @{@"url":@"http://www.iqiyi.com/w_19rrd0m421.html?list=19rrmvbt0e",@"title":@"广东话学习 广东话教程 称赞BB仔",@"img":@"http://u3.qiyipic.com/image/20140221/ff/a4/b5/uv_539434803_m_601_m1_180_101.jpg",@"time":@"03:53"},
                       @{@"url":@"http://www.iqiyi.com/w_19rrcz88wd.html?list=19rrmvbt0e",@"title":@"广东话学习 广东话教程 80个常用字汇总",@"img":@"http://u2.qiyipic.com/image/20140221/a6/d2/bc/uv_539633269_m_601_m1_180_101.jpg",@"time":@"24:45"},
                       @{@"url":@"http://www.iqiyi.com/w_19rrd0m3yx.html?list=19rrmvbt0e",@"title":@"广东话学习 广东话教程 80个常用字",@"img":@"http://u7.qiyipic.com/image/20140221/13/ad/65/uv_539434867_m_601_m1_180_101.jpg",@"time":@"24:45"},
                       @{@"url":@"http://www.iqiyi.com/w_19rrd0mng5.html?list=19rrmvbt0e",@"title":@"广东话学习 广东话教程 作业系列第7章",@"img":@"http://u2.qiyipic.com/image/20140221/4a/7b/f8/uv_539432277_m_601_m1_180_101.jpg",@"time":@"01:41"},
                       @{@"url":@"http://www.iqiyi.com/w_19rrd0lhf1.html?list=19rrmvbt0e",@"title":@"广东话学习 广东话教程 作业系列03",@"img":@"http://u8.qiyipic.com/image/20140221/45/5c/00/uv_539431537_m_601_m1_180_101.jpg",@"time":@"01:22"},
                       @{@"url":@"http://www.iqiyi.com/w_19rrcz75qh.html?list=19rrmvbt0e",@"title":@"广东话学习 广东话教程 最新最全速成秘笈2",@"img":@"http://u4.qiyipic.com/image/20140221/b8/2e/41/uv_539639977_m_601_m1_180_101.jpg",@"time":@"49:48"},
                       @{@"url":@"http://www.iqiyi.com/w_19rrd0lokx.html?list=19rrmvbt0e",@"title":@"广东话学习 广东话教程 最新提高课视频教材",@"img":@"http://u9.qiyipic.com/image/20140221/40/da/2f/uv_539431053_m_601_m1_180_101.jpg",@"time":@"12:33"},
                       @{@"url":@"http://www.iqiyi.com/w_19rrcyy5sd.html?list=19rrmvbt0e",@"title":@"广东话学习 广东话教程 娱乐篇",@"img":@"http://u9.qiyipic.com/image/20140221/ec/e4/d2/uv_539564245_m_601_m1_180_101.jpg",@"time":@"10:23"},
                       @{@"url":@"http://www.iqiyi.com/w_19rrc1f6ed.html?list=19rrmvbt0e",@"title":@"广东话学习 广东话教程 怎样称呼别人 学广东话",@"img":@"http://u0.qiyipic.com/image/20140215/d4/65/f5/uv_536584414_m_601_m1_180_101.jpg",@"time":@"18:43"},
                       @{@"url":@"http://www.iqiyi.com/w_19rrc1fhs9.html?list=19rrmvbt0e",@"title":@"广东话学习 广东话教程 有关买股票的知识 学广东话",@"img":@"http://u2.qiyipic.com/image/20140215/09/4e/77/uv_536582869_m_601_m1_180_101.jpg",@"time":@"02:14"},
                       @{@"url":@"http://www.iqiyi.com/w_19rrc1fl01.html?list=19rrmvbt0e",@"title":@"广东话学习 广东话教程 银行用语 学广东话",@"img":@"http://u6.qiyipic.com/image/20140215/23/a6/65/uv_536583282_m_601_m1_180_101.jpg",@"time":@"10:28"},
                       @{@"url":@"http://www.iqiyi.com/w_19rrc1fkql.html?list=19rrmvbt0e",@"title":@"广东话学习 广东话教程 问候语的用法 学广东话",@"img":@"http://u0.qiyipic.com/image/20140215/ec/24/f3/uv_536582892_m_601_m1_180_101.jpg",@"time":@"03:28"},
                       @{@"url":@"http://www.iqiyi.com/w_19rrccthx5.html?list=19rrmvbt0e",@"title":@"广东话学习 广东话教程 天气气候的说法 学广东话",@"img":@"http://u6.qiyipic.com/image/20140214/7a/87/c9/uv_536357335_m_601_m4_180_101.jpg",@"time":@"31:50"},
                       @{@"url":@"http://www.iqiyi.com/w_19rrccwsf9.html?list=19rrmvbt0e",@"title":@"广东话学习 广东话教程 数字和单位的说法 学广东话",@"img":@"http://u8.qiyipic.com/image/20140214/d3/f7/78/uv_536360654_m_601_m1_180_101.jpg",@"time":@"10:46"},
                       @{@"url":@"http://www.iqiyi.com/w_19rrc1qff5.html?list=19rrmvbt0e",@"title":@"广东话学习 广东话教程 如何表达时间 学广东话",@"img":@"http://u6.qiyipic.com/image/20140214/13/09/97/uv_536379498_m_601_m1_180_101.jpg",@"time":@"20:01"},
                       @{@"url":@"http://www.iqiyi.com/w_19rrccp2fx.html?list=19rrmvbt0e",@"title":@"广东话学习 广东话教程 日常简单交际用语 学广东话",@"img":@"http://u2.qiyipic.com/image/20140214/66/cb/a8/uv_536331401_m_601_m1_180_101.jpg",@"time":@"13:46"},
                       @{@"url":@"http://www.iqiyi.com/w_19rrccoqx9.html?list=19rrmvbt0e",@"title":@"广东话学习 广东话教程 去银行必须学会的词语 学广东?",@"img":@"http://u0.qiyipic.com/image/20140214/5d/13/f2/uv_536327299_m_601_m1_180_101.jpg",@"time":@"08:01"},
                       @{@"url":@"http://www.iqiyi.com/w_19rrccl33d.html?list=19rrmvbt0e",@"title":@"广东话学习 广东话教程 去银行办事的对话 学广东话",@"img":@"http://u4.qiyipic.com/image/20140214/87/2e/0b/uv_536324746_m_601_m1_180_101.jpg",@"time":@"02:45"},
                       @{@"url":@"http://www.iqiyi.com/w_19rrccoz55.html?list=19rrmvbt0e",@"title":@"广东话学习 广东话教程 去饭店应该说什么 学广东话",@"img":@"http://u6.qiyipic.com/image/20140214/58/ff/90/uv_536326661_m_601_m1_180_101.jpg",@"time":@"16:07"},
                       @{@"url":@"http://www.iqiyi.com/w_19rrccmdpt.html?list=19rrmvbt0e",@"title":@"广东话学习 广东话教程 节日祝福语 学广东话",@"img":@"http://u2.qiyipic.com/image/20140214/d6/b5/24/uv_536319537_m_601_m1_180_101.jpg",@"time":@"10:23"},
                       @{@"url":@"http://www.iqiyi.com/w_19rrccka2l.html?list=19rrmvbt0e",@"title":@"广东话学习 广东话教程 交通运输词汇 学广东话",@"img":@"http://u3.qiyipic.com/image/20140214/0d/3c/e6/uv_536322802_m_601_m1_180_101.jpg",@"time":@"36:48"},
                       @{@"url":@"http://www.iqiyi.com/w_19rrccml2d.html?list=19rrmvbt0e",@"title":@"广东话学习 广东话教程 家人亲戚的称呼 学广东话",@"img":@"http://u8.qiyipic.com/image/20140214/2f/03/af/uv_536317256_m_601_m1_180_101.jpg",@"time":@"19:52"},
                       @{@"url":@"http://www.iqiyi.com/w_19rrcf7f2h.html?list=19rrmvbt0e",@"title":@"广东话学习 广东话教程 广州地名的说法 学广东话",@"img":@"http://u8.qiyipic.com/image/20140213/a4/e8/78/uv_535853793_m_601_180_101.jpg",@"time":@"10:51"},
                       @{@"url":@"http://www.iqiyi.com/w_19rrcfabut.html?list=19rrmvbt0e",@"title":@"广东话学习 广东话教程 关于饮食的词语 学广东话",@"img":@"http://u1.qiyipic.com/image/20140213/5a/82/01/uv_535865201_m_601_m1_180_101.jpg",@"time":@"12:05"},
                       @{@"url":@"http://www.iqiyi.com/w_19rrcg2bw1.html?list=19rrmvbt0e",@"title":@"广东话学习 广东话教程 关于饮食的词语 2 学广东话",@"img":@"http://u6.qiyipic.com/image/20140213/82/72/5c/uv_535795767_m_601_m1_180_101.jpg",@"time":@"21:20"},
                       @{@"url":@"http://www.iqiyi.com/w_19rrcg2axx.html?list=19rrmvbt0e",@"title":@"广东话学习 广东话教程 关于医药的词语2 学广东话",@"img":@"http://u4.qiyipic.com/image/20140213/ce/06/ea/uv_535795538_m_601_m3_180_101.jpg",@"time":@"17:44"},
                       @{@"url":@"http://www.iqiyi.com/w_19rrcg2bm9.html?list=19rrmvbt0e",@"title":@"广东话学习 广东话教程 关于医药的词语 学广东话",@"img":@"http://u3.qiyipic.com/image/20140213/c7/fb/96/uv_535795447_m_601_m3_180_101.jpg",@"time":@"13:15"},
                       @{@"url":@"http://www.iqiyi.com/w_19rrcf4lbt.html?list=19rrmvbt0e",@"title":@"广东话学习 广东话教程 关于通信方式的词语2 学广东话",@"img":@"http://u9.qiyipic.com/image/20140213/8c/13/f1/uv_535842761_m_601_m1_180_101.jpg",@"time":@"15:54"},
                       @{@"url":@"http://www.iqiyi.com/w_19rrcg2gx1.html?list=19rrmvbt0e",@"title":@"广东话学习 广东话教程 关于通信方式的词语 学广东话",@"img":@"http://u2.qiyipic.com/image/20140213/da/e7/63/uv_535794869_m_601_m1_180_101.jpg",@"time":@"09:40"},
                       @{@"url":@"http://www.iqiyi.com/w_19rrcf0xoh.html?list=19rrmvbt0e",@"title":@"广东话学习 广东话教程 关于听音乐的对话 学广东话",@"img":@"http://u5.qiyipic.com/image/20140213/0b/72/20/uv_535827487_m_601_m1_180_101.jpg",@"time":@"02:33"},
                       @{@"url":@"http://www.iqiyi.com/w_19rrcf9s3t.html?list=19rrmvbt0e",@"title":@"广东话学习 广东话教程 关于就学方面的词语2 学广东话",@"img":@"http://u7.qiyipic.com/image/20140213/eb/06/a3/uv_535867083_m_601_m1_180_101.jpg",@"time":@"19:15"},
                       @{@"url":@"http://www.iqiyi.com/w_19rrcgmo71.html?list=19rrmvbt0e",@"title":@"广东话学习 广东话教程 关于就学方面的词语 学广东话",@"img":@"http://u5.qiyipic.com/image/20140212/31/a8/22/uv_535654357_m_601_m1_180_101.jpg",@"time":@"15:37"},
                       @{@"url":@"http://www.iqiyi.com/w_19rrcgjjsd.html?list=19rrmvbt0e",@"title":@"广东话学习 广东话教程 关于健身的对话 学广东话",@"img":@"http://u2.qiyipic.com/image/20140212/47/bf/28/uv_535642719_m_601_m1_180_101.jpg",@"time":@"02:35"},
                       @{@"url":@"http://www.iqiyi.com/w_19rrcgopjh.html?list=19rrmvbt0e",@"title":@"广东话学习 广东话教程 购物用语的说法 学广东话",@"img":@"http://u3.qiyipic.com/image/20140212/a0/9c/c2/uv_535649863_m_601_m1_180_101.jpg",@"time":@"16:22"},
                       @{@"url":@"http://www.iqiyi.com/w_19rrcgkwxx.html?list=19rrmvbt0e",@"title":@"广东话学习 广东话教程 购买家具家电词语 学广东话",@"img":@"http://u2.qiyipic.com/image/20140212/54/ab/9e/uv_535636936_m_601_m1_180_101.jpg",@"time":@"06:51"},
                       @{@"url":@"http://www.iqiyi.com/w_19rrcgm00d.html?list=19rrmvbt0e",@"title":@"广东话学习 广东话教程 兑换外币的对话 学广东话",@"img":@"http://u7.qiyipic.com/image/20140212/41/c6/4e/uv_535638571_m_601_m1_180_101.jpg",@"time":@"02:38"},
                       @{@"url":@"http://www.iqiyi.com/w_19rrcgl7d1.html?list=19rrmvbt0e",@"title":@"广东话学习 广东话教程 常用祝福用语 学广东话",@"img":@"http://u7.qiyipic.com/image/20140212/db/58/f6/uv_535635550_m_601_m1_180_101.jpg",@"time":@"09:13"},
                       @{@"url":@"http://www.iqiyi.com/w_19rrcg5c85.html?list=19rrmvbt0e",@"title":@"广东话学习 广东话教程 关于过春节的对话 学广东话",@"img":@"http://u9.qiyipic.com/image/20140212/2b/a2/8d/uv_535574440_m_601_m1_180_101.jpg",@"time":@"01:49"},
                       @{@"url":@"http://www.iqiyi.com/w_19rrcg9vi9.html?list=19rrmvbt0e",@"title":@"广东话学习 广东话教程 关于工作方面的词语 学广东话",@"img":@"http://u3.qiyipic.com/image/20140212/e4/08/df/uv_535594510_m_601_m1_180_101.jpg",@"time":@"24:50"},
                       @{@"url":@"http://www.iqiyi.com/w_19rrcgcrmx.html?list=19rrmvbt0e",@"title":@"广东话学习 广东话教程 购物之日用百货 学广东话",@"img":@"http://u0.qiyipic.com/image/20140212/75/44/da/uv_535603615_m_601_m1_180_101.jpg",@"time":@"16:12"},
                       @{@"url":@"http://www.iqiyi.com/w_19rrcg5g25.html?list=19rrmvbt0e",@"title":@"广东话学习 广东话教程 购物之美食部分 学广东话",@"img":@"http://u8.qiyipic.com/image/20140212/11/42/29/uv_535589775_m_601_m2_180_101.jpg",@"time":@"10:44"},
                       @{@"url":@"http://www.iqiyi.com/w_19rrcg690d.html?list=19rrmvbt0e",@"title":@"广东话学习 广东话教程 购物之家具家电 学广东话",@"img":@"http://u4.qiyipic.com/image/20140212/96/7b/87/uv_535591446_m_601_m1_180_101.jpg",@"time":@"16:00"},
                       ],
                   ///2
                   @[
                       @{@"url":@"http://www.iqiyi.com/w_19rsfge4yp.html?list=19rrkmnave",@"title":@"学说香港话，学说广东话 -1",@"img":@"http://u9.qiyipic.com/image/20140629/08/88/uv_3000409478_m_601_m1_180_101.jpg",@"time":@"19:53"},
                       @{@"url":@"http://www.iqiyi.com/w_19rsfrpb41.html?list=19rrkmnave",@"title":@"学说香港话，学说广东话 - 2",@"img":@"http://u6.qiyipic.com/image/20150421/16/a5/uv_602697253_m_601_m2_180_101.jpg",@"time":@"18:44"},
                       @{@"url":@"http://www.iqiyi.com/w_19rsfrnvyd.html?list=19rrkmnave",@"title":@"学说香港话，学说广东话 - 9",@"img":@"http://u3.qiyipic.com/image/20140629/b6/69/uv_602698512_m_601_m1_180_101.jpg",@"time":@"16:22"},
                       @{@"url":@"http://www.iqiyi.com/w_19rsfgamd1.html?list=19rrkmnave",@"title":@"学说香港话，学说广东话 - 10",@"img":@"http://u3.qiyipic.com/image/20140629/d7/5f/uv_3000409010_m_601_m1_180_101.jpg",@"time":@"16:13"},
                       @{@"url":@"http://www.iqiyi.com/w_19rsfgm895.html?list=19rrkmnave",@"title":@"学说香港话，学说广东话 - 13",@"img":@"http://u1.qiyipic.com/image/20140629/ca/d1/uv_602744240_m_601_m1_180_101.jpg",@"time":@"16:08"},
                       @{@"url":@"http://www.iqiyi.com/w_19rsfgfgdp.html?list=19rrkmnave",@"title":@"学说香港话，学说广东话 - 15",@"img":@"http://u2.qiyipic.com/image/20140629/bf/45/uv_3000412699_m_601_m1_180_101.jpg",@"time":@"16:01"},
                       @{@"url":@"http://www.iqiyi.com/w_19rsfgpoil.html?list=19rrkmnave",@"title":@"学说香港话，学说广东话 - 18",@"img":@"http://u5.qiyipic.com/image/20140629/ab/90/uv_602745205_m_601_m1_180_101.jpg",@"time":@"21:21"},
                       @{@"url":@"http://www.iqiyi.com/w_19rsfrktqh.html?list=19rrkmnave",@"title":@"学说香港话，学说广东话 - 20",@"img":@"http://u1.qiyipic.com/image/20140629/4b/dd/uv_602691870_m_601_m1_180_101.jpg",@"time":@"17:45"},
                       @{@"url":@"http://www.iqiyi.com/w_19rsfrxxph.html?list=19rrkmnave",@"title":@"学说香港话，学说广东话 - 24",@"img":@"http://u3.qiyipic.com/image/20140629/c8/dc/uv_602703964_m_601_m1_180_101.jpg",@"time":@"19:15"},
                       @{@"url":@"http://www.iqiyi.com/w_19rsfgixpl.html?list=19rrkmnave",@"title":@"学说香港话，学说广东话 - 26",@"img":@"http://u8.qiyipic.com/image/20140629/ba/4e/uv_3000415580_m_601_m1_180_101.jpg",@"time":@"24:52"},
                       ],
                   ///3
                   @[
                       ],
                   ];
    
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end

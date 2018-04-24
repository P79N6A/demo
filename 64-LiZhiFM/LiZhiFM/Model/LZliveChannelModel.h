//
//  LZliveChannelModel.h
//  LiZhiFM
//
//  Created by czljcb on 2018/4/21.
//  Copyright © 2018年 czljcb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LZStreamModel : NSObject
@property (nonatomic, copy) NSString *bitstreamType;
@property (nonatomic, copy) NSString *resolution;
@property (nonatomic, copy) NSString *url;

@end

@interface LZliveChannelModel : NSObject
//{
//    "id": "1",
//    "name": "中国之声",
//    "channelPage": "1",
//    "img": "http://www.radio.cn/img/default/2014/9/18/1411025486781.jpg",
//    "streams": [
//                {
//                    "bitstreamType": "",
//                    "resolution": "H",
//                    "url": "http://ngcdn001.cnr.cn/live/zgzs/index.m3u8"
//                },
//                {
//                    "bitstreamType": "",
//                    "resolution": "M",
//                    "url": "http://ngcdn001.cnr.cn/live/zgzs48/index.m3u8"
//                },
//                {
//                    "bitstreamType": "",
//                    "resolution": "L",
//                    "url": "http://ngcdn001.cnr.cn/live/zgzs48/index.m3u8"
//                }
//                ],
//    "shareUrl": "http://share.radio.cn/app_share_template/zhibo/zhibo.html?channelId=1",
//    "liveSectionName": "央广新闻 ",
//    "commentId": "180421819845",
//    "isCollect": "0"
//}

@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *liveSectionName;
@property (nonatomic, strong) NSArray <LZStreamModel *>*streams;
@property (nonatomic, copy) NSString *live_stream;
@property (nonatomic, copy) NSString *key;
@end

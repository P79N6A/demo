//
//  MUViewController.m
//  rmtpm3u8
//
//  Created by 何川 on 2018/3/20.
//  Copyright © 2018年 何川. All rights reserved.
//

#import "MUViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "ZFPlayerView.h"

#import "PlayViewController.h"
#import "TVmodel.h"

@interface MUViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;

@property(nonatomic,strong) NSMutableArray *itmeArray;

@end

@implementation MUViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

-(void)setupUI{
    self.title = @"选择频道";
    self.view.backgroundColor = kbackground;
    
    [self.view addSubview:self.tableView];
    [self makeData];
    
    
}

-(void)makeData{
    NSString *path  = [[NSBundle mainBundle] pathForResource:@"modelT" ofType:@"txt"];
    NSError *error = nil;
    NSString *contstring = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    NSLog(@"%@",error);
    NSArray *contentarray = [contstring componentsSeparatedByString:@"\n"] ;
    NSMutableArray *muttemparr = [NSMutableArray arrayWithCapacity:contentarray.count];
    for (NSString *itmestring in contentarray) {
        NSArray *getarr = [itmestring componentsSeparatedByString:@","];
        TVmodel *model = [[TVmodel alloc] init];
        model.title = [[getarr firstObject] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        model.urlString = [[getarr lastObject] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        [muttemparr addObject:model];
    }
    _itmeArray = [muttemparr copy];
//    _itmeArray = contentarray;
//    TVmodel *model = [[TVmodel alloc] init];
//    model.title = @"日本电视台";
//    model.urlString = @"http://218.60.94.32:1935/live/bs17.stream/playlist.m3u8";
//    _itmeArray = @[model];
    [self.tableView reloadData];
   
    
    
    
}

-(UITableView*)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavH, kScreenW, kScreenH - kNavH - kBottomBarHeight)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorColor = k333;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
        _tableView.tableFooterView = [UIView new];
        
    }
    return _tableView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _itmeArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CELL"];
        cell.textLabel.textColor = k333;

    }
    if (indexPath.row < _itmeArray.count) {
        TVmodel *model = _itmeArray[indexPath.row];
        cell.textLabel.text = model.title;
        
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < _itmeArray.count) {
        TVmodel *model = _itmeArray[indexPath.row];
        PlayViewController *vc = [[PlayViewController alloc] init];
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (editingStyle) {
        case UITableViewCellEditingStyleNone:
        {
        }
            break;
        case UITableViewCellEditingStyleDelete:
        {
            //修改数据源，在刷新 tableView
            [_itmeArray removeObjectAtIndex:indexPath.row];
            
            //让表视图删除对应的行
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
            break;
        case UITableViewCellEditingStyleInsert:
        {
          
        }
            break;
            
        default:
            break;
    }

}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //插入
        return UITableViewCellEditingStyleInsert;
    //删除
//    return UITableViewCellEditingStyleDelete;
}

////使用zfplayerview的控制器进行播放的试验

/*
 @property (strong, nonatomic) ZFPlayerView *playerView;
*/
//-(void)actionbutton{
//
//    UIView *showvdioview = [[UIView alloc] initWithFrame:CGRectMake(0, 100, kScreenW, kScreenW*9/16.0)];
//    showvdioview.backgroundColor = kwhite;
//    [self.view addSubview:showvdioview];
//
//    self.playerView = [[ZFPlayerView alloc] init];
//    [self.view addSubview:self.playerView];
//    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view).offset(20);
//        make.left.right.equalTo(self.view);
//        // Here a 16:9 aspect ratio, can customize the video aspect ratio
//        make.height.equalTo(self.playerView.mas_width).multipliedBy(9.0f/16.0f);
//    }];
//    // control view（you can custom）
//    ZFPlayerControlView *controlView = [[ZFPlayerControlView alloc] init];
//    // model
//    ZFPlayerModel *playerModel = [[ZFPlayerModel alloc]init];
//    playerModel.fatherView = showvdioview;
//    playerModel.videoURL = [NSURL URLWithString:@"http://218.60.94.32:1935/live/bs17.stream/playlist.m3u8"];
//    playerModel.title = @"北京电视台";
//    [self.playerView playerControlView:controlView playerModel:playerModel];
//    // delegate
//    self.playerView.delegate = self;
//    // auto play the video
//    [self.playerView autoPlayTheVideo];
//
//}


//最原始的使用avplayer的方法

/*
 @property (strong, nonatomic) AVPlayer *player;
 @property (strong, nonatomic) AVPlayerItem *playerItem;
 @property (strong, nonatomic) AVPlayerLayer *playerLayer;
 */
//-(void)actionbutton{
//  //play test
//    if (self.player == nil) {
//        //没有创建播放器
//        self.playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:@"http://ivi.bupt.edu.cn/hls/btv9.m3u8"]];//http://218.60.94.32:1935/live/bs17.stream/playlist.m3u8
//        self.playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:@"http://218.60.94.32:1935/live/bs17.stream/playlist.m3u8"]];//
//
//        //添加监听
//        [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
//        [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
//        self.player = [[AVPlayer alloc] initWithPlayerItem:self.playerItem];
//        self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
//        self.playerLayer.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width * 9.0 / 16.0);
//        self.playerView = [[UIView alloc] initWithFrame:CGRectMake(0, 160, CGRectGetWidth(self.playerLayer.frame), CGRectGetHeight(self.playerLayer.frame))];
//        self.playerView.backgroundColor = [UIColor blackColor];
//        [self.playerView.layer addSublayer:self.playerLayer];
//        [self.view addSubview:self.playerView];
//    } else {
//        //已经创建过播放器
//        NSLog(@"已经创建过播放器，继续播放");
//    }
//}

//#pragma mark - 监听回调
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
//
//    AVPlayerItem *playerItem = (AVPlayerItem *)object;
//    if ([keyPath isEqualToString:@"loadedTimeRanges"]){
//
//    }else if ([keyPath isEqualToString:@"status"]){
//        //获取播放状态
//        if (playerItem.status == AVPlayerItemStatusReadyToPlay){
//            [self.player play];
//            NSLog(@"开始播放");
//        } else{
//            NSLog(@"播放失败%@", playerItem.error);
//        }
//    }
//
//}

//    UIButton *addbutn = [UIButton buttonWithType:UIButtonTypeContactAdd];
//    addbutn.frame = CGRectMake(10, 60, 40, 40) ;
//    [addbutn addTarget:self action:@selector(actionbutton) forControlEvents:UIControlEventTouchUpInside];
//
//    [self.view addSubview:addbutn];

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

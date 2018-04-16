
//
//  PlayViewController.m
//  English
//
//  Created by Jay on 2018/4/12.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "PlayViewController.h"

#import "PlayerView.h"
#import "ListCell.h"

#import "Model.h"
#import "Common.h"
#import "XYYHTTP.h"
#import "LBLADMob.h"


#define VideoH ScreenWith/16.0*9.0
#define TitleViewH 116

@interface PlayViewController ()<UITableViewDataSource>
@property (nonatomic, strong) PlayerView *movieView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, weak) UILabel *titleLB;
@property (nonatomic, weak) UILabel *playCountLB;
@property (nonatomic, weak) UILabel *subTitleLB;
@property (nonatomic, weak) UILabel *countTitle;

@end

@implementation PlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self test];
    
    [self setUI];

    self.titleLB.text = self.mainTitle;
    self.playCountLB.text = [NSString stringWithFormat:@"共%lu集,%lu万次点播",(unsigned long)self.dics.count,self.dics.count * 5 + random()%50];
    self.subTitleLB.text = [self.dics[self.selectIndex] valueForKey:@"des"];
    self.countTitle.text = [NSString stringWithFormat:@"全%lu集",(unsigned long)self.dics.count];

    [self changPlay:self.dics[self.selectIndex]];
    
    if (![LBLADMob sharedInstance].isRemoveAd) {
        __weak typeof(self) weakSelf = self;
        [LBLADMob GADBannerViewNoTabbarHeightWithVC:weakSelf];
        int adH = IS_PAD?90:50;
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, adH, 0);
        self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    }


}

- (void)changPlay:(NSDictionary *)model{
    
   if(XYYHTTP.isProtocolService) return;

    self.selectIndex = [self.dics indexOfObject:model];
    self.navigationItem.title = [model valueForKey:@"title"];
    [self.tableView reloadData];

    if(KBOOLLINE){
        if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"PL"] boolValue]){
            
            UIAlertController *xyy_alertVC = [UIAlertController alertControllerWithTitle:@"五星好评解锁\n" message:@"解锁所有功能,所有内容提供及时更新 \n注意:为确保你的正常使用,请确保评论成功" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *xyy_done = [UIAlertAction actionWithTitle:@"现在就去" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //1369718515
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id1369718515?action=write-review"]];
                
                [XYYHTTP sharedInstance].beginTime = [NSDate new];
            }];
            
            UIAlertAction *xyy_cancel = [UIAlertAction actionWithTitle:@"下次再说" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            
            [xyy_alertVC addAction:xyy_done];
            
            [xyy_alertVC addAction:xyy_cancel];
            
            [self presentViewController:xyy_alertVC animated:YES completion:nil];
            
            return;
        }
        
        ///AD
         __weak typeof(self) weakSelf = self;
        [[LBLADMob sharedInstance] GADInterstitialWithVC:weakSelf];
        

    }
    
    NSString *url = [model valueForKey:@"url"];
    Model <TTZPlayerModel>*m = [Model new];
    m.name = [model valueForKey:@"title"];
    m.url = [url containsString:@"m3u8"]? url : [NSString stringWithFormat:@"http://app.zhangwangye.com/mdparse/app.php?id=%@",url];
    
    BOOL isWWAN = [[NSUserDefaults standardUserDefaults] boolForKey:@"GG"];
    BOOL isAllowWWANPlay = [[NSUserDefaults standardUserDefaults] boolForKey:@"YD"];
    

    if(isWWAN && !isAllowWWANPlay){

        UIAlertController *xyy_alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示\n" message:@"当前为蜂窝移动数据,是否继续观看视频" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *xyy_done = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.movieView playWithModel:m];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"YD"];

        }];
        UIAlertAction *xyy_cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        
        [xyy_alertVC addAction:xyy_done];
        [xyy_alertVC addAction:xyy_cancel];
        
        [self presentViewController:xyy_alertVC animated:YES completion:nil];
    }else{
        [self.movieView playWithModel:m];
    }

}

- (void)dealloc{
    NSLog(@"%s---guoli", __func__);
    [self.movieView stop];
}


- (void)setUI{
    
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.movieView];
    
    [self.view addSubview:self.titleView];
    
    [self.view addSubview:self.tableView];

}

#pragma mark  - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     __weak typeof(self) weakSelf = self;
    ListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSDictionary *model = self.dics[indexPath.row];
    cell.model = model;
    cell.playBtn.selected = (indexPath.item == self.selectIndex);
    cell.playBlock = ^(NSDictionary *model) {
        [weakSelf changPlay:model];
    };
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dics.count;
}

#pragma mark  -  get/set 方法
- (PlayerView *)movieView{
    if (!_movieView) {
        _movieView = [PlayerView playerView];
        _movieView.frame = CGRectMake(0, kStatusBarAndNavigationBarHeight, ScreenWith, VideoH);
        __weak typeof(self) weakSelf = self;
        _movieView.statusBarAppearanceUpdate = ^() {
            [weakSelf setNeedsStatusBarAppearanceUpdate];
        };

    }
    return _movieView;
}

- (UIView *)titleView{
    if (!_titleView) {
        _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight +  VideoH, ScreenWith, TitleViewH)];
        _titleView.backgroundColor = [UIColor whiteColor];
        
        UILabel *titleLB= [[UILabel alloc] initWithFrame:CGRectMake(10, 10, ScreenWith - 20, 30)];
        //titleLB.backgroundColor = kRandomColor;
        titleLB.font = [UIFont boldSystemFontOfSize:20];

        [_titleView addSubview:titleLB];
        _titleLB = titleLB;
        
        UILabel *playCountLB= [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(titleLB.frame), ScreenWith - 20, 15)];
        //playCountLB.backgroundColor = kRandomColor;
        playCountLB.textColor = [UIColor lightGrayColor];
        playCountLB.font = [UIFont systemFontOfSize:10];

        [_titleView addSubview:playCountLB];
        _playCountLB = playCountLB;
        
        UILabel *subTitleLB= [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(playCountLB.frame)+5, ScreenWith - 20, 20)];
        //subTitleLB.backgroundColor = kRandomColor;
        subTitleLB.font = [UIFont systemFontOfSize:14.0];
        subTitleLB.textColor = [UIColor lightGrayColor];
        [_titleView addSubview:subTitleLB];
        _subTitleLB = subTitleLB;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(subTitleLB.frame)+5, ScreenWith, 0.5)];
        line.backgroundColor = kBackgroundColor;
        [_titleView addSubview:line];
        
        
        UILabel *buttomTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(line.frame), ScreenWith-20-100, 35)];
        //buttomTitle.backgroundColor = kRandomColor;
        buttomTitle.font = [UIFont boldSystemFontOfSize:14.0];
        buttomTitle.text = @"课程选集";
        [_titleView addSubview:buttomTitle];


        UILabel *countTitle = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(buttomTitle.frame), CGRectGetMaxY(line.frame), 100, 35)];
        //countTitle.backgroundColor = kRandomColor;
        countTitle.textAlignment = NSTextAlignmentRight;
        countTitle.font = [UIFont systemFontOfSize:14.0];
        
        [_titleView addSubview:countTitle];
        _countTitle = countTitle;

        
        UIView *buttom = [[UIView alloc] initWithFrame:CGRectMake(0,TitleViewH- 0.5, ScreenWith, 0.5)];
        buttom.backgroundColor = kBackgroundColor;
        [_titleView addSubview:buttom];

    }
    return _titleView;
}

-(UITableView *)tableView {
    if (_tableView == nil) {
        
        
        
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.frame = CGRectMake(0, CGRectGetMaxY(self.titleView.frame), ScreenWith, ScreenHeight - TitleViewH - VideoH -kStatusBarAndNavigationBarHeight);

        //_tableView.delegate = self;
        //
        _tableView.dataSource = self;
        
        //_tableView.rowHeight = UITableViewAutomaticDimension;
        //_tableView.estimatedRowHeight = 200;
        //_tableView.rowHeight = IS_PAD?400:200;
        
        //_tableView.contentInset = UIEdgeInsetsMake(10, 0, 10, 0);
        
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
        [_tableView registerNib:[UINib nibWithNibName:@"ListCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        
//        UIView *bgView = [[UIView alloc] initWithFrame:self.view.bounds];
//
//        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
//
//        gradientLayer.locations = @[@0.0, @1.0];
//
//        gradientLayer.startPoint = CGPointMake(0.5, 0);
//
//        gradientLayer.endPoint = CGPointMake(0.5, 1);
//
//        [bgView.layer addSublayer:gradientLayer];
//
//        gradientLayer.colors = @[ (__bridge id)kColorWithHexString(0x209cff).CGColor,(__bridge id)kColorWithHexString(0x68e0cf).CGColor];
//
//        gradientLayer.frame = CGRectMake(-1, -1,bgView.bounds.size.width+2, bgView.bounds.size.height+2);
//
//        _tableView.backgroundView = bgView;
//        _tableView.backgroundColor = [UIColor orangeColor];
        //[self.view addSubview:_tableView];
        
    }
    return _tableView;
}


- (BOOL)prefersStatusBarHidden{
    return self.movieView.prefersStatusBarHidden;
}

- (BOOL)prefersHomeIndicatorAutoHidden {
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    NSLog(@"%s", __func__);
    return UIStatusBarStyleDefault;
}





@end

//
//  rmtpm3u8
//
//  Created by 何川 on 2018/3/20.
//  Copyright © 2018年 何川. All rights reserved.
//

#import "PlayViewController.h"
#import "ZFPlayerView.h"

@interface PlayViewController ()<ZFPlayerDelegate>
@property (strong, nonatomic) ZFPlayerView *playerView;
@end

@implementation PlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.navigationController.navigationBarHidden = YES;
    [self makeUI];
    self.title = _model.title;
    
    
}

-(void)makeUI{
    UIView *backview = [[UIView alloc] initWithFrame:CGRectMake(0, kNavH + 15, kScreenW, kScreenW*9/16.0)];
    [self.view addSubview: backview];
    
    self.playerView = [[ZFPlayerView alloc] init];
    [self.view addSubview:self.playerView];
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(20);
        make.left.right.equalTo(self.view);
        // Here a 16:9 aspect ratio, can customize the video aspect ratio
        make.height.equalTo(self.playerView.mas_width).multipliedBy(9.0f/16.0f);
    }];
    // control view（you can custom）
    ZFPlayerControlView *controlView = [[ZFPlayerControlView alloc] init];
    // model
    ZFPlayerModel *playerModel = [[ZFPlayerModel alloc]init];
    playerModel.fatherView = backview;
    playerModel.videoURL = [NSURL URLWithString:_model.urlString];
    playerModel.title = _model.title;
    [self.playerView playerControlView:controlView playerModel:playerModel];
    // delegate
    self.playerView.delegate = self;
    // auto play the video
    [self.playerView autoPlayTheVideo];
    
    
    
    return;
    UIButton *addbutton = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.view addSubview:addbutton];
    
    [addbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-160);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(44);
    }];
    [addbutton jk_setBackgroundColor:kBlue forState:UIControlStateNormal];
    [addbutton setTitle:@"添加" forState:UIControlStateNormal];
    [addbutton addTarget:self action:@selector(addTVitem) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *delbutton = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.view addSubview:delbutton];
    
    [delbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(addbutton).offset(-60);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(44);
    }];
    [delbutton jk_setBackgroundColor:kBlue forState:UIControlStateNormal];
    [delbutton setTitle:@"移除" forState:UIControlStateNormal];
    [delbutton addTarget:self action:@selector(delTVitem) forControlEvents:UIControlEventTouchUpInside];
    
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.playerView pause];
    self.playerView.delegate = nil;
    self.playerView = nil;
}

-(void)addTVitem{
    //添加
    [[FMDBmanger shareManger] insertTVmodelData:_model];
}
-(void)delTVitem{
    //移除
    [[FMDBmanger shareManger] deleateTvModel:_model];
}
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


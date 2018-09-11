
#import "TJPlayController.h"

#import "PlayerView.h"

#define kScreenW [UIScreen mainScreen].bounds.size.width

#define kScreenH [UIScreen mainScreen].bounds.size.height

#define iPad (UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPad)

// iPhone X
#define  iPhoneX (kScreenW == 375.f && kScreenH == 812.f ? YES : NO)

// Status bar height.
// #define  StatusBarHeight      (iPhoneX ? 44.f : 20.f)
#define  kStatusBarHeight      [[UIApplication sharedApplication] statusBarFrame].size.height

// Navigation bar height.
#define  kNavigationBarHeight  44.f

// Tabbar height.
#define  kTabbarHeight         (iPhoneX ? (49.f+34.f) : 49.f)

// Tabbar safe bottom margin.
#define  kTabbarSafeBottomMargin         (iPhoneX ? 34.f : 0.f)

// Status bar & navigation bar height.
#define  kStatusBarAndNavigationBarHeight  (iPhoneX ? 88.f : 64.f)


#define VideoH kScreenW/16.0*9.0
#define TitleViewH 116

@interface TJPlayController ()
///<UICollectionViewDelegate,
//UICollectionViewDataSource>
@property (nonatomic, strong) PlayerView *movieView;
//@property (nonatomic, strong) UICollectionView *collectionView;
//@property (nonatomic, strong) UIView *titleView;
//@property (nonatomic, weak) UILabel *titleLB;
//@property (nonatomic, weak) UILabel *playCountLB;
//@property (nonatomic, weak) UILabel *subTitleLB;
//@property (nonatomic, weak) UILabel *countTitle;
//@property (nonatomic, weak) JJVIModel *curModel;

@end

@implementation TJPlayController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    
//    [self changPlay:self.models[self.selectIndex]];
    
//    [[AudioPlayer player] pause];
}

- (void)changPlay:(NSDictionary *)model{

//    if([TJNetwork defaultNetwork].isProtocolService) return;
//
//    NSString *url = model[@"url"];
//    NSString *title = model[@"title"];
//    VideoModel *m = [VideoModel new];
//    m.title = title?title:model[@"zhuti"];
//
//    self.selectIndex = [self.models indexOfObject:model];
//    self.navigationItem.title = m.title;
//    [self.collectionView reloadData];
//
//    if ([TJNetwork defaultNetwork].isShowOnlineAd) {
//        __weak typeof(self) weakSelf = self;
//        [[TJADMob sharedInstance] GADInterstitialWithVC:weakSelf googleScale:10];
//    }



//    m.url = [TJNetwork defaultNetwork].appIsOnline? url : [NSString stringWithFormat:@"http://app.zhangwangye.com/mdparse/app.php?id=%@",url];
//
//    [self.movieView playWithModel:m];
    
//    if ([TJNetwork defaultNetwork].appIsOnline) {
//        m.url = url? url:model[@"bofang"];//[TJNetwork defaultNetwork].appIsOnline? url : [NSString stringWithFormat:@"http://app.zhangwangye.com/mdparse/app.php?id=%@",url];
//
//        [self.movieView playWithModel:m];
//    }else{
//        [[TJIQYVideo sharedVideo] playWithURL:url completion:^(NSString *urlStr) {
//            m.url = urlStr;
//            [self.movieView playWithModel:m];
//        }];
//    }


}

- (void)dealloc{
    NSLog(@"%s---guoli", __func__);
    [self.movieView stop];
}


- (void)setUI{
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.movieView];
    self.navigationItem.title = self.title;
    
    VideoModel *m = [VideoModel new];
    m.url = self.url;
    m.title = self.title;
    [self.movieView playWithModel:m];
    
//    [self.view addSubview:self.titleView];
//
//    [self.view addSubview:self.collectionView];
//
//    self.titleLB.text = self.title;
//    self.playCountLB.text = [NSString stringWithFormat:@"共%lu集,%lu万次点播",(unsigned long)self.models.count,self.models.count * 5 + random()%50];
//    self.subTitleLB.text = self.desc;
//    self.countTitle.text = [NSString stringWithFormat:@"全%lu集",(unsigned long)self.models.count];
//
//    __weak typeof(self) weakSelf = self;
//    CGFloat adH  = [TJADMob GADBannerViewNoTabbarHeightWithVC:weakSelf googleScale:10];
//    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, adH, 0);
//    self.collectionView.scrollIndicatorInsets = self.collectionView.contentInset;
//
//    if ([TJNetwork defaultNetwork].isShowOnlineAd) {
//        [[TJADMob sharedInstance] GADInterstitialWithVC:weakSelf googleScale:10];
//
//        [[TJADMob sharedInstance] loadNativeAdCount:1
//                                              adSize:CGSizeMake(kScreenW, 100) nativeAdSuccess:^(NSArray<UIView *> *obj) {
//                                                  GDTNativeExpressAdView *expressView = (GDTNativeExpressAdView *)obj.lastObject;
//                                                  expressView.controller = weakSelf;
//                                                  [expressView render];
//                                                  expressView.alpha = 0;
//                                                  [weakSelf.view addSubview:expressView];
//                                              }
//                                 adViewRenderSuccess:^(UIView *adView) {
//                                     adView.alpha = 1;
//                                     adView.y = kScreenH - adView.height - kTabbarSafeBottomMargin - adH;
//                                     weakSelf.collectionView.contentInset = UIEdgeInsetsMake(0, 0, adH + adView.height, 0);
//                                     adView.x = 0;
//                                 }];
//    }

    
}

//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
//{
//    return self.models.count;
//}
//
//
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//
//    TJDetailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TJDetailCell" forIndexPath:indexPath];
//    NSString *title = self.models[indexPath.item][@"title"];
//
//    cell.nameLB.text =  title? title: self.models[indexPath.item][@"zhuti"];
//    if (indexPath.item != self.selectIndex) {
//        cell.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
//    }else{
//        cell.backgroundColor = kCommonColor;
//    }
//
//    return cell;
//}
//
//-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//
//    [self changPlay:self.models[indexPath.item]];
//}
#pragma mark  -  get/set 方法
- (PlayerView *)movieView{
    if (!_movieView) {
        _movieView = [PlayerView playerView];
        _movieView.frame = CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreenW, VideoH);
        _movieView.allowSafariPlay = YES;

    }
    return _movieView;
}
//
//- (UIView *)titleView{
//    if (!_titleView) {
//        _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight +  VideoH, kScreenW, TitleViewH)];
//        _titleView.backgroundColor = kBackgroundColor;//[UIColor whiteColor];
//
//        UILabel *titleLB= [[UILabel alloc] initWithFrame:CGRectMake(10, 10, kScreenW - 20, 30)];
//        //titleLB.backgroundColor = kRandomColor;
//        titleLB.font = [UIFont boldSystemFontOfSize:20];
//
//        [_titleView addSubview:titleLB];
//        _titleLB = titleLB;
//
//        UILabel *playCountLB= [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(titleLB.frame), kScreenW - 20, 15)];
//        //playCountLB.backgroundColor = kRandomColor;
//        playCountLB.textColor = [UIColor lightGrayColor];
//        playCountLB.font = [UIFont systemFontOfSize:10];
//
//        [_titleView addSubview:playCountLB];
//        _playCountLB = playCountLB;
//
//        UILabel *subTitleLB= [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(playCountLB.frame)+5, kScreenW - 20, 20)];
//        //subTitleLB.backgroundColor = kRandomColor;
//        subTitleLB.font = [UIFont systemFontOfSize:14.0];
//        subTitleLB.textColor = [UIColor lightGrayColor];
//        [_titleView addSubview:subTitleLB];
//        _subTitleLB = subTitleLB;
//
//        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(subTitleLB.frame)+5, kScreenW, 0.5)];
//        line.backgroundColor = kBackgroundColor;
//        [_titleView addSubview:line];
//
//
//        UILabel *buttomTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(line.frame), kScreenW-20-100, 35)];
//        //buttomTitle.backgroundColor = kRandomColor;
//        buttomTitle.font = [UIFont boldSystemFontOfSize:14.0];
//        buttomTitle.text = @"视频选集";
//        [_titleView addSubview:buttomTitle];
//
//
//        UILabel *countTitle = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(buttomTitle.frame), CGRectGetMaxY(line.frame), 100, 35)];
//        //countTitle.backgroundColor = kRandomColor;
//        countTitle.textAlignment = NSTextAlignmentRight;
//        countTitle.font = [UIFont systemFontOfSize:14.0];
//
//        [_titleView addSubview:countTitle];
//        _countTitle = countTitle;
//
//
//        UIView *buttom = [[UIView alloc] initWithFrame:CGRectMake(0,TitleViewH- 0.5, kScreenW, 0.5)];
//        buttom.backgroundColor = kBackgroundColor;
//        [_titleView addSubview:buttom];
//
//    }
//    return _titleView;
//}
//
//-(UICollectionView *)collectionView {
//    if (_collectionView == nil) {
//
//
//
//        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//        layout.minimumLineSpacing = 8;
//        layout.minimumInteritemSpacing = 8;
//
//        layout.itemSize = CGSizeMake((kScreenW - 16 * 2 - 0*8)/1.0 ,35);
//        if ([TJNetwork defaultNetwork].appIsOnline) {
//            layout.itemSize = CGSizeMake((kScreenW - 16 * 2 - 3*8)/4.0 ,35);
//        }
//
//        layout.sectionInset = UIEdgeInsetsMake(8, 16, 16, 16);
//        //UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreenW, kScreenH-kStatusBarAndNavigationBarHeight) collectionViewLayout:layout];
//        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleView.frame), kScreenW, kScreenH - TitleViewH - VideoH -kStatusBarAndNavigationBarHeight) collectionViewLayout:layout];
//
//        collectionView.alwaysBounceVertical = YES;
//        collectionView.backgroundColor = kBackgroundColor;
//        collectionView.dataSource = self;
//        collectionView.delegate = self;
//
//        [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"FooterView"];
//        [collectionView registerNib:[UINib nibWithNibName:@"TJDetailCell" bundle:nil] forCellWithReuseIdentifier:@"TJDetailCell"];
//
//        _collectionView = collectionView;
//
//
//        //        UIView *bgView = [[UIView alloc] initWithFrame:self.view.bounds];
//        //
//        //        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
//        //
//        //        gradientLayer.locations = @[@0.0, @1.0];
//        //
//        //        gradientLayer.startPoint = CGPointMake(0.5, 0);
//        //
//        //        gradientLayer.endPoint = CGPointMake(0.5, 1);
//        //
//        //        [bgView.layer addSublayer:gradientLayer];
//        //
//        //        gradientLayer.colors = @[ (__bridge id)kColorWithHexString(0x209cff).CGColor,(__bridge id)kColorWithHexString(0x68e0cf).CGColor];
//        //
//        //        gradientLayer.frame = CGRectMake(-1, -1,bgView.bounds.size.width+2, bgView.bounds.size.height+2);
//        //
//        //        _tableView.backgroundView = bgView;
//        //        _tableView.backgroundColor = [UIColor orangeColor];
//        //[self.view addSubview:_tableView];
//
//
//
//    }
//    return _collectionView;
//}


//- (BOOL)prefersStatusBarHidden{
//    return self.movieView.prefersStatusBarHidden;
//}

//- (BOOL)prefersHomeIndicatorAutoHidden {
//    return YES;
//}
//
//- (UIStatusBarStyle)preferredStatusBarStyle{
//    NSLog(@"%s", __func__);
//    return UIStatusBarStyleDefault;
//}





@end

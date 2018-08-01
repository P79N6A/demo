//
//  ViewController.m
//  audioPlayer
//
//  Created by Jayson on 2018/7/26.
//  Copyright © 2018年 Jayson. All rights reserved.
//

#import "ViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "PlayViewController.h"
#import "TransFromAnimation.h"
#import "SwipeViewController.h"


#import "AudioPlayer.h"
#import "UIView+Loading.h"
#import "UIView+EffectView.h"

#define kScreenW [UIScreen mainScreen].bounds.size.width

#define kScreenH [UIScreen mainScreen].bounds.size.height

#define iPad (UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPad)

#define kCommonColor  kColorWithHexString(0x0A951F)//41 196 64

#define kBackgroundColor  kRGBColor(236, 237, 238)

#define kRandomColor kRGBColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

#define kColorWithHexString(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0 green:((float)((hex & 0xFF00) >> 8)) / 255.0 blue:((float)(hex & 0xFF)) / 255.0 alpha:1]

#define kRGBColor(r, g, b) [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:1.0]

#define kRGBAColor(r, g, b, a) [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:a]


@interface ViewController ()
<UICollectionViewDelegate,UICollectionViewDataSource,PlayViewControllerDelegate,UIViewControllerTransitioningDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;

@property(nonatomic,strong)TransFromAnimation *presentAnimation;
@property(nonatomic,strong)TransFromAnimation *dismissAnimation;
@property(nonatomic,strong)SwipeViewController *swipeVC;


@end

@implementation ViewController

-(UICollectionView *)collectionView {
    
    if (_collectionView == nil) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        layout.minimumInteritemSpacing = 10;
        
        layout.minimumLineSpacing = 10;
        
        layout.itemSize = CGSizeMake((kScreenW - (iPad?61:41)) / (iPad?4:3),(kScreenW - (iPad?30:20)) / (iPad?4:3)*1.5);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenW,kScreenH) collectionViewLayout:layout];
        
        _collectionView.dataSource = self;
        
        _collectionView.delegate = self;
        
        _collectionView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
        
        _collectionView.backgroundColor = [UIColor blackColor];
        
        [self.view addSubview:_collectionView];
        
//        [_collectionView registerNib:[UINib nibWithNibName:@"TJCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        
    }
    
    return _collectionView;
}

//FIXME:  -  UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = kRandomColor;
        return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PlayViewController *presentToVC=[[PlayViewController alloc]init];
    [self.swipeVC handleDismissViewController:presentToVC];

    presentToVC.transitioningDelegate=self;
    presentToVC.delegate=self;

    presentToVC.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:presentToVC animated:YES completion:nil];

    
//    return;
//    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
//    CGRect rect = [collectionView convertRect:cell.frame toView:self.view];
//    UIView *bg = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    [self.view.window addSubview:bg];
//    UIButton *effect = [[UIButton alloc] initWithFrame:bg.bounds];
//    [effect addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
//
//    [bg addSubview:effect];
//    effect.backgroundColor = [UIColor clearColor];
//    effect.enabledEffect = YES;
//
//    bg.backgroundColor = [UIColor clearColor];
//    [bg addSubview:cell];
//    cell.frame = rect;
    
}


-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return self.presentAnimation;
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return self.dismissAnimation;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator{
    return self.swipeVC.interacting ? self.swipeVC : nil;
}

-(void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)close:(UIButton *)sender{
    [sender.superview removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self collectionView];
    self.presentAnimation = [TransFromAnimation transfromWithAnimationType:YJPPresentAnimationPresent];
    
    self.dismissAnimation = [TransFromAnimation transfromWithAnimationType:YJPPresentAnimationDismiss];
    self.swipeVC = [SwipeViewController new];

    
    [AudioPlayer.player playWithURL:@"http://thai-host.com:8100/pattaya103.ogg"
     //@"http://111.223.51.7:8000/listen.pls?sid=1"
     //@"http://dl2.loveq.cn:8090/program/2018/LoveQ.cn_2018-07-22-1.mp3"
                       onStartCache:^{
//                           [self.view showLoading:nil];
                       }
                         onEndCache:^{
//                             [self.view hideLoading:nil];
                         } onProgress:^(NSTimeInterval current, NSTimeInterval total) {
                             NSLog(@"%s---当前时间：%f--总时间：%f", __func__,current,total);
                         }];
    
    
}

@end

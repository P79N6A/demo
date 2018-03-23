//
//  baseViewController.m
//  Coin3658
//
//  Created by 川何 on 2017/6/26.
//  Copyright © 2017年 hechuan. All rights reserved.
//

#import "baseViewController.h"
#import "EmptyView.h"
@interface baseViewController ()<UIGestureRecognizerDelegate,EmptyViewDelegate>

@end

@implementation baseViewController

- (UIBarButtonItem *)rt_customBackItemWithTarget:(id)target
                                          action:(SEL)action
{
    UIButton *colseBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 10+20, 17+20)];
    [colseBtn setImage:[UIImage imageNamed: @"icon_back"] forState:UIControlStateNormal];
    colseBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 0, 10, 20);
    colseBtn.imageView.contentMode = UIViewContentModeLeft;
    [colseBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
//    colseBtn.imageView.jk_left = -15.0;
    [self.view addSubview:colseBtn];
    UIBarButtonItem *itebtn = [[UIBarButtonItem alloc] initWithCustomView:colseBtn];
    return itebtn;
}
//- (instancetype)init {
//    self = [super init];
//    if (self) {
//        self.hidesBottomBarWhenPushed = YES;
//    }
//    return self;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kbackground;
    self.automaticallyAdjustsScrollViewInsets = NO; //此处ios11以下回有效果,11不会有,需要在具体的页面进行判断使用
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];//bar颜色
    self.navigationController.navigationBar.tintColor = k999;//返回按钮颜色
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: k333,NSFontAttributeName:[UIFont systemFontOfSize:17]};//字体颜色
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(regist)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    
    
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case 0:
            {
                _netStatus = NetWorkStatusNoInternet;
                [self monitorNetStateChanged:0];

            }
                break;
            case 1:{
                
                _netStatus = NetWorkStatusFlow;
                [self monitorNetStateChanged:1];

            }
                break;
            case 2:{
                
                _netStatus = NetWorkStatusWifi;
                [self monitorNetStateChanged:2];

            }
                break;
            default:
                break;
        }
    }];
    [manager startMonitoring];
    

}
-(void)regist{
    [self.view endEditing:YES];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 输出点击的view的类名
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }//bankcellcontentview
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"bankcellcontentview"]) {
        return NO;
    }
    return  YES;
}


#pragma mark ==================监听事件的回调==================

//添加没有网络界面
- (void)addEmptyViewWithFrame:(CGRect)frame {
    
    EmptyView *emptyView = [[EmptyView alloc] initWithFrame:frame];
    emptyView.delegates = self;
    [self.view addSubview:emptyView];
}
//无网络页面的回调事件
- (void)clickEmptyViewWithAction:(UIView *)sender {
    
    [self clickEmptyView];
}
-(void)clickEmptyView {
    
    //子类实现
}

//移除没有网络界面
- (void)removeEmptyView {
    
    for (UIView *view in self.view.subviews) {
        
        if ([view isKindOfClass:[EmptyView class]]) {
            
            [view removeFromSuperview];
        }
    }
}
#pragma mark ==================网络状态改变==================
-(void)monitorNetStateChanged:(NSInteger)netState {
    
    //子类实现
}
#pragma mark ==================移除通知==================
-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

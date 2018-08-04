//
//  PW_Controller.m
//  导航栏隐藏
//
//  Created by DFSJ on 17/3/15.
//  Copyright © 2017年 Oriental Horizon. All rights reserved.
//

#import "PW_Controller.h"
#import "UINavigationBar+Alpha.h"
#import "PW_TableViewCell.h"
#define NavigationBarBGColor [UIColor colorWithRed:32/255.0f green:177/255.0f blue:232/255.0f alpha:1]


@interface PW_Controller ()<UITableViewDelegate,UITableViewDataSource>
{
    UIView *v;
    UIImageView *imV;
}

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) UILabel *titleText;

@end

@implementation PW_Controller

- (void)viewDidLoad {
    [super viewDidLoad];


    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = [self headerView];

    UIBarButtonItem * leftButton = [[UIBarButtonItem alloc]initWithTitle:nil style:UIBarButtonItemStylePlain target:self action:@selector(goToBack)];
    leftButton.image=[UIImage imageNamed:@"back01"];
    leftButton.tintColor=[UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftButton;
//
//    self.titleText = [[UILabel alloc] initWithFrame: CGRectMake(160, 0, 120, 50)];
//    self.titleText.backgroundColor = [UIColor clearColor];
//    self.titleText.textColor=[UIColor whiteColor];
//    [self.titleText setFont:[UIFont systemFontOfSize:17.0]];
//    self.titleText.textAlignment = NSTextAlignmentCenter;
//
//    self.navigationItem.titleView=self.titleText;
    
    self.navigationItem.title = @"gggg";
}


-(void)goToBack{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(UIView *)headerView{
    
    v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200)];
    
    imV = [[UIImageView alloc]initWithImage:[UIImage imageNamed: @"品牌默认"]];
    imV.frame = CGRectMake(0, 0, self.view.bounds.size.width, v.bounds.size.height);
    imV.contentMode = UIViewContentModeScaleAspectFill;
    imV.clipsToBounds = YES;
    
    [v addSubview:imV];
    
    return v;
}

-(UITableView *)tableView{

    if (_tableView == nil) {
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
        _tableView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0 );
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
    }
    return _tableView;

}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    CGFloat scrollY = self.tableView.contentOffset.y;
    // 确定比例
    CGFloat scale = (64 + scrollY - 80) / 64;
    
    NSLog(@"scrollY:%f   scale:%f",scrollY,scale);
    
    
    if (scrollY > 30) {
       
//        [self.navigationController.navigationBar resetNavBar];
        [self.navigationController.navigationBar changeNavigationBarAlphaWith:[NavigationBarBGColor colorWithAlphaComponent:scale]];
        [self.titleText setText:@"hahaha"];

        
    }else{
        
        [self.navigationController.navigationBar changeNavigationBarAlphaWith:[NavigationBarBGColor colorWithAlphaComponent:0]];
        [self.titleText setText:nil];
    }
}


-(UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
}



-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 20;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    PW_TableViewCell *cell = [PW_TableViewCell cellWithTableView:tableView];

    return cell;

}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 100;

}

-(void) viewWillDisappear:(BOOL)animated{
    [self.navigationController.navigationBar resetNavBar];
}

//-(void) viewWillAppear:(BOOL)animated{
//
//    [self.navigationController.navigationBar changeNavigationBarAlphaWith:[NavigationBarBGColor colorWithAlphaComponent:0]];
//
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

//
//  ViewController.m
//  UISearchBar
//
//  Created by Jay on 2018/3/17.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "ViewController.h"
#import "ZZYueYuTV.h"
#import "TableViewController.h"
#import "NSObject+PropertyListing.h"

@interface ViewController ()
<
//UISearchBarDelegate,
UISearchControllerDelegate
>
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSArray *datas;
//@property (nonatomic, strong) NSArray *searchs;
@end

@implementation ViewController

- (UISearchController *)searchController
{
    if(!_searchController){
        
        TableViewController *vc = [[TableViewController alloc] init];
        _searchController = [[UISearchController alloc] initWithSearchResultsController:vc];

        //背景
//        _searchController.searchBar.barTintColor = [UIColor orangeColor];//[UIColor colorWithRed:67/255.0 green:205/255.0 blue:135/255.0 alpha:1.0];
        _searchController.searchBar.tintColor = [UIColor whiteColor];
        _searchController.searchBar.barTintColor = [UIColor orangeColor];

//        [_searchController.searchBar setBackgroundImage:[UIImage new] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
//        [_searchController.searchBar setBackgroundImage:[UIImage new]];
//        [_searchController.searchBar setSearchFieldBackgroundImage:[UIImage new] forState:UIControlStateNormal];
        UIImage* searchBarBg = [self GetImageWithColor:[UIColor orangeColor] andHeight:35.0f];
        //设置背景图片
//        [_searchController.searchBar setBackgroundImage:searchBarBg];
        //设置背景色
//        [_searchController.searchBar setBackgroundColor:[UIColor orangeColor]];
        //设置文本框背景
        UIImage* searchFieldBackgroundImage = [self GetImageWithColor:[UIColor colorWithRed:238/255 green:238/255 blue:238/255 alpha:0.5] andHeight:35.0f];
//        UIImage* searchFieldBackgroundImage = [self GetImageWithColor:[UIColor whiteColor] andHeight:35.0f];

        
        [_searchController.searchBar setSearchFieldBackgroundImage:[self hyb_imageWithCornerRadius:10 image:searchFieldBackgroundImage] forState:UIControlStateNormal];
        
        [_searchController.searchBar setSearchTextPositionAdjustment:UIOffsetMake(10, 0)];// 设置搜索框中文本框的文本偏移量
        
        _searchController.searchBar.placeholder = @"请输入你要搜索的名字";
        [_searchController.searchBar setValue:@"取消" forKey:@"_cancelButtonText"];

        _searchController.searchBar.delegate = vc;
        _searchController.delegate = self;
        self.definesPresentationContext = YES;
//        （1）如果不设置：self.definesPresentationContext = YES;那么如果设置了hidesNavigationBarDuringPresentation为YES，在进入编辑模式的时候会导致searchBar看不见（偏移-64）。如果设置了hidesNavigationBarDuringPresentation为NO，在进入编辑模式会导致高度为64的空白区域出现（导航栏未渲染出来）。
//
//        （2）如果设置：self.definesPresentationContext = YES;在设置hidesNavigationBarDuringPresentation为YES，进入编辑模式会正常显示和使用。如果设置了hidesNavigationBarDuringPresentation为NO，在进入编辑模式会导致搜索框向下偏移64.
//        _searchController.searchBar.scopeButtonTitles = @[@"1",@"3"];
//        _searchController.searchBar.barStyle = UIBarStyleBlack;
        
        // titleView -->NO   headerView -->YES
        _searchController.hidesNavigationBarDuringPresentation = NO;
        

    }
    return _searchController;
}

- (UIImage *)hyb_imageWithCornerRadius:(CGFloat)radius image:(UIImage *)image {
    
    CGRect rect = (CGRect){0.f, 0.f, image.size};
    
    
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, UIScreen.mainScreen.scale);
    
    CGContextAddPath(UIGraphicsGetCurrentContext(),
                     
                     [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius].CGPath);
    
    CGContextClip(UIGraphicsGetCurrentContext());
    
    
    
    [image drawInRect:rect];
    
    UIImage *image0 = UIGraphicsGetImageFromCurrentImageContext();
    
    [UIImagePNGRepresentation(image0) writeToFile:@"/Users/jay/Desktop/曹志.png" atomically:YES];
    
    UIGraphicsEndImageContext();
    
    
    
    return image0;
    
}


- (UIImage*) GetImageWithColor:(UIColor*)color andHeight:(CGFloat)height
{
    CGRect r= CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.width, height);
    UIGraphicsBeginImageContext(r.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, r);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

- (UIImage *)clipImage:(UIImage *)image {
    // 01 开启图片上下文 第二个参数 NO 代表透明
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0);
    // 02 获得上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 03 添加一个圆
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextAddEllipseInRect(context, rect);
    // 04 剪切
    CGContextClip(context);
    // 05 将图片画上去
    [image drawInRect:rect];
    // 06 获取图片
    UIImage *image0 = UIGraphicsGetImageFromCurrentImageContext();
    // 07 关闭上下文
    UIGraphicsEndImageContext();
    // 08 返回图片
    return image0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    self.datas = @[];// @[@"1",@"2",@"1",@"2",@"1",@"2",@"1",@"2",@"1",@"2",@"1",@"2",@"1",@"2",@"1",@"2"];
//    self.searchs = @[@"A",@"B",@"A",@"B",@"A",@"B",@"A",@"B",@"A",@"B",@"A",@"B",@"A",@"B",@"A",@"B",@"A",@"B"];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];

    self.title = @"标题";
    
    if (@available(iOS 11.0, *)) {
        self.navigationController.navigationBar.prefersLargeTitles = YES;
        self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAutomatic;
        self.navigationItem.searchController = self.searchController;
        self.navigationItem.hidesSearchBarWhenScrolling = NO;
        
        //View UISearchBarTextField _UISearchBarSearchFieldBackgroundView
        NSLog(@"%s", __func__);
    } else {
        //self.tableView.tableHeaderView = self.searchController.searchBar;
        self.navigationItem.titleView = self.searchController.searchBar;

    }

    
    [ZZYueYuTV search:@"流氓大亨" page:1 block:^(NSArray<NSDictionary *> *obj,BOOL hasMore) {
        NSLog(@"%s", __func__);
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.datas =  @[@"1",@"2",@"1",@"2",@"1",@"2",@"1",@"2",@"1",@"2",@"1",@"2",@"1",@"2",@"1",@"2"];

            [self.tableView reloadData];

        });
    }];
    
}


- (void)willPresentSearchController:(UISearchController *)searchController{
  NSLog(@"%s - 即将出现", __func__);
}
- (void)didPresentSearchController:(UISearchController *)searchController{
    NSLog(@"%s - 已经出现", __func__);
}
- (void)willDismissSearchController:(UISearchController *)searchController{
    NSLog(@"%s - 即将消失", __func__);
}
- (void)didDismissSearchController:(UISearchController *)searchController{
    NSLog(@"%s - 已经消失", __func__);
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *VC = [UIViewController new];
    
    VC.title = self.datas[indexPath.row];
    VC.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:VC animated:YES];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.text = self.datas[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    cell.transform = CGAffineTransformMakeScale(-self.view.frame.size.width, cell.frame.origin.y);
//    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
//        cell.transform = CGAffineTransformIdentity;
//    } completion:^(BOOL finished) {
//
//    }];
    
    cell.transform = CGAffineTransformMakeTranslation(0, 40);
    [UIView animateWithDuration:0.8 animations:^{
        
        cell.transform = CGAffineTransformIdentity;
    }];

    
}

@end

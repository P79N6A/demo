//
//  ViewController.m
//  tableview嵌套scrollView
//
//  Created by 蔡强 on 2017/5/27.
//  Copyright © 2017年 kuaijiankang. All rights reserved.
//

#import "ViewController.h"
#import "UIView+Extension.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    
    
    
    UIView * tableViewHeaderView = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, 375, 200))];
    
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 200)];
    self.imageView.image = [UIImage imageNamed:@"mineHeaderBg"];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    
    [tableViewHeaderView addSubview:self.imageView];
    
    
    UISwitch *sw = [UISwitch new];
    [tableViewHeaderView addSubview:sw];
    sw.center = CGPointMake(375/2, 100);
    // 设置表头
    self.tableView.tableHeaderView = tableViewHeaderView;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"reuseID"];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"contentOffsetY:%f",scrollView.contentOffset.y);
    //NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];

    //[self.tableView cellForRowAtIndexPath:index];

    CGFloat width = self.view.frame.size.width; // 图片宽度
    CGFloat yOffset = scrollView.contentOffset.y;  // 偏移的y值
    if (yOffset < 0) {
        CGFloat totalOffset = 200 + ABS(yOffset);
        CGFloat f = totalOffset / 200;
        self.imageView.frame =  CGRectMake(- (width * f - width) / 2, yOffset, width * f, totalOffset); //拉伸后的图片的frame应该是同比例缩放。
    }
    return;
    
    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
    // 获取指定cell
    [self.tableView cellForRowAtIndexPath:index];
    
    // 控制表头图片的放大
    if (scrollView.contentOffset.y < 0) {
        // 向下拉多少
        // 表头就向上移多少
        self.imageView.y = scrollView.contentOffset.y;
        // 高度就增加多少
        self.imageView.height = 200 + fabs(scrollView.contentOffset.y);
        self.imageView.width =  self.imageView.height * 375/200;//200 + fabs(scrollView.contentOffset.y);
        self.imageView.x = (375 -  self.imageView.width )*0.5;//200 + fabs(scrollView.contentOffset.y);


    }else{
        // 复原
        self.imageView.y = 0;
        self.imageView.height = 200;
        self.imageView.x = 0;
        self.imageView.width = 375;
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 30;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseID = @"reuseID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    cell.backgroundColor = [UIColor yellowColor];

    return cell;
}

@end

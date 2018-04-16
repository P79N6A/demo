//
//  YYReadController.m
//  fzdm
//
//  Created by czljcb on 2018/3/17.
//  Copyright © 2018年 Ward Wong. All rights reserved.
//

#import "YYReadController.h"

#import "EnglishCell.h"

#import "YYWebController.h"

#import "Common.h"
#import "LBLADMob.h"

#import <UIImageView+WebCache.h>


@interface YYReadController ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *reads;

@end

@implementation YYReadController


-(UITableView *)tableView {
    if (_tableView == nil) {
       
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        
        _tableView.dataSource = self;
        
        _tableView.rowHeight = IS_PAD?400:200;
        
        _tableView.contentInset = UIEdgeInsetsMake(10, 0, 10, 0);
        
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
        [_tableView registerNib:[UINib nibWithNibName:@"EnglishCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        
        UIView *bgView = [[UIView alloc] initWithFrame:self.view.bounds];
        
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        
        gradientLayer.locations = @[@0.0, @1.0];
        
        gradientLayer.startPoint = CGPointMake(0.5, 0);
        
        gradientLayer.endPoint = CGPointMake(0.5, 1);
        
        [bgView.layer addSublayer:gradientLayer];
        
        gradientLayer.colors = @[ (__bridge id)kColorWithHexString(0x209cff).CGColor,(__bridge id)kColorWithHexString(0x68e0cf).CGColor];
       
        gradientLayer.frame = CGRectMake(-1, -1,bgView.bounds.size.width+2, bgView.bounds.size.height+2);
        
        _tableView.backgroundView = bgView;
        
        [self.view addSubview:_tableView];
    }
    
    return _tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"阅读";

    self.reads = @[
                       @{
                           @"title":@"记住1万个单词",
                           @"html":@"http://omizco9tk.bkt.clouddn.com/textxueyingyu101.html",
                           @"img":@"http://omizco9tk.bkt.clouddn.com/xueyingyutext_101.jpg",
                           },
                       @{
                           @"title":@"其实英语很简单",
                           @"html":@"http://omizco9tk.bkt.clouddn.com/textxueyingyu102.html",
                           @"img":@"https://upload-images.jianshu.io/upload_images/1274527-725bdc5a0ef5a899.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240"
                           },
                       @{
                           @"title":@"学好英语的20个经典要诀",
                           @"html":@"http://omizco9tk.bkt.clouddn.com/textxueyingyu103.html",
                           @"img":@"http://omizco9tk.bkt.clouddn.com/xueyingyutext_103.jpg",
                           },
                       @{
                           @"title":@"学习英语的技巧",
                           @"html":@"http://omizco9tk.bkt.clouddn.com/textxueyingyu104.html",
                           @"img":@"http://omizco9tk.bkt.clouddn.com/xueyingyutext_104.jpg",
                           },
                       @{
                           @"title":@"不要把英语当作一门知识来学",
                           @"html":@"http://omizco9tk.bkt.clouddn.com/textxueyingyu105.html",
                           @"img":@"http://omizco9tk.bkt.clouddn.com/xueyingyutext_105.jpg",
                           },
                       @{
                           @"title":@"如何提高英语阅读能力?",
                           @"html":@"http://omizco9tk.bkt.clouddn.com/textxueyingyu106.html",
                           @"img":@"http://omizco9tk.bkt.clouddn.com/xueyingyutext_106.jpg",
                           },
                       @{
                           @"title":@"学好英语的几大策略",
                           @"html":@"http://omizco9tk.bkt.clouddn.com/textxueyingyu107.html",
                           @"img":@"http://omizco9tk.bkt.clouddn.com/xueyingyutext_107.jpg",
                           },
                       @{
                           @"title":@"英语是怎样“炼”成的：至少投入2000个小时",
                           @"html":@"http://omizco9tk.bkt.clouddn.com/textxueyingyu108.html",
                           @"img":@"http://omizco9tk.bkt.clouddn.com/xueyingyutext_108.jpg",
                           },
                       @{
                           @"title":@"英语学习方法论",
                           @"html":@"http://omizco9tk.bkt.clouddn.com/textxueyingyu109.html",
                           @"img":@"http://omizco9tk.bkt.clouddn.com/xueyingyutext_109.jpg",
                           },
                       @{
                           @"title":@"英语口语学习方法技巧",
                           @"html":@"http://omizco9tk.bkt.clouddn.com/textxueyingyu110.html",
                           @"img":@"http://omizco9tk.bkt.clouddn.com/xueyingyutext_110.jpg",
                           },
                       @{
                           @"title":@"学习英语要讲究方法",
                           @"html":@"http://omizco9tk.bkt.clouddn.com/textxueyingyu111.html",
                           @"img":@"http://omizco9tk.bkt.clouddn.com/xueyingyutext_111.jpg",
                           },
                       @{
                           @"title":@"学习英语要讲究方法",
                           @"html":@"http://omizco9tk.bkt.clouddn.com/textxueyingyu112.html",
                           @"img":@"http://omizco9tk.bkt.clouddn.com/xueyingyutext_112.jpg",
                           },
                       @{
                           @"title":@"英语学习中听说读写译技巧突破法",
                           @"html":@"http://omizco9tk.bkt.clouddn.com/textxueyingyu113.html",
                           @"img":@"http://omizco9tk.bkt.clouddn.com/xueyingyutext_113.jpg",
                           },
                       @{
                           @"title":@"听力练习方法",
                           @"html":@"http://omizco9tk.bkt.clouddn.com/textxueyingyu114.html",
                           @"img":@"http://omizco9tk.bkt.clouddn.com/xueyingyutext_114.jpg",
                           },
                       @{
                           @"title":@"英语词汇记忆方法大家谈",
                           @"html":@"http://omizco9tk.bkt.clouddn.com/textxueyingyu115.html",
                           @"img":@"http://omizco9tk.bkt.clouddn.com/xueyingyutext_115.jpg",
                           },
                       @{
                           @"title":@"命中注定是家人",
                           @"html":@"http://omizco9tk.bkt.clouddn.com/textxueyingyu201.html",
                           @"img":@"http://omizco9tk.bkt.clouddn.com/xueyingyutext_201.jpg",
                           },
                       @{
                           @"title":@"人类平均寿命将突破90岁 韩国最先达到",
                           @"html":@"http://omizco9tk.bkt.clouddn.com/textxueyingyu202.html",
                           @"img":@"http://omizco9tk.bkt.clouddn.com/xueyingyutext_202.jpg",
                           },
                       @{
                           @"title":@"经典款诺基亚重出江湖 3310回归还多了新功能",
                           @"html":@"http://omizco9tk.bkt.clouddn.com/textxueyingyu203.html",
                           @"img":@"http://omizco9tk.bkt.clouddn.com/xueyingyutext_203.jpg",
                           },
                       @{
                           @"title":@"10种对抗宿醉最好用的美食",
                           @"html":@"http://omizco9tk.bkt.clouddn.com/textxueyingyu204.html",
                           @"img":@"http://omizco9tk.bkt.clouddn.com/xueyingyutext_204.jpg",
                           },
                       @{
                           @"title":@"建议白领们工作一小时，运动五分钟",
                           @"html":@"http://omizco9tk.bkt.clouddn.com/textxueyingyu205.html",
                           @"img":@"http://omizco9tk.bkt.clouddn.com/xueyingyutext_205.jpg",
                           },
                       @{
                           @"title":@"喵星人说“我爱你”的8种方式",
                           @"html":@"http://omizco9tk.bkt.clouddn.com/textxueyingyu206.html",
                           @"img":@"http://omizco9tk.bkt.clouddn.com/xueyingyutext_206.jpg",
                           },
                       @{
                           @"title":@"《三体》选读之第三十二章《智子》",
                           @"html":@"http://omizco9tk.bkt.clouddn.com/textxueyingyu207.html",
                           @"img":@"http://omizco9tk.bkt.clouddn.com/xueyingyutext_207.jpg",
                           },
                       @{
                           @"title":@"NBA各球队名字的由来",
                           @"html":@"http://omizco9tk.bkt.clouddn.com/textxueyingyu208.html",
                           @"img":@"http://omizco9tk.bkt.clouddn.com/xueyingyutext_208.jpg",
                           },
                       @{
                           @"title":@"小心这6个迹象说明TA在对你撒谎",
                           @"html":@"http://omizco9tk.bkt.clouddn.com/textxueyingyu209.html",
                           @"img":@"http://omizco9tk.bkt.clouddn.com/xueyingyutext_209.jpg",
                           },
                       @{
                           @"title":@"整天坐办公室 7种妙招让你远离肥胖",
                           @"html":@"http://omizco9tk.bkt.clouddn.com/textxueyingyu210.html",
                           @"img":@"http://omizco9tk.bkt.clouddn.com/xueyingyutext_210.jpg",
                           },
                       @{
                           @"title":@"无肉不欢的人福音：吃肉也减肥哦！",
                           @"html":@"http://omizco9tk.bkt.clouddn.com/textxueyingyu211.html",
                           @"img":@"http://omizco9tk.bkt.clouddn.com/xueyingyutext_211.jpg",
                           },
                       @{
                           @"title":@"健康每一天 从一杯柠檬水开始",
                           @"html":@"http://omizco9tk.bkt.clouddn.com/textxueyingyu212.html",
                           @"img":@"http://omizco9tk.bkt.clouddn.com/xueyingyutext_212.jpg",
                           },
                       ];

    [self tableView];
    if (![LBLADMob sharedInstance].isRemoveAd) {
         __weak typeof(self) weakSelf = self;
        [LBLADMob GADBannerViewTabbarHeightWithVC:weakSelf];
        int adH = IS_PAD?90:50;
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, adH, 0);
        self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    }

}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.reads.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EnglishCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.bgTitleLabel.hidden = NO;
    cell.topLabel.hidden = NO;
    cell.logoLabel.hidden = YES;
    cell.bgTitleLabel.text = self.reads[indexPath.row][@"title"];

    [cell.bgImgView sd_setImageWithURL:[NSURL URLWithString:self.reads[indexPath.row][@"img"]] placeholderImage:[UIImage imageNamed:@"bg"]];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    YYWebController *webVC = [[YYWebController alloc] init];
    webVC.title = self.reads[indexPath.row][@"title"];
    webVC.urlStr = self.reads[indexPath.row][@"html"];
    
    [self.navigationController pushViewController:webVC animated:YES];
}

@end

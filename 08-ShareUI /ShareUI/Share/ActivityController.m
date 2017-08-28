//
//  Share.m
//  ShareUI
//
//  Created by pkss on 2017/5/10.
//  Copyright © 2017年 J. All rights reserved.
//

#import "ActivityController.h"
#import "ShareMenuCell.h"

#define kWidth      [UIScreen mainScreen].bounds.size.width
#define kHeight     [UIScreen mainScreen].bounds.size.height
#define kSpacing      10
#define ContentH    322
#define ContentW    kWidth-2*kSpacing

@implementation ItemModel

- (instancetype)initWithLogo:(NSString *)logo Name:(NSString *)name
{
    self = [super init];
    if (self) {
        _name = name;
        _logo = logo;
    }
    return self;
}

@end

@interface ActivityController () <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, weak) UITableView *contentView ;
@end

@implementation ActivityController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;

    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.3];

    UITableView *contentView = [[UITableView alloc] initWithFrame:CGRectMake(kSpacing,kHeight ,ContentW,ContentH) style:UITableViewStylePlain];
    contentView.backgroundColor = [UIColor clearColor];
    contentView.showsVerticalScrollIndicator = NO;
    contentView.scrollEnabled = NO;
    contentView.dataSource = self;
    contentView.delegate = self;
    [contentView registerNib:[UINib nibWithNibName:@"CannelCell" bundle:nil] forCellReuseIdentifier:@"CannelCell"];
    [contentView registerNib:[UINib nibWithNibName:@"ShareMenuCell" bundle:nil] forCellReuseIdentifier:@"ShareMenuCell"];

    [self.view addSubview:contentView];
    
    [UIView animateWithDuration:0.25 animations:^{
        contentView.frame = CGRectMake(kSpacing, kHeight-ContentH,ContentW,ContentH) ;
    }];
    _contentView = contentView;

}

- (void)setTopItems:(NSArray *)topItems
{
    _topItems = topItems;
    [self.contentView reloadData];
}

- (void)setButtomItems:(NSArray *)buttomItems
{
    _buttomItems = buttomItems;
    [self.contentView reloadData];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismiss];
}

- (void)dismiss{
    [UIView animateWithDuration:0.25 animations:^{
        self.view.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0];
        self.contentView.frame = CGRectMake(kSpacing, kHeight,ContentW,ContentH) ;
        
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:^{
            
        }];
    }];
}

 -(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==2) {
        [self dismiss];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
            return 118;
        
    }else if (indexPath.section == 1){
        return 128;

    }
    return 55;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *line = [UIView new];
    line.backgroundColor = [UIColor clearColor];
    return line;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        CannelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CannelCell"];
        return cell;
    }
    ShareMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShareMenuCell"];
    if (indexPath.section == 0) {
        cell.items = _topItems;
        
    }else if(indexPath.section == 1){
        cell.items = _buttomItems;
    }
    [cell setDidSelect:^(NSInteger index) {
        (!_didSelect)? :_didSelect([NSIndexPath indexPathForRow:index inSection:indexPath.section]);
        [self dismiss];

    }];

    return cell;
}




- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 2) {
        return ;
    }
    
    UIRectCorner corner;
    if (indexPath.section == 0) {
        corner = UIRectCornerTopLeft | UIRectCornerTopRight ;
    }else{
        corner = UIRectCornerBottomLeft | UIRectCornerBottomRight ;
    }
    
    cell.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:0.95];

    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = cell.bounds;
    maskLayer.path = maskPath.CGPath;
    cell.layer.mask = maskLayer;

}


@end

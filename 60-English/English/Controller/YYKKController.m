//
//  CXHomeController.m
//  ios
//
//  Created by ICHILD on 2018/1/23.
//  Copyright © 2018年 Ward Wong. All rights reserved.
//

#import "YYKKController.h"
#import "XYYModel.h"
#import "YYKKCell.h"
#import "YYWebController.h"

#import "Common.h"
#import "XYYHTTP.h"

#import <MJRefresh/MJRefresh.h>
#import <UIImageView+WebCache.h>

@interface YYKKController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource
>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong)  NSMutableArray <XYYModel *>*XYYmodelLists;

@property (nonatomic, assign) int index;

@end

@implementation YYKKController

-(UICollectionView *)collectionView {
    if (_collectionView == nil) {        
        UICollectionViewFlowLayout *xyy_layout = [[UICollectionViewFlowLayout alloc] init];
      
        xyy_layout.minimumInteritemSpacing = 5;
        
        xyy_layout.minimumLineSpacing = 5;
        
        xyy_layout.itemSize = CGSizeMake((ScreenWith - (IS_PAD?50:40)) / (IS_PAD?4:3.0), (ScreenWith - (IS_PAD?30:20)) / (IS_PAD?4:3.0)*1.5);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWith, ScreenHeight) collectionViewLayout:xyy_layout];
        
        _collectionView.dataSource = self;
        
        _collectionView.delegate = self;
        
        _collectionView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
        
        _collectionView.backgroundColor = kBackgroundColor;
        
        [self.view addSubview:_collectionView];
        
        [_collectionView registerNib:[UINib nibWithNibName:@"YYKKCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
        
        _collectionView.alwaysBounceVertical = YES;
    }
    
    return _collectionView;
}
-(NSMutableArray<XYYModel *> *)XYYmodelLists {
    if (_XYYmodelLists == nil) {
        _XYYmodelLists = [NSMutableArray new];
    }
    return _XYYmodelLists;
}



- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self collectionView];

    self.title = @"美剧";
    
    self.index = 1;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
    
        [self getModelWithIndex:self.index];
    }];
    
    self.collectionView.mj_footer = footer;
    
    [footer beginRefreshing];
    
    [footer setTitle:@"没有更多数据了~" forState:MJRefreshStateNoMoreData];
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.XYYmodelLists.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    YYKKCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
   
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:self.XYYmodelLists[indexPath.row].img] placeholderImage:[UIImage imageNamed:@"bg"]];
    
    cell.titleLabel.text = self.XYYmodelLists[indexPath.row].title;
    
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"PL"] boolValue]){
        
        UIAlertController *xyy_alertVC = [UIAlertController alertControllerWithTitle:@"好评解锁全部内容！" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *xyy_done = [UIAlertAction actionWithTitle:@"现在就去" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id1354357642?action=write-review"]];
            
            [XYYHTTP sharedInstance].beginTime = [NSDate new];
        }];
        
        UIAlertAction *xyy_cancel = [UIAlertAction actionWithTitle:@"下次再说" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        
        [xyy_alertVC addAction:xyy_done];
        
        [xyy_alertVC addAction:xyy_cancel];
        
        [self presentViewController:xyy_alertVC animated:YES completion:nil];
        
        return;
    }

    YYWebController *webVC = [YYWebController new];
   
    webVC.title = self.XYYmodelLists[indexPath.row].title;
    
    webVC.urlStr = self.XYYmodelLists[indexPath.row].bofang;
    
    [self.navigationController pushViewController:webVC animated:YES];
}


-(void)getModelWithIndex:(int)i {
    
    [[XYYHTTP sharedInstance] getRequest:[NSString stringWithFormat:@"http://taobao.jszks.net/index.php/Movie/dianshiju/type/meiju/p/%d",i] parameters:nil success:^(id respones) {
        
        NSArray <XYYModel *>*oneModels = [XYYModel objFormArray:respones[@"list"]];//[XYYModel mj_objectArrayWithKeyValuesArray:respones[@"list"]];
       
        if (oneModels.count < 10) {
          
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
           
            if (self.index == 1) {
           
            }else {
               
                [self.XYYmodelLists addObjectsFromArray:oneModels];
                
                [self.collectionView reloadData];
            }
            
        }else {
           
            if (self.index == 1) {
            
                [self.XYYmodelLists removeAllObjects];
            }
            
            [self.XYYmodelLists addObjectsFromArray:oneModels];
            
            [self.collectionView reloadData];
            
            [self.collectionView.mj_footer endRefreshing];
            
            self.index ++;
        }
        
    } failure:nil];
}

@end




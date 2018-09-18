//
//  BBKHomeController.m
//  BBKorean
//
//  Created by xin on 2018/3/27.
//  Copyright © 2018年 xin. All rights reserved.
//

#import "YYC_SS_HomeController.h"
#import "YYC_SS_DetailsController.h"
#import "YYCCell.h"
#import <MJRefresh/MJRefresh.h>
#import "YYCView.h"
#import "YYCRadioPlayerController.h"
#import "YYCSSController.h"
#import <DataManagerKit/DataManagerKit.h>

@interface YYC_SS_HomeController ()<UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UICollectionView *yycCollectionView;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSMutableArray *yycDicts;
@property (nonatomic, strong) UIView *yycBgView;
@property (nonatomic, strong) YYCView *bbk;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *maskView;

@property (nonatomic, strong) NSArray <NSString *>*titles;

@property (nonatomic, strong) NSString *URL;
@end

@implementation YYC_SS_HomeController


-(UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(-160, 0, 160, KScreenHeight-kTabbarHeight) style:UITableViewStylePlain];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"lcell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        [self.view addSubview:_tableView];
        
        [UIView animateWithDuration:0.25 animations:^{
            _tableView.transform = CGAffineTransformMakeTranslation(160, 0);
        }];
    }
    return _tableView;
}

-(void)tap {
    [UIView animateWithDuration:0.25 animations:^{
        self.tableView.transform = CGAffineTransformIdentity;
        self.maskView.alpha = 0;
    }completion:^(BOOL finished) {
        [self.tableView removeFromSuperview];
        self.tableView = nil;
        
        [self.maskView removeFromSuperview];
        self.maskView = nil;
    }];
    
}


-(UICollectionView *)yycCollectionView {
    if (_yycCollectionView == nil) {
        UICollectionViewFlowLayout *yycFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        yycFlowLayout.itemSize = CGSizeMake((KScreenWith - (IS_PAD?50:40)) / (IS_PAD?4:3.0), (KScreenWith - (IS_PAD?30:20)) / (IS_PAD?4:3.0)*1.5);
        yycFlowLayout.minimumInteritemSpacing = 5;
        yycFlowLayout.minimumLineSpacing = 5;
        
        _yycCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:yycFlowLayout];
        _yycCollectionView.dataSource = self;
        _yycCollectionView.delegate = self;
        _yycCollectionView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
        _yycCollectionView.backgroundColor = kBackgroundColor;
        [self.view addSubview:_yycCollectionView];
        [_yycCollectionView registerNib:[UINib nibWithNibName:@"YYCCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
        _yycCollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self loadData];
        }];
        [_yycCollectionView.mj_footer beginRefreshing];
    }
    
    return _yycCollectionView;
}


-(NSMutableArray *)yycDicts {
    if (_yycDicts == nil) {
        _yycDicts = [NSMutableArray array];
    }
    return _yycDicts;
}

-(void)loadData {
    
    if (appManger) {
       
        [[Manager sharedInstance] initInterstitial];

        [Manager getHKTVPage:self.index urlStr:self.URL.length>0?self.URL:@"http://wap.ykmov.com/index.php?m=vod-list-id-13-pg-1-order--by--class-0-year-0-letter--area--lang-.html" block:^(NSArray<NSDictionary *> *yycDicts) {
            
            dispatch_async(dispatch_get_main_queue(), ^{

                [self.yycDicts addObjectsFromArray:yycDicts];
                if (yycDicts.count>0) self.index ++;
                [_yycCollectionView.mj_footer endRefreshing];
                [self.yycCollectionView reloadData];
            });
        }];
    }else {
        
        self.yycDicts =  [[self getDainShiData] mutableCopy];//[radios mutableCopy];
        [Manager sharedInstance].allDicts = self.yycDicts;
        [self.yycCollectionView reloadData];
        [_yycCollectionView.mj_footer endRefreshing];
        _yycCollectionView.mj_footer.hidden = YES;
    }
}

-(NSArray *)getDainShiData {
    
    NSData *jsonData = [[NSData alloc]initWithBase64EncodedString:[self jsonBase64Str] options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:NULL];
}


-(NSString *)jsonBase64Str {
    return @"WwogIHsKICAgICJpbWciIDogImh0dHA6XC9cL2ltZzEuZG91YmFuaW8uY29tXC92aWV3XC9waG90b1wvc19yYXRpb19wb3N0ZXJcL3B1YmxpY1wvcDI1MTM0NjM4MjcuanBnIiwKICAgICJ0aXRsZSIgOiAi57Kk6K+t56ys5LiA5Y+wIiwKICAgICJ1cmwiIDogImh0dHA6XC9cLzIwMi4xNzcuMTkyLjEyMFwvcmFkaW8xIgogIH0sCiAgewogICAgImltZyIgOiAiaHR0cDpcL1wvd3gzLnNpbmFpbWcuY25cL213NjkwXC8wMDZKYWlHZGd5MWZwanBxeWpkeW5qMzA3aTA5dWdvZS5qcGciLAogICAgInRpdGxlIiA6ICLnsqTor63nrKzkuozlj7AiLAogICAgInVybCIgOiAiaHR0cDpcL1wvMjAyLjE3Ny4xOTIuMTIwXC9yYWRpbzIiCiAgfSwKICB7CiAgICAiaW1nIiA6ICJodHRwOlwvXC93eDEuc2luYWltZy5jblwvbXc2OTBcLzAwNkphaUdkZ3kxZnBzOTg0ZnQ3ZmozMDdpMGI4NDIxLmpwZyIsCiAgICAidGl0bGUiIDogIueypOivreesrOS4ieWPsCIsCiAgICAidXJsIiA6ICJodHRwOlwvXC8yMDIuMTc3LjE5Mi4xMjBcL3JhZGlvMyIKICB9LAogIHsKICAgICJpbWciIDogImh0dHA6XC9cL3d4MS5zaW5haW1nLmNuXC9tdzY5MFwvMDA2SmFpR2RneTFmb3NlY3Z5Zzg0ajMwaDEwbjRiMjkuanBnIiwKICAgICJ0aXRsZSIgOiAi57Kk6K+t56ys5Zub5Y+wIiwKICAgICJ1cmwiIDogImh0dHA6XC9cLzIwMi4xNzcuMTkyLjEyMFwvcmFkaW80IgogIH0sCiAgewogICAgImltZyIgOiAiaHR0cDpcL1wvd3g0LnNpbmFpbWcuY25cL213NjkwXC8wMDZKYWlHZGd5MWZuYXQ5NHJjanlqMzA3aTBhdzN5eC5qcGciLAogICAgInRpdGxlIiA6ICLnsqTor63nrKzkupTlj7AiLAogICAgInVybCIgOiAiaHR0cDpcL1wvMjAyLjE3Ny4xOTIuMTIwXC9yYWRpbzUiCiAgfSwKICB7CiAgICAiaW1nIiA6ICJodHRwczpcL1wvdXBsb2FkLWltYWdlcy5qaWFuc2h1LmlvXC91cGxvYWRfaW1hZ2VzXC8xMjc0NTI3LTM3ZWJmN2U3ZmY2YWE2ZDEuanBnP2ltYWdlTW9ncjJcL2F1dG8tb3JpZW50XC9zdHJpcCU3Q2ltYWdlVmlldzJcLzJcL3dcLzEyNDAiLAogICAgInRpdGxlIiA6ICLmuK/lj7BSVEhLMzEiLAogICAgInVybCIgOiAiaHR0cDpcL1wvZDJhZ2xqZG91ZzN6MGouY2xvdWRmcm9udC5uZXRcL3JhZGlvLUhUVFBcL2NyMi1oZC4zZ3BcL3BsYXlsaXN0Lm0zdTgiCiAgfSwKICB7CiAgICAiaW1nIiA6ICJodHRwczpcL1wvdXBsb2FkLWltYWdlcy5qaWFuc2h1LmlvXC91cGxvYWRfaW1hZ2VzXC8xMjc0NTI3LTM3ZWJmN2U3ZmY2YWE2ZDEuanBnP2ltYWdlTW9ncjJcL2F1dG8tb3JpZW50XC9zdHJpcCU3Q2ltYWdlVmlldzJcLzJcL3dcLzEyNDAiLAogICAgInRpdGxlIiA6ICLmuK/lj7BSVEhLMzIiLAogICAgInVybCIgOiAiaHR0cDpcL1wvcnRoa2F1ZGlvNS1saC5ha2FtYWloZC5uZXRcL2lcL3JhZGlvNV8xQDM1NTg2OFwvbWFzdGVyLm0zdTgiCiAgfSwKICB7CiAgICAiaW1nIiA6ICJodHRwczpcL1wvdXBsb2FkLWltYWdlcy5qaWFuc2h1LmlvXC91cGxvYWRfaW1hZ2VzXC8xMjc0NTI3LTQ0ZWIxOTY0ZmQyYzMzMTAuanBnP2ltYWdlTW9ncjJcL2F1dG8tb3JpZW50XC9zdHJpcCU3Q2ltYWdlVmlldzJcLzJcL3dcLzEyNDAiLAogICAgInRpdGxlIiA6ICLpppnmuK8gU2F0ZWxsaXRlIiwKICAgICJ1cmwiIDogImh0dHA6XC9cLzEwMy4xMS4xMDIuNjI6ODAwMFwvdGFsa29ubHkubXAzIgogIH0sCiAgewogICAgImltZyIgOiAiaHR0cHM6XC9cL3VwbG9hZC1pbWFnZXMuamlhbnNodS5pb1wvdXBsb2FkX2ltYWdlc1wvMTI3NDUyNy1iZTg3YjE3ODBhZWE3NzdhLnBuZz9pbWFnZU1vZ3IyXC9hdXRvLW9yaWVudFwvc3RyaXAlN0NpbWFnZVZpZXcyXC8yXC93XC8xMjQwIiwKICAgICJ0aXRsZSIgOiAiVFZCIFN0YXRpb24iLAogICAgInVybCIgOiAiaHR0cDpcL1wvbGl2ZTQudGRtLmNvbS5tb1wvcmFkaW9cL3JjaDIubGl2ZVwvcGxheWxpc3QubTN1OCIKICB9LAogIHsKICAgICJpbWciIDogImh0dHBzOlwvXC91cGxvYWQtaW1hZ2VzLmppYW5zaHUuaW9cL3VwbG9hZF9pbWFnZXNcLzEyNzQ1MjctYmU4N2IxNzgwYWVhNzc3YS5wbmc/aW1hZ2VNb2dyMlwvYXV0by1vcmllbnRcL3N0cmlwJTdDaW1hZ2VWaWV3MlwvMlwvd1wvMTI0MCIsCiAgICAidGl0bGUiIDogIuaXoOe6v+aWsOmXu+WPsCIsCiAgICAidXJsIiA6ICJodHRwOlwvXC9saHR0cC5xaW5ndGluZy5mbVwvbGl2ZVwvMTI2NVwvNjRrLm1wMyIKICB9LAogIHsKICAgICJpbWciIDogImh0dHBzOlwvXC91cGxvYWQtaW1hZ2VzLmppYW5zaHUuaW9cL3VwbG9hZF9pbWFnZXNcLzEyNzQ1MjctMWIwYjllMDFjNTlkYjJkMS5wbmc/aW1hZ2VNb2dyMlwvYXV0by1vcmllbnRcL3N0cmlwJTdDaW1hZ2VWaWV3MlwvMlwvd1wvMTI0MCIsCiAgICAidGl0bGUiIDogIummmea4r+esrOS6lOWPsCIsCiAgICAidXJsIiA6ICJodHRwOlwvXC9kM2NhM3hjY3E1ejVodS5jbG91ZGZyb250Lm5ldFwvcmFkaW8tSFRUUFwvY3IxLWhkLjNncFwvY2h1bmtsaXN0Lm0zdTgiCiAgfSwKICB7CiAgICAiaW1nIiA6ICJodHRwczpcL1wvdXBsb2FkLWltYWdlcy5qaWFuc2h1LmlvXC91cGxvYWRfaW1hZ2VzXC8xMjc0NTI3LTRhZWRhNGE1MzhjNDVmMGMucG5nP2ltYWdlTW9ncjJcL2F1dG8tb3JpZW50XC9zdHJpcCU3Q2ltYWdlVmlldzJcLzJcL3dcLzEyNDAiLAogICAgInRpdGxlIiA6ICLpppnmuK/mma7pgJror50iLAogICAgInVybCIgOiAiaHR0cDpcL1wvcnRoa2F1ZGlvNi1saC5ha2FtYWloZC5uZXRcL2lcL3JhZGlvcHRoXzFAMzU1ODY5XC9tYXN0ZXIubTN1OCIKICB9LAogIHsKICAgICJpbWciIDogImh0dHBzOlwvXC91cGxvYWQtaW1hZ2VzLmppYW5zaHUuaW9cL3VwbG9hZF9pbWFnZXNcLzEyNzQ1MjctYjMxY2E5ZDAxNzhmNDQxYy5wbmc/aW1hZ2VNb2dyMlwvYXV0by1vcmllbnRcL3N0cmlwJTdDaW1hZ2VWaWV3MlwvMlwvd1wvMTI0MCIsCiAgICAidGl0bGUiIDogIummmea4r0ZNIDg4LjFNSFoiLAogICAgInVybCIgOiAiaHR0cDpcL1wvZDNjYTN4Y2NxNXo1aHUuY2xvdWRmcm9udC5uZXRcL3JhZGlvLUhUVFBcL2NyMi1oZC4zZ3BcL2NodW5rbGlzdC5tM3U4IgogIH0sCiAgewogICAgImltZyIgOiAiaHR0cHM6XC9cL3VwbG9hZC1pbWFnZXMuamlhbnNodS5pb1wvdXBsb2FkX2ltYWdlc1wvMTI3NDUyNy01OTIyNjBhMDg2NzUyM2Y5LnBuZz9pbWFnZU1vZ3IyXC9hdXRvLW9yaWVudFwvc3RyaXAlN0NpbWFnZVZpZXcyXC8yXC93XC8xMjQwIiwKICAgICJ0aXRsZSIgOiAi6aaZ5rivRk0gOTAuM01IWiIsCiAgICAidXJsIiA6ICJodHRwOlwvXC9ydGhrYXVkaW8xLWxoLmFrYW1haWhkLm5ldFwvaVwvcmFkaW8xXzFAMzU1ODY0XC9pbmRleF81Nl9hLWIubTN1OD9zZD0xMCZyZWJhc2U9b24iCiAgfSwKICB7CiAgICAiaW1nIiA6ICJodHRwczpcL1wvdXBsb2FkLWltYWdlcy5qaWFuc2h1LmlvXC91cGxvYWRfaW1hZ2VzXC8xMjc0NTI3LTBjZWViZDA4YTM5YmQ0NTEucG5nP2ltYWdlTW9ncjJcL2F1dG8tb3JpZW50XC9zdHJpcCU3Q2ltYWdlVmlldzJcLzJcL3dcLzEyNDAiLAogICAgInRpdGxlIiA6ICLmlrDln47otKLnu4/lj7AiLAogICAgInVybCIgOiAiaHR0cDpcL1wvZDNjYTN4Y2NxNXo1aHUuY2xvdWRmcm9udC5uZXRcL3JhZGlvLUhUVFBcL2NyMS1oZC4zZ3BcL2NodW5rbGlzdC5tM3U4IgogIH0sCiAgewogICAgImltZyIgOiAiaHR0cHM6XC9cL3VwbG9hZC1pbWFnZXMuamlhbnNodS5pb1wvdXBsb2FkX2ltYWdlc1wvMTI3NDUyNy04NWRmMWNjZTkxMzU4YWUyLnBuZz9pbWFnZU1vZ3IyXC9hdXRvLW9yaWVudFwvc3RyaXAlN0NpbWFnZVZpZXcyXC8yXC93XC8xMjQwIiwKICAgICJ0aXRsZSIgOiAi5paw5Z+O6LWE6K6v5Y+wIiwKICAgICJ1cmwiIDogImh0dHA6XC9cL21ldHJvcmFkaW8tbGguYWthbWFpaGQubmV0XC9pXC8xMDRfaEAzNDk3OThcL21hc3Rlci5tM3U4IgogIH0sCiAgewogICAgImltZyIgOiAiaHR0cHM6XC9cL3VwbG9hZC1pbWFnZXMuamlhbnNodS5pb1wvdXBsb2FkX2ltYWdlc1wvMTI3NDUyNy0zOWY3NzZmYWI5ZWExOWFmLnBuZz9pbWFnZU1vZ3IyXC9hdXRvLW9yaWVudFwvc3RyaXAlN0NpbWFnZVZpZXcyXC8yXC93XC8xMjQwIiwKICAgICJ0aXRsZSIgOiAiTWV0cm8gUGx1cyIsCiAgICAidXJsIiA6ICJodHRwOlwvXC9tZXRyb3JhZGlvLWxoLmFrYW1haWhkLm5ldFwvaVwvMTA0NF9oQDM0OTgwMFwvbWFzdGVyLm0zdTgiCiAgfSwKICB7CiAgICAiaW1nIiA6ICJodHRwczpcL1wvdXBsb2FkLWltYWdlcy5qaWFuc2h1LmlvXC91cGxvYWRfaW1hZ2VzXC8xMjc0NTI3LTg2YzI4ZDIyNjhjZjgxZWIucG5nP2ltYWdlTW9ncjJcL2F1dG8tb3JpZW50XC9zdHJpcCU3Q2ltYWdlVmlldzJcLzJcL3dcLzEyNDAiLAogICAgInRpdGxlIiA6ICJEMTAwIFBCUyIsCiAgICAidXJsIiA6ICJodHRwOlwvXC81OS4xNTIuMjMyLjEwODo4MDAwXC9DaGFubmVsMS0xMjhBQUMiCiAgfSwKICB7CiAgICAiaW1nIiA6ICJodHRwczpcL1wvdXBsb2FkLWltYWdlcy5qaWFuc2h1LmlvXC91cGxvYWRfaW1hZ2VzXC8xMjc0NTI3LTU3MTc0MjMzZGUyNDZiY2MucG5nP2ltYWdlTW9ncjJcL2F1dG8tb3JpZW50XC9zdHJpcCU3Q2ltYWdlVmlldzJcLzJcL3dcLzEyNDAiLAogICAgInRpdGxlIiA6ICLmvrPpl6jnlLXlj7AiLAogICAgInVybCIgOiAiaHR0cDpcL1wvbGl2ZTQudGRtLmNvbS5tb1wvcmFkaW9cL3JjaDIubGl2ZVwvcGxheWxpc3QubTN1OCIKICB9LAogIHsKICAgICJpbWciIDogImh0dHBzOlwvXC91cGxvYWQtaW1hZ2VzLmppYW5zaHUuaW9cL3VwbG9hZF9pbWFnZXNcLzEyNzQ1MjctMGQ0YjczZTg3YzBiZjBmNC5wbmc/aW1hZ2VNb2dyMlwvYXV0by1vcmllbnRcL3N0cmlwJTdDaW1hZ2VWaWV3MlwvMlwvd1wvMTI0MCIsCiAgICAidGl0bGUiIDogIlN0YXRpb24iLAogICAgInVybCIgOiAiaHR0cDpcL1wvcmZhaGxzLWkuYWthbWFpaGQubmV0XC9obHNcL2xpdmVcLzIyNjIzMlwvUkZBTGl2ZV8xXC9pbmRleC5tM3U4IgogIH0sCiAgewogICAgImltZyIgOiAiaHR0cHM6XC9cL2kubG9saS5uZXRcLzIwMThcLzA5XC8xMlwvNWI5OGM3YmJiNWE3ZS5qcGVnIiwKICAgICJ1cmwiIDogImh0dHA6XC9cL2xodHRwLnFpbmd0aW5nLmZtXC9saXZlXC81MDIyMzA4XC82NGsubXAzIiwKICAgICJ0aXRsZSIgOiAi57uP5YW45Y2O6K+t6Z+z5LmQIgogIH0sCiAgewogICAgImltZyIgOiAiaHR0cHM6XC9cL2kubG9saS5uZXRcLzIwMThcLzA5XC8xMlwvNWI5OGM3YmJiNWE3ZS5qcGVnIiwKICAgICJ1cmwiIDogImh0dHA6XC9cL2xodHRwLnFpbmd0aW5nLmZtXC9saXZlXC8xNTMxNzkyM1wvNjRrLm1wMyIsCiAgICAidGl0bGUiIDogIue7j+WFuOeypOivremfs+S5kCIKICB9LAogIHsKICAgICJpbWciIDogImh0dHBzOlwvXC9pLmxvbGkubmV0XC8yMDE4XC8wOVwvMTJcLzViOThjN2JiYjVhN2UuanBlZyIsCiAgICAidXJsIiA6ICJodHRwOlwvXC9saHR0cC5xaW5ndGluZy5mbVwvbGl2ZVwvNDU3NlwvNjRrLm1wMyIsCiAgICAidGl0bGUiIDogIumdkuiLueaenOmfs+S5kCIKICB9LAogIHsKICAgICJpbWciIDogImh0dHBzOlwvXC9pLmxvbGkubmV0XC8yMDE4XC8wOVwvMTJcLzViOThjN2JiYjVhN2UuanBlZyIsCiAgICAidXJsIiA6ICJodHRwOlwvXC9saHR0cC5xaW5ndGluZy5mbVwvbGl2ZVwvNDkxNVwvNjRrLm1wMyIsCiAgICAidGl0bGUiIDogIua4heaZqOmfs+S5kOWPsCIKICB9LAogIHsKICAgICJpbWciIDogImh0dHBzOlwvXC9pLmxvbGkubmV0XC8yMDE4XC8wOVwvMTJcLzViOThjN2JiYjVhN2UuanBlZyIsCiAgICAidXJsIiA6ICJodHRwOlwvXC9saHR0cC5xaW5ndGluZy5mbVwvbGl2ZVwvNTAyMjMxNFwvNjRrLm1wMyIsCiAgICAidGl0bGUiIDogIjHkurox6aaW5oiQ5ZCN5puyIgogIH0sCiAgewogICAgInRpdGxlIiA6ICLlub/kuJznlLXlj7Dpn7PkuZDkuYvlo7AiLAogICAgInVybCIgOiAiaHR0cDpcL1wvY3R0LnJnZC5jb20uY25cL2ZtOTkzIiwKICAgICJpbWciIDogImh0dHA6XC9cL2ltYWdlLnRpbmJlcmZtLmNvbVwvXC91cGxvYWRuZXdcLzMzMDQ0MTQ5MzExMzAyNS5qcGciCiAgfSwKICB7CiAgICAidGl0bGUiIDogIuS4reWxseeUteWPsOW/q+S5kCA4ODgiLAogICAgInVybCIgOiAiaHR0cDpcL1wvcGlsaS1saXZlLWhscy5xaW5pdS50aW5iZXJmbS5jb21cL2xpdmUteXVhbnl1XC96c3JhZGlvLm0zdTgiLAogICAgImltZyIgOiAiaHR0cDpcL1wvaW1hZ2UudGluYmVyZm0uY29tXC9cL3VwbG9hZG5ld1wvNzYzMTYxNDY3MDQ4OTYzLmpwZyIKICB9LAogIHsKICAgICJ0aXRsZSIgOiAi5oCA6ZuG6Z+z5LmQ5LmL5aOwIiwKICAgICJ1cmwiIDogImh0dHA6XC9cL2xpdmUueG1jZG4uY29tXC9saXZlXC8xMjA1XC82NC5tM3U4IiwKICAgICJpbWciIDogImh0dHA6XC9cL2ltYWdlLnRpbmJlcmZtLmNvbVwvXC91cGxvYWRuZXdcLzQyMTU5MTQ3MTU5NjgzOS5qcGciCiAgfSwKICB7CiAgICAidGl0bGUiIDogIua3seWcs+mjnuaJrOmfs+S5kCIsCiAgICAidXJsIiA6ICJodHRwOlwvXC9saHR0cC5xaW5ndGluZy5mbVwvbGl2ZVwvMTI3MVwvNjRrLm1wMyIsCiAgICAiaW1nIiA6ICJodHRwOlwvXC9pbWFnZS50aW5iZXJmbS5jb21cL1wvdXBsb2FkbmV3XC82MTA4NjE0NzE2NzU0MTcuanBnIgogIH0sCiAgewogICAgInRpdGxlIiA6ICLlub/kuJzogqHluILlub/mkq0iLAogICAgInVybCIgOiAiaHR0cDpcL1wvbGh0dHAucWluZ3RpbmcuZm1cL2xpdmVcLzQ4NDdcLzY0ay5tcDMiLAogICAgImltZyIgOiAiaHR0cDpcL1wvaW1hZ2UudGluYmVyZm0uY29tXC9cL3VwbG9hZG5ld1wvNTQ5MzYxNDcxNjc1NjczLmpwZyIKICB9LAogIHsKICAgICJ0aXRsZSIgOiAi5rex5Zyz5YWI6ZSLIiwKICAgICJ1cmwiIDogImh0dHA6XC9cL2xodHRwLnFpbmd0aW5nLmZtXC9saXZlXC8xMjcwXC82NGsubXAzIiwKICAgICJpbWciIDogImh0dHA6XC9cL2ltYWdlLnRpbmJlcmZtLmNvbVwvXC91cGxvYWRuZXdcLzM1NDg4MTQ3MTU5NTk1NS5qcGciCiAgfSwKICB7CiAgICAidGl0bGUiIDogIuS9m+WxseeUteWPsOecn+eIsSIsCiAgICAidXJsIiA6ICJodHRwOlwvXC9saHR0cC5xaW5ndGluZy5mbVwvbGl2ZVwvMTI2NVwvNjRrLm1wMyIsCiAgICAiaW1nIiA6ICJodHRwOlwvXC9pbWFnZS50aW5iZXJmbS5jb21cL1wvdXBsb2FkbmV3XC8yMDEzOTE0NzAxMzM1MTYuanBnIgogIH0sCiAgewogICAgInRpdGxlIiA6ICLmt7HlnLPkuqTpgJrlub/mkq0iLAogICAgInVybCIgOiAiaHR0cDpcL1wvbGh0dHAucWluZ3RpbmcuZm1cL2xpdmVcLzEyNzJcLzY0ay5tcDMiLAogICAgImltZyIgOiAiaHR0cDpcL1wvaW1hZ2UudGluYmVyZm0uY29tXC9cL3VwbG9hZG5ld1wvOTEyODkxNDcxNTkwODA4LmpwZyIKICB9LAogIHsKICAgICJ0aXRsZSIgOiAi5paw5Lya5Lq65rCR5bm/5pKt55S15Y+wIiwKICAgICJ1cmwiIDogImh0dHA6XC9cL2xodHRwLnFpbmd0aW5nLmZtXC9saXZlXC81MDYxXC82NGsubXAzIiwKICAgICJpbWciIDogImh0dHA6XC9cL2ltYWdlLnRpbmJlcmZtLmNvbVwvXC91cGxvYWRuZXdcLzQ3MjIzMTQ4NzA1MTU3Ni5qcGciCiAgfSwKICB7CiAgICAidGl0bGUiIDogIumDgeWNl+mfs+S5kOWPsCIsCiAgICAidXJsIiA6ICJodHRwOlwvXC9waWxpLWxpdmUtaGxzLnFpbml1LnRpbmJlcmZtLmNvbVwvbGl2ZS15dWFueXVcL3lueXl0Lm0zdTgiLAogICAgImltZyIgOiAiaHR0cDpcL1wvaW1hZ2UudGluYmVyZm0uY29tXC9cL3VwbG9hZG5ld1wvODc5NTMxNDc4MTQ2NTUzLmpwZyIKICB9LAogIHsKICAgICJ0aXRsZSIgOiAi6bmk5bGx55S15Y+wIiwKICAgICJ1cmwiIDogImh0dHA6XC9cL2xodHRwLnFpbmd0aW5nLmZtXC9saXZlXC8xMjg2XC82NGsubXAzIiwKICAgICJpbWciIDogImh0dHA6XC9cL2ltYWdlLnRpbmJlcmZtLmNvbVwvXC91cGxvYWRuZXdcLzMzMzk5MTQ3MTY3NDIzNS5qcGciCiAgfSwKICB7CiAgICAidGl0bGUiIDogIuS4reWxseeUteWPsOaWsOmUkCA5NjciLAogICAgInVybCIgOiAiaHR0cDpcL1wvcGlsaS1saXZlLWhscy5xaW5pdS50aW5iZXJmbS5jb21cL2xpdmUteXVhbnl1XC96c2R0eHI5NjcubTN1OCIsCiAgICAiaW1nIiA6ICJodHRwOlwvXC9pbWFnZS50aW5iZXJmbS5jb21cL1wvdXBsb2FkbmV3XC8yNzU3MzE0Njk2NzIxODAuanBnIgogIH0sCiAgewogICAgInRpdGxlIiA6ICLlub/lt57oirHpg73lub/mkq0iLAogICAgInVybCIgOiAiaHR0cDpcL1wvcGlsaS1saXZlLWhscy5xaW5pdS50aW5iZXJmbS5jb21cL2xpdmUteXVhbnl1XC9nemhkZ2IubTN1OCIsCiAgICAiaW1nIiA6ICJodHRwOlwvXC9pbWFnZS50aW5iZXJmbS5jb21cL1wvdXBsb2FkbmV3XC82NTcwODE0OTMxMTQwMDcuanBnIgogIH0sCiAgewogICAgInRpdGxlIiA6ICLnj6DmtbfnlLXlj7DmtLvlipsiLAogICAgInVybCIgOiAiaHR0cDpcL1wvbGh0dHAucWluZ3RpbmcuZm1cL2xpdmVcLzUwMjE3MjVcLzY0ay5tcDMiLAogICAgImltZyIgOiAiaHR0cDpcL1wvaW1hZ2UudGluYmVyZm0uY29tXC9cL3VwbG9hZG5ld1wvNjM5OTkxNDcxNTk3MzY0LmpwZyIKICB9LAogIHsKICAgICJ0aXRsZSIgOiAi5qKF5bee56eB5a626L2m5bm/5pKtIiwKICAgICJ1cmwiIDogImh0dHA6XC9cL2xodHRwLnFpbmd0aW5nLmZtXC9saXZlXC81MDIxOTQyXC82NGsubXAzIiwKICAgICJpbWciIDogImh0dHA6XC9cL2ltYWdlLnRpbmJlcmZtLmNvbVwvXC91cGxvYWRuZXdcLzcyODY3MTQ3MTY3NTkzNC5qcGciCiAgfSwKICB7CiAgICAidGl0bGUiIDogIua3seWcs+m+meWyl+eUteWPsOaYn+WFiSIsCiAgICAidXJsIiA6ICJodHRwOlwvXC9saXZlLnhtY2RuLmNvbVwvbGl2ZVwvMjY2XC82NC5tM3U4IiwKICAgICJpbWciIDogImh0dHA6XC9cL2ltYWdlLnRpbmJlcmZtLmNvbVwvXC91cGxvYWRuZXdcLzYwMTYyMTQ3MTY3NDgyMy5qcGciCiAgfSwKICB7CiAgICAidGl0bGUiIDogIuS7juWMlua1gea6quays+S5i+WjsCIsCiAgICAidXJsIiA6ICJodHRwOlwvXC9saHR0cC5xaW5ndGluZy5mbVwvbGl2ZVwvMTUzMTg2OThcLzY0ay5tcDMiLAogICAgImltZyIgOiAiaHR0cDpcL1wvaW1hZ2UudGluYmVyZm0uY29tXC9cL3VwbG9hZG5ld1wvMjY0ODUxNDcyMTI4MTA4LmpwZyIKICB9LAogIHsKICAgICJ0aXRsZSIgOiAi6Z+25YWz5Lqk6YCa5peF5ri45bm/5pKtIiwKICAgICJ1cmwiIDogImh0dHA6XC9cL2xodHRwLnFpbmd0aW5nLmZtXC9saXZlXC81MDIyMDc1XC82NGsubXAzIiwKICAgICJpbWciIDogImh0dHA6XC9cL2ltYWdlLnRpbmJlcmZtLmNvbVwvXC91cGxvYWRuZXdcLzk4OTE1MTQ3MjExNzY1MS5qcGciCiAgfSwKICB7CiAgICAidGl0bGUiIDogIuW5v+ilv+aWh+iJuuW5v+aSrSBNdXNpYyBSYWRpbyIsCiAgICAidXJsIiA6ICJodHRwOlwvXC9tZWRpYTIuYmJydHYuY29tOjE5MzVcL2xpdmVcL19kZWZpbnN0X1wvOTUwXC9wbGF5bGlzdC5tM3U4IiwKICAgICJpbWciIDogImh0dHA6XC9cL2ltYWdlLnRpbmJlcmZtLmNvbVwvXC91cGxvYWRuZXdcLzYzNjE3MTQ2NzA0ODkyMi5qcGciCiAgfSwKICB7CiAgICAidGl0bGUiIDogIuW5v+ilvyA5NzAg5aWz5Li75pKt55S15Y+wIiwKICAgICJ1cmwiIDogImh0dHA6XC9cL21lZGlhMi5iYnJ0di5jb206MTkzNVwvbGl2ZVwvX2RlZmluc3RfXC85NzBcL3BsYXlsaXN0Lm0zdTgiLAogICAgImltZyIgOiAiaHR0cDpcL1wvaW1hZ2UudGluYmVyZm0uY29tXC9cL3VwbG9hZG5ld1wvNzEwMjgxNDY3MDQ4OTQ2LmpwZyIKICB9LAogIHsKICAgICJ0aXRsZSIgOiAi5Y2X5a6B55S15Y+w57uP5YW4IDEwNDkiLAogICAgInVybCIgOiAiaHR0cDpcL1wvbGh0dHAucWluZ3RpbmcuZm1cL2xpdmVcLzIwNzY5XC82NGsubXAzIiwKICAgICJpbWciIDogImh0dHA6XC9cL2ltYWdlLnRpbmJlcmZtLmNvbVwvXC91cGxvYWRuZXdcLzg5NDA4MTQ3MjEyMjM4OS5qcGciCiAgfSwKICB7CiAgICAidGl0bGUiIDogIuWNl+WugeeUteWPsOWKqOaEnzg5NSIsCiAgICAidXJsIiA6ICJodHRwOlwvXC9waWxpLWxpdmUtaGxzLnFpbml1LnRpbmJlcmZtLmNvbVwvbGl2ZS15dWFueXVcL25uZHRkZzg5NS5tM3U4IiwKICAgICJpbWciIDogImh0dHA6XC9cL2ltYWdlLnRpbmJlcmZtLmNvbVwvXC91cGxvYWRuZXdcLzI1NzQyMTQ5MjQxOTE1Mi5qcGciCiAgfSwKICB7CiAgICAidGl0bGUiIDogIueOieael+S6pOmAmumfs+S5kOW5v+aSrSIsCiAgICAidXJsIiA6ICJodHRwOlwvXC9saHR0cC5xaW5ndGluZy5mbVwvbGl2ZVwvMTc2M1wvNjRrLm1wMyIsCiAgICAiaW1nIiA6ICJodHRwOlwvXC9pbWFnZS50aW5iZXJmbS5jb21cL1wvdXBsb2FkbmV3XC81NDk0MjE0Njk2NzExODIuanBnIgogIH0sCiAgewogICAgInRpdGxlIiA6ICLotLrlt57nlLXlj7DkuqTpgJrpn7PkuZDlub/mkq0iLAogICAgInVybCIgOiAiaHR0cDpcL1wvcGlsaS1saXZlLWhscy5xaW5pdS50aW5iZXJmbS5jb21cL2xpdmUteXVhbnl1XC9oemR0anR5bGdiLm0zdTgiLAogICAgImltZyIgOiAiaHR0cDpcL1wvaW1hZ2UudGluYmVyZm0uY29tXC9cL3VwbG9hZG5ld1wvOTA1MTUxNDY5NjcyNjU5LmpwZyIKICB9LAogIHsKICAgICJ0aXRsZSIgOiAi5bm/6KW/5peF5ri45bm/5pKtIiwKICAgICJ1cmwiIDogImh0dHA6XC9cL21lZGlhLmJicnR2LmNvbToxOTM1XC9saXZlXC9fZGVmaW5zdF9cL2x5cGxcL3BsYXlsaXN0Lm0zdTgiLAogICAgImltZyIgOiAiaHR0cDpcL1wvaW1hZ2UudGluYmVyZm0uY29tXC9cL3VwbG9hZG5ld1wvNDE0MzYxNDcxNjczMjkzLmpwZyIKICB9LAogIHsKICAgICJ0aXRsZSIgOiAi6LS65bee55S15Y+w5paw6Ze757u85ZCI5bm/5pKtIiwKICAgICJ1cmwiIDogImh0dHA6XC9cL3BpbGktbGl2ZS1obHMucWluaXUudGluYmVyZm0uY29tXC9saXZlLXl1YW55dVwvaHpkdHh3emhnYi5tM3U4IiwKICAgICJpbWciIDogImh0dHA6XC9cL2ltYWdlLnRpbmJlcmZtLmNvbVwvXC91cGxvYWRuZXdcLzI4NjM3MTQ3MDEyOTUyMS5qcGciCiAgfQpd";
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.index = 1;
    self.URL = @"http://wap.ykmov.com/index.php?m=vod-list-id-13-pg-1-order--by--class-0-year-0-letter--area--lang-.html";
    
    self.titles = @[
                    @"  港剧=http://wap.ykmov.com/index.php?m=vod-list-id-13-pg-1-order--by--class-0-year-0-letter--area--lang-.html",
                    @"  韩剧=http://wap.ykmov.com/vod-list-id-14-pg-1-order--by--class-0-year-0-letter--area--lang-.html",
                    @"  美剧=http://wap.ykmov.com/vod-list-id-15-pg-1-order--by--class-0-year-0-letter--area--lang-.html",
                    @"  台剧=http://wap.ykmov.com/vod-list-id-27-pg-1-order--by--class-0-year-0-letter--area--lang-.html",
                    @"  泰剧=http://wap.ykmov.com/vod-list-id-28-pg-1-order--by--class-0-year-0-letter--area--lang-.html",
                    @"  日剧=http://wap.ykmov.com/vod-list-id-29-pg-1-order--by--class-0-year-0-letter--area--lang-.html",
                    @"  海外=http://wap.ykmov.com/vod-list-id-30-pg-1-order--by--class-0-year-0-letter--area--lang-.html",
                    @"  内地=hhttp://wap.ykmov.com/vod-list-id-12-pg-1-order--by--class-0-year-0-letter--area--lang-.html",
                    @"  电影=http://wap.ykmov.com/vod-type-id-1-pg-1.html",
                    @"  综艺=http://wap.ykmov.com/vod-type-id-3-pg-1.html",
                    @"  动漫=http://wap.ykmov.com/vod-type-id-4-pg-1.html",
                    @"  更多",

                    ];

    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"推荐";
    [self yycCollectionView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"🔳" style:UIBarButtonItemStylePlain target:self action:@selector(yycAction)];
   
    
    if (appManger) {
        UIButton *leftBut = [UIButton buttonWithType:UIButtonTypeCustom];
        leftBut.frame = CGRectMake(0, 0, 35, 35);
        [leftBut setTitle:@"粤" forState:UIControlStateNormal];
        [leftBut addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
        leftBut.layer.cornerRadius = 35/2;
        leftBut.layer.masksToBounds = YES;
        leftBut.backgroundColor = [UIColor orangeColor];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBut];
    }
}

-(void)leftAction {
    
    if (self.maskView != nil) {
        [self tap];
        
        return;
    }
    
    self.maskView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.maskView.backgroundColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1];
    self.maskView.alpha = 0;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.maskView addGestureRecognizer:tap];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.maskView.alpha = 0.5;
    }];
    [self.view addSubview:self.maskView];
    
    [self tableView];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)removeView {
    [self.yycBgView removeFromSuperview];
    self.yycBgView = nil;
    
    [self.bbk removeFromSuperview];
    self.bbk = nil;
}


-(void)yycAction {
    
    if (self.yycBgView != nil) {
        [self removeView];
        return;
    }
    
    if (!appManger) {
        YYCRadioPlayerController *RadioVC = [YYCRadioPlayerController new];
        RadioVC.dict = [Manager sharedInstance].currentRadioDict;
        
        [RadioVC setPlayerActionButBlock:^(BOOL isPlaying) {
            if (isPlaying) {
                [[Manager sharedInstance] play];
            }else {
                [[Manager sharedInstance] pause];
            }
        }];
        [self.navigationController pushViewController:RadioVC animated:YES];
        
        return;
    }
    
    UIView *yycBgView = [[UIView alloc] initWithFrame:self.view.bounds];
    yycBgView.backgroundColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:0.6];
    [self.view addSubview:yycBgView];
    self.yycBgView = yycBgView;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeView)];
    [yycBgView addGestureRecognizer:tap];
    
    YYCView *bbk = [YYCView ViewFormXib];
    self.bbk = bbk;
    bbk.frame = CGRectMake(0, 0, 300, 220);
    bbk.center = CGPointMake(KScreenWith/2, KScreenHeight/2);
    [self.view addSubview:bbk];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.yycDicts.count;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (appManger) {
        YYC_SS_DetailsController *detailsVC = [YYC_SS_DetailsController new];
        detailsVC.dict = self.yycDicts[indexPath.row];
        [self.navigationController pushViewController:detailsVC animated:YES];
        
        return;
    }
    
    [[Manager sharedInstance] playRadioWithUrl:self.yycDicts[indexPath.row][@"url"]];
    YYCRadioPlayerController *RadioVC = [YYCRadioPlayerController new];
    RadioVC.dict = self.yycDicts[indexPath.row];
    [Manager sharedInstance].currentRadioDict = self.yycDicts[indexPath.row];
    
    [RadioVC setPlayerActionButBlock:^(BOOL isPlaying) {
        if (isPlaying) {
            [[Manager sharedInstance] play];
        }else {
            [[Manager sharedInstance] pause];
        }
    }];
    
    [self.navigationController pushViewController:RadioVC animated:YES];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
   
    YYCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.titleLabel.text = self.yycDicts[indexPath.row][@"title"];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:self.yycDicts[indexPath.row][@"img"]] placeholderImage:[UIImage imageNamed:@"bbb"]];
    
    if (!appManger) {
        cell.imgView.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    return cell;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"lcell"];
    cell.textLabel.text = [self.titles[indexPath.row] componentsSeparatedByString:@"="].firstObject;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self tap];

    if([self.titles[indexPath.row] isEqualToString:@"  更多"]){
        [self.navigationController pushViewController:[YYCSSController new] animated:YES];
        return;
    }
    
    [self.yycDicts removeAllObjects];
    self.index = 1;
    self.URL = [self.titles[indexPath.row] componentsSeparatedByString:@"="].lastObject;
    self.navigationItem.title = [self.titles[indexPath.row] componentsSeparatedByString:@"="].firstObject;
    [self loadData];
}
@end

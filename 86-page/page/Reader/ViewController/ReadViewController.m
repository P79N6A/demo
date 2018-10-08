//
//  ReadViewController.m
//  page
//
//  Created by Jay on 7/8/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "ReadViewController.h"

#import "SPReaderView.h"

#import "SPChapterModel.h"
#import "SPReadConfig.h"
#include "const.h"

@interface ReadViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet SPReaderView *readView;

@end

@implementation ReadViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.readView.progressTitle = [NSString stringWithFormat:@"%ld-%ld-%ld",self.chapter+1,self.page+1,(long)self.model.pageCount];
    self.readView.isShow = self.isShow;
    self.readView.content = [self.model stringOfPage:self.page];
    self.view.backgroundColor = [SPReadConfig defaultConfig].themeColor;;
    __weak typeof(self) weakSelf = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:DZMNotificationNameThemeColorChange object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        weakSelf.view.backgroundColor = [SPReadConfig defaultConfig].themeColor;;
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:DZMNotificationNameFontChange object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        [weakSelf.readView setNeedsDisplay];
    }];
    
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

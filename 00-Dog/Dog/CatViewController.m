//
//  CatViewController.m
//  Dog
//
//  Created by czljcb on 2018/4/6.
//  Copyright © 2018年 czljcb. All rights reserved.
//

#import "CatViewController.h"
#import "AnimalModel.h"
#import "AnimalCell.h"
#import "common.h"

#import <AVFoundation/AVFoundation.h>

@interface CatViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray *models;
@property (weak, nonatomic) IBOutlet UIImageView *bgView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;

@property (nonatomic, strong) AVPlayer *player;

@end

@implementation CatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIToolbar *bar = [[UIToolbar alloc] initWithFrame:[UIScreen mainScreen].bounds];
    bar.barStyle = UIBarStyleBlack;
    [self.bgView addSubview:bar];
    
    CGFloat width = (kScreenW)/3.0;
    self.layout.itemSize = CGSizeMake(width, width);
    
    
    NSInteger tag = self.view.tag;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSString *file = [[NSBundle mainBundle] pathForResource:@"cat.plist" ofType:nil];
        if (tag == 2) {
            file = [[NSBundle mainBundle] pathForResource:@"dog.plist" ofType:nil];
        }
        NSArray *cats = [[NSArray alloc] initWithContentsOfFile:file];
        self.models = [AnimalModel modelFormArray:cats];
        
        if (tag == 3){
            
            NSMutableArray *models = [NSMutableArray arrayWithCapacity:199];
            for (NSInteger i = 0 ; i < 199; i ++) {
                
                NSString *image = [NSString stringWithFormat:@"Animal%ld",(long)i];
                NSString *voice = [NSString stringWithFormat:@"Animal%ld.mp3",(long)i];
                
                if (![UIImage imageNamed:image] || ![[NSBundle mainBundle] pathForResource:voice ofType:nil]) {
                    continue;
                }
                AnimalModel *m = [AnimalModel new];
                m.image = image;
                m.voice = voice;
                [models addObject:m];
            }
            self.models = models;
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    });
    
}


- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    AnimalCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.model = self.models[indexPath.item];
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.models.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    AnimalModel *model = self.models[indexPath.item];
    NSString *str = [[NSBundle mainBundle] pathForResource:model.voice ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:str];
    [self stop];
    [self play:url];

}

///
- (void)play:(NSURL *)url{
    [self.player replaceCurrentItemWithPlayerItem:[AVPlayerItem playerItemWithURL:url]];
    [self.player play];
}
- (void)stop {
    [self.player pause];
}

- (AVPlayer *)player{
    if (!_player) {
        _player = [AVPlayer playerWithURL:[NSURL URLWithString:@""]];
    }
    return _player;
}

@end

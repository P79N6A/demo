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

#import <AudioToolbox/AudioToolbox.h>

@interface CatViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray *models;
@property (weak, nonatomic) IBOutlet UIImageView *bgView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;

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
    
    NSString *file = [[NSBundle mainBundle] pathForResource:@"cat.plist" ofType:nil];

    if (self.view.tag == 2) {
        file = [[NSBundle mainBundle] pathForResource:@"dog.plist" ofType:nil];
    }
    NSArray *cats = [[NSArray alloc] initWithContentsOfFile:file];
    self.models = [AnimalModel modelFormArray:cats];
    
    if (self.view.tag == 3){
        
        NSMutableArray *models = [NSMutableArray arrayWithCapacity:199];
        for (NSInteger i = 0 ; i < 199; i ++) {
            
            NSString *image = [NSString stringWithFormat:@"Animal%ld",(long)i];
            NSString *voice = [NSString stringWithFormat:@"Animal%ld.mp3",(long)i];

            if (![UIImage imageNamed:image]) {
                continue;
            }
            AnimalModel *m = [AnimalModel new];
            m.image = image;
            m.voice = voice;
            [models addObject:m];
        }
        self.models = models;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
static SystemSoundID soundID = 0;
- (void)play:(NSURL *)url{
    
    
    
    AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(url), &soundID);
    AudioServicesPlayAlertSoundWithCompletion(soundID, ^{
        NSLog(@"播放完成");
    });
    
}

void soundCompleteCallBack(SystemSoundID soundID, void * clientDate) {
    NSLog(@"播放完成");
    AudioServicesDisposeSystemSoundID(soundID);
}

- (void)stop {
    AudioServicesDisposeSystemSoundID(soundID);
}


@end

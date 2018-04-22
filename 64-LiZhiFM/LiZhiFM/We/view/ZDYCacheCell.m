//
//  ZDYCacheCell.m
//  BuDeJie
//
//  Created by czljcb on 16/9/13.
//  Copyright © 2016年 czljcb. All rights reserved.
//

#import "ZDYCacheCell.h"

#import "Tool.h"
#import "UIView+Extension.h"
#import "LZCommon.h"


@interface ZDYCacheCell ()

@end

@implementation ZDYCacheCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [activityView startAnimating];
        self.accessoryView =activityView;
//        self.textLabel.text = [self SizeStr: 0];
        
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 8, 31, 31)];
        [self addSubview:self.iconImageView];
//        self.iconImageView.backgroundColor = [UIColor redColor];
        
        self.cacheLabel = [[UILabel alloc] init];
        self.cacheLabel.text = [self SizeStr: 0];
        self.cacheLabel.x = self.iconImageView.maxX + 10;
        self.cacheLabel.height = 50;
        self.cacheLabel.width = 300;
        self.cacheLabel.textAlignment = NSTextAlignmentLeft;
        self.cacheLabel.font = [UIFont systemFontOfSize:13];
        
        [self addSubview:self.cacheLabel];
        
        self.userInteractionEnabled = NO;
        
        [Tool calculateCache:cachesPath completion:^(NSInteger fillSize) {
            self.userInteractionEnabled = YES;

            self.accessoryView = nil;
            
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            self.cacheLabel.text = [self SizeStr: fillSize];
            
        }];

           }
    
    return self;
}

-(void)setUpdate:(BOOL)update {
    [Tool calculateCache:cachesPath completion:^(NSInteger fillSize) {
        self.userInteractionEnabled = YES;
        
        self.accessoryView = nil;
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.cacheLabel.text = [self SizeStr: fillSize];
    }];
}


static UILabel * _Nullable extracted(ZDYCacheCell *object) {
    return object.textLabel;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activityView startAnimating];
    self.accessoryView =activityView;
    self.cacheLabel.text = [self SizeStr: 0];
    
    self.userInteractionEnabled = NO;
    
    [Tool calculateCache:cachesPath completion:^(NSInteger fillSize) {
        self.userInteractionEnabled = YES;
        
        self.accessoryView = nil;
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        extracted(self).text = [self SizeStr: fillSize];
        self.cacheLabel.text = [self SizeStr: fillSize];

    }];

}

- (void)dealloc
{
//   NSLog(@"%s", __func__);
}

-(void)startAnimation
{
    
    
    UIActivityIndicatorView *activityView = (UIActivityIndicatorView *)self.accessoryView;
    [activityView startAnimating];
}


- (void)layoutSubviews{
    [super layoutSubviews];
    if (self.accessoryView) {
        [self startAnimation];
    }
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated
//
//{
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}


- (NSString *)SizeStr:(NSInteger)size
{
    
    NSString *sizeStr = @"清除缓存";
    
//    NSInteger size = self.fillSize;
    
    if (size / 1000.0 / 1000.0 / 1000.0 > 1) {
        CGFloat sizeGb = size / 1000.0 / 1000.0 / 1000.0;
        sizeStr = [NSString stringWithFormat:@"清除缓存（%.1fGB）",sizeGb];
        
    }else if (size / 1000.0 / 1000.0 > 1)
    {
        CGFloat sizeMb = size / 1000.0 / 1000.0 ;
        sizeStr = [NSString stringWithFormat:@"清除缓存（%.1fMB）",sizeMb];
        
    }else if (size / 1000.0 > 1)
    {
        CGFloat sizeKb = size / 1000.0 / 1000.0 ;
        sizeStr = [NSString stringWithFormat:@"清除缓存（%.1fKB）",sizeKb];
    }else if(size > 0)
    {
        sizeStr = [NSString stringWithFormat:@"清除缓存（%zdB）",size];
        
    }
    
    
    return sizeStr;
}

- (void)removeCache
{
    [Tool removeDirectoryPath:cachesPath];
    self.cacheLabel.text = [self SizeStr:0];
//
}

@end

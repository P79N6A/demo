
#import "XYYCacheCell.h"

#import "XYYF.h"

#import "Common.h"

@interface XYYCacheCell ()

@end

@implementation XYYCacheCell


- (NSString *)SizeStr:(NSInteger)size{
    
    NSString *sizeStr = @"清除缓存";
    
    if (size / 1000.0 / 1000.0 / 1000.0 > 1) {
        
        CGFloat sizeGb = size / 1000.0 / 1000.0 / 1000.0;
        
        sizeStr = [NSString stringWithFormat:@"清除缓存（%.1fGB）",sizeGb];
        
    }else if (size / 1000.0 / 1000.0 > 1){
        
        CGFloat sizeMb = size / 1000.0 / 1000.0 ;
        
        sizeStr = [NSString stringWithFormat:@"清除缓存（%.1fMB）",sizeMb];
        
    }else if (size / 1000.0 > 1){
        
        CGFloat sizeKb = size / 1000.0 / 1000.0 ;
        
        sizeStr = [NSString stringWithFormat:@"清除缓存（%.1fKB）",sizeKb];
        
    }else if(size > 0){
        
        sizeStr = [NSString stringWithFormat:@"清除缓存（%zdB）",size];
    }
    
    return sizeStr;
}


- (void)awakeFromNib{

    [super awakeFromNib];
    
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    [activityView startAnimating];
    
    self.accessoryView =activityView;
    
    self.cacheLabel.text = [self SizeStr: 0];
    
    self.userInteractionEnabled = NO;
    
    [XYYF calculateCache:cachesPath completion:^(NSInteger fillSize) {
    
        self.userInteractionEnabled = YES;
        
        self.accessoryView = nil;
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        self.cacheLabel.text = [self SizeStr: fillSize];
    }];
}


-(void)startAnimation{
    UIActivityIndicatorView *activityView = (UIActivityIndicatorView *)self.accessoryView;
    [activityView startAnimating];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (self.accessoryView) {
        [self startAnimation];
    }
}

- (void)removeCache{
    [XYYF removeDirectoryPath:cachesPath];
    self.cacheLabel.text = [self SizeStr:0];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        [activityView startAnimating];
        
        self.accessoryView =activityView;
        
        self.cacheLabel = [[UILabel alloc] init];
        
        self.cacheLabel.text = [self SizeStr: 0];
        
        
        CGFloat x = 12;
        CGFloat y = self.cacheLabel.frame.origin.y;
        CGFloat w = 300;
        CGFloat h = IS_PAD?80:55;
        //self.cacheLabel.x = 12;
        
        //self.cacheLabel.height = IS_PAD?80:55;
        
        //self.cacheLabel.width = 300;
        self.cacheLabel.frame = CGRectMake(x, y,w, h);
        
        self.cacheLabel.textAlignment = NSTextAlignmentLeft;
        
        self.cacheLabel.font = [UIFont systemFontOfSize:17];
        
        [self addSubview:self.cacheLabel];
        
        self.userInteractionEnabled = NO;
        
        [XYYF calculateCache:cachesPath completion:^(NSInteger fillSize) {
            
            self.userInteractionEnabled = YES;
            
            self.accessoryView = nil;
            
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            self.cacheLabel.text = [self SizeStr: fillSize];
        }];
    }
    
    return self;
}

-(void)setUpdate:(BOOL)update {
    
    [XYYF calculateCache:cachesPath completion:^(NSInteger fillSize) {
        
        self.userInteractionEnabled = YES;
        
        self.accessoryView = nil;
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        self.cacheLabel.text = [self SizeStr: fillSize];
    }];
}




@end


#import "XYYWEController.h"

#import "XYYCacheCell.h"

#import "ABController.h"
#import "Common.h"

@interface XYYWEController ()

@property (nonatomic, strong) NSArray *xyy_titleData;

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UIImageView *backgroundImageView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, assign) int HeaderViewH;

@end

@implementation XYYWEController

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
   
        XYYCacheCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CacheCellID" forIndexPath:indexPath];
        
        cell.update = YES;
        
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PorfileCellID" forIndexPath:indexPath];

    cell.textLabel.text = indexPath.section==1?self.xyy_titleData.lastObject:self.xyy_titleData[indexPath.row];
    
    cell.accessoryType =indexPath.row==0?UITableViewCellAccessoryNone: UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.row == 0) {
    
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        [cell.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
            if (obj.tag==100) {
            
                [obj removeFromSuperview];
                
                obj = nil;
            }
        }];
        
        UISwitch *s = [[UISwitch alloc] init];
        
        [s setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"YD"]];
        
        s.tag = 100;
        
        s.center = CGPointMake(ScreenWith -(IS_PAD?90:40), IS_PAD?80/2:55/2);
        
        [cell.contentView addSubview:s];
        
        [s addTarget:self action:@selector(ss:) forControlEvents:UIControlEventTouchUpInside];
    }

    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return self.xyy_titleData.count-1;
    }
    
    return 1;
}


-(void)ss:(UISwitch *)s {
    
    [[NSUserDefaults standardUserDefaults] setBool:s.on forKey:@"YD"];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
        if (indexPath.section == 0) {
    
            switch (indexPath.row) {
                case 0: {
    
                }
                    break;
                case 1: {//1369718515
                    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id1369718515?action=write-review"]];
                }
                    break;
                case 2: {
                    ABController *ab = [[ABController alloc] init];
                    [self.navigationController pushViewController:ab animated:YES];
                }
                    break;
                case 3: {
                   
                }
                    break;
                default: {
    
                }
                    break;
            }
        }else {
            
            UIAlertController *alerVC = [UIAlertController alertControllerWithTitle:@"是否清除缓存?" message:nil preferredStyle:UIAlertControllerStyleAlert];
          
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
            
            UIAlertAction *alert = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
               
                XYYCacheCell *cell = [tableView cellForRowAtIndexPath:indexPath];
               
                [cell removeCache];
            }];
            
            [alerVC addAction:alertAction];
           
            [alerVC addAction:alert];
           
            [self presentViewController:alerVC animated:YES completion:nil];
        }
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat width = ScreenWith;
    
    CGFloat yOffset = scrollView.contentOffset.y;
    
    if (yOffset < 0) {
        
        CGFloat totalOffset = self.HeaderViewH + ABS(yOffset);
        
        CGFloat f = totalOffset / self.HeaderViewH;
        
        self.backgroundImageView.frame =  CGRectMake(- (width * f - width) / 2, yOffset, width * f, totalOffset);
    }
}

-(void)setUI {
    
    self.tableView.rowHeight =IS_PAD?80: 55;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"PorfileCellID"];
    
    [self.tableView registerClass:[XYYCacheCell class] forCellReuseIdentifier:@"CacheCellID"];
    
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.tableView.tableFooterView = [UIView new];
    
    UIView * tableViewHeaderView = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, ScreenWith, self.HeaderViewH))];
    
    self.backgroundImageView = [[UIImageView alloc]initWithFrame:tableViewHeaderView.bounds];
    
    self.backgroundImageView.image = [UIImage imageNamed:@"bg"];
    
    self.backgroundImageView.backgroundColor = [UIColor orangeColor];
    
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.backgroundImageView.clipsToBounds = YES;
    
    [tableViewHeaderView addSubview:self.backgroundImageView];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake((ScreenWith - 80)/2, (self.HeaderViewH - 80)/2, 90, 90)];
    
    bgView.backgroundColor = [UIColor whiteColor];
    
    [tableViewHeaderView addSubview:bgView];
    
    bgView.layer.cornerRadius = 45;
    
    bgView.layer.masksToBounds = YES;
    
    [tableViewHeaderView addSubview:bgView];
    
    self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 80, 80)];
    
    self.iconImageView.backgroundColor = [UIColor whiteColor];
    
    self.iconImageView.layer.cornerRadius = 40;
    
    self.iconImageView.layer.masksToBounds = YES;
    
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [bgView addSubview:self.iconImageView];
    
    self.iconImageView.image = [UIImage imageNamed:@"Icon"];
    
    self.nameLabel = [[UILabel alloc] init];
    
    self.nameLabel.text = @"  轻松学英语";
    
    self.nameLabel.font = [UIFont systemFontOfSize:21];
    
    self.nameLabel.textColor = [UIColor whiteColor];
    
    [self.nameLabel sizeToFit];
    
    [tableViewHeaderView addSubview:self.nameLabel];
    
    self.nameLabel.center = CGPointMake(ScreenWith/2, CGRectGetMaxY(bgView.frame) + 20);
    
    self.tableView.tableHeaderView = tableViewHeaderView;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.xyy_titleData = @[@"移动数据播放",@"去评分",@"关于",@"清除缓存"];
    self.HeaderViewH = IS_PAD?400:200;
    [self setUI];
}

//FIXME:  -  旋转 状态栏
- (BOOL)shouldAutorotate{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)prefersStatusBarHidden{
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation{
    return UIStatusBarAnimationFade;
}

- (BOOL)prefersHomeIndicatorAutoHidden {
    return NO;
}


@end


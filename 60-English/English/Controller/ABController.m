
#import "ABController.h"

@interface ABController ()

@end

@implementation ABController

- (void)viewDidLoad {

    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"关于";
}


-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.icon.layer.cornerRadius = self.icon.frame.size.width/2;
    self.icon.layer.masksToBounds = YES;
}

@end

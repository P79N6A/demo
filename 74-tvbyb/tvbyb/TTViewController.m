//
//  TTViewController.m
//  tvbyb
//
//  Created by Jay on 13/6/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "TTViewController.h"

@interface TTViewController ()

@end

@implementation TTViewController

- (id)init{
    if (self == [super init]) {
        self.view.backgroundColor = [UIColor clearColor];
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        bgView.backgroundColor = [UIColor blackColor];
        bgView.alpha = 0.6;
        [self.view addSubview:bgView];
        
        UIImageView *alertView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 300)/ 2.0, (self.view.frame.size.height - 500)/ 2.0, 300, 500)];
        alertView.alpha = 1;
        alertView.image = [UIImage imageNamed:@"11"];
        alertView.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:alertView];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

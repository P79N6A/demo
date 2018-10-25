//
//  ViewController.m
//  web
//
//  Created by Jay on 19/10/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "ViewController.h"

#import "SPSafariController.h"


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (nonatomic, assign) BOOL A;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://127.0.0.1/test/JSPlayer.html"]]];
    
}
- (IBAction)on:(id)sender {

    

    SPSafariController *webVC = [[SPSafariController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:webVC];
    //nav.navigationBar.tintColor = [UIColor colorWithRed:0.322 green:0.322 blue:0.322 alpha:1.00];
    [self presentViewController:nav animated:YES completion:NULL];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (!self.A) {
        self.A = YES;
        self.webView.transform  = CGAffineTransformMakeRotation(M_PI_2);
        self.webView.frame = CGRectMake(0, 0, self.view.bounds.size.width,667 );
    }else{
        self.A = NO;
        self.webView.transform  = CGAffineTransformIdentity;
        self.webView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 200);
    }
    

}



@end

//
//  ViewController.m
//  HotFox
//
//  Created by Jay on 21/6/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "ViewController.h"
#import "UIView+Extension.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self join:@"Steve" b:nil];
//    NSLog(@"%s---%@", __func__,self);
    [self test:@"我是原生" m:@"message"];
//    self.view.backgroundColor = [UIColor redColor];
   
}
- (void)join:(NSString *)a b:(NSString *)b {
    NSArray *tmp = @[a,b,@"Good Job!"];
    NSString *c = [tmp componentsJoinedByString:@" "];
    printf("%s\n",[c UTF8String]);
    
//    [UISwitch new]
//    [self.view addSubview:<#(nonnull UIView *)#>]
//    [self.view setX:100];
//    [self.view setY:100];
    
//    UISwitch *sw ;
//    [UIColor redColor];
//    [sw setTintColor:<#(UIColor * _Nullable)#>]
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
     [self performSelector:@selector(test:m:) withObject:@(234) withObject:@"344ddd"];
}



- (void)test:(NSString *)txt m:message{
    [[[UIAlertView alloc] initWithTitle:txt message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil] show];
}


+ (void)test:(NSNumber * )txt m:message{
    [[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@",txt] message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil] show];
//    self.view.width = txt.integerValue;
}


@end

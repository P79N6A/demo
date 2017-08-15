//
//  ViewController.m
//  RAC
//
//  Created by pkss on 2017/5/23.
//  Copyright © 2017年 J. All rights reserved.
//

#import "ViewController.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;
@property (weak, nonatomic) IBOutlet UIButton *login;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    [self statusSignal];
    
    [[self.nameTF rac_signalForControlEvents:UIControlEventAllEditingEvents] subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    

    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(id x) {
        NSLog(@"---keborad");
    }];
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    [self sequence];
}

- (void)signal{
    
    // 1.创建信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    // 2.发送信号
    [subscriber sendNext:@"发出信号signal"];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"取消订阅");
            // 取消信号，如果信号想要被取消，就必须返回一个RACDisposable
            // 信号什么时候被取消：1.自动取消，当一个信号的订阅者被销毁的时候机会自动取消订阅，2.手动取消，
            //block什么时候调用：一旦一个信号被取消订阅就会调用
            //block作用：当信号被取消时用于清空一些资源

        }];
    }];
    
    // 3.订阅信号
    //subscribeNext
    // 把nextBlock保存到订阅者里面
    // 只要订阅信号就会返回一个取消订阅信号的类
    RACDisposable *disposable = [signal subscribeNext:^(id x) {
        NSLog(@"收到信号---%@",x);
    } error:^(NSError *error) {
        NSLog(@"%s---%@", __func__,error);
    }];
    //  4.取消订阅
    [disposable dispose];
}


- (void)subject{
    RACSubject *subject = [RACSubject subject];
    
    [subject subscribeNext:^(id x) {
        NSLog(@"收到信号---%@",x);
 
    } error:^(NSError *error) {
        NSLog(@"%s---%@", __func__,error);

    }];
    
    
    
    [subject sendNext:@"发出信号subject"];
}



# pragma mark - 状态推导

- (void)statusSignal{
    
    
     RACSignal *stream = [self.nameTF.rac_textSignal map:^id(NSString *value) {
        return @([value rangeOfString:@"@"].location != NSNotFound);
    }];
    RAC(self.login,enabled) = stream;
    
    RAC(self.nameTF,backgroundColor) = [stream map:^id(id value) {
        
        UIColor *color = [value boolValue]? [UIColor orangeColor] : [UIColor lightGrayColor];
        
        return color;
    }];
}

# pragma mark - 订阅
- (void)subscribe{
    [self.nameTF.rac_textSignal subscribeNext:^(id x) {
        NSLog(@"收到信号---%@",x);
 
    } error:^(NSError *error) {
        NSLog(@"收到信号error");

    } completed:^{
        NSLog(@"收到信号completed");

    }];
}

#pragma mark - 流和序列
- (void)sequence{
    NSArray *array = @[@1,@2,@3,@4];
    
    NSLog(@"%@",[[[array rac_sequence] map:^id (id value){
        return @(pow([value integerValue], 2));
    }] array]);
    
    NSLog(@"----------------------");
    
    NSLog(@"%@", [[[array rac_sequence] filter:^BOOL (id value){
        return [value integerValue] % 2 == 0;
    }] array]);
    
    NSLog(@"----------------------");
    NSLog(@"%@",[[[array rac_sequence] map:^id (id value){
        return [value stringValue];
    }] foldLeftWithStart:@"|" reduce:^id (id accumulator, id value){
        return [accumulator stringByAppendingString:value];
    }]);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

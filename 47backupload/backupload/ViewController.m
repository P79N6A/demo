//
//  ViewController.m
//  backupload
//
//  Created by Jay on 2018/3/16.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "ViewController.h"

#import "YHBackgroundService.h"

@interface ViewController ()
/** <##> */
@property (nonatomic, assign) NSInteger num;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)testdata:(NSData *)data{
    
    
    NSString *fileName = [NSString stringWithFormat:@"%li.png",(long)self.num];
    [[YHBackgroundService new] uploadFormData:data url:@"http://192.168.1.59/upload_file1.php" parameters:@{@"name":@"Jay"} name:@"file" fileName:fileName currentProgress:^(CGFloat progress) {
        
    } didComplete:^(id obj, NSError *error) {
        NSLog(@"%s---ok - %@", __func__,obj);
        self.num ++;
        if(self.num < 500) [self testdata:data];
        
    }];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    NSData *data = UIImagePNGRepresentation([UIImage imageNamed:@"Snip20180319_17"]);//[[NSData alloc] initWithContentsOfFile:@"/Users/jay/Desktop/曹志.pdf"];

//        [self testdata:data];
//    return;
    for (NSInteger i = 0; i < 200; i++) {
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSString *fileName = [NSString stringWithFormat:@"%li.png",(long)i];
            [[YHBackgroundService new] uploadFormData:data url:@"http://192.168.1.59/upload_file1.php" parameters:@{@"name":@"Jay"} name:@"file" fileName:fileName currentProgress:^(CGFloat pro) {
                
            } didComplete:^(id obj, NSError *error) {
                NSLog(@"%s---ok - %@---", __func__,obj);
            }];
        });
        

    }
    
    
}


@end

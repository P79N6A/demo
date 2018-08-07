//
//  ViewController.m
//  page
//
//  Created by Jay on 7/8/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "ViewController.h"
#import "ReadViewController.h"
#import "BackViewController.h"


@interface ViewController ()<UIPageViewControllerDataSource>
@property (nonatomic, strong) UIPageViewController *pageVC;
@property (nonatomic, strong) NSArray *pages;
@property (nonatomic, strong) UIViewController *currentViewController;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.pages = @[@"0",@"1",@"2",@"3"];
    [self addChildViewController:self.pageVC];
    [self.pageVC didMoveToParentViewController:self];
    [self.view addSubview:self.pageVC.view];
}

- (UIPageViewController *)pageVC{
    if (!_pageVC) {
        _pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        
        ReadViewController *rvc = [[ReadViewController alloc] init];
        rvc.title = self.pages.firstObject;
        [_pageVC setViewControllers:@[rvc] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        _pageVC.doubleSided = YES;
        
        _pageVC.dataSource = self;
    }
    return _pageVC;
}




//FIXME:  -  UIPageViewControllerDataSource
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    
//    if([viewController isKindOfClass:[ReadViewController class]]) {
        self.currentViewController = viewController;
        
//        BackViewController *backViewController = [BackViewController new];
//        [backViewController updateWithViewController:viewController];
//        return backViewController;
//    }
    
    
    NSUInteger index = [self.pages indexOfObject:self.currentViewController.title];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    ReadViewController *vc = [[ReadViewController alloc] init];
    vc.title = self.pages[index];
    return vc;
}
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
   
//    if([viewController isKindOfClass:[ReadViewController class]]) {
        self.currentViewController = viewController;
        
//        BackViewController *backViewController = [BackViewController new];
//        [backViewController updateWithViewController:viewController];
//        return backViewController;
//    }
    NSUInteger index = [self.pages indexOfObject:self.currentViewController.title];
    if (index == NSNotFound || index >= (self.pages.count - 1)) {
        return nil;
    }
    
    index++;
    ReadViewController *vc = [[ReadViewController alloc] init];
    vc.title = self.pages[index];
    return vc;

}


@end

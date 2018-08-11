//
//  ViewController.m
//  page
//
//  Created by Jay on 7/8/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "SPPageViewController.h"
#import "ReadViewController.h"
#import "BackViewController.h"

#import "SPChapterModel.h"


@interface SPPageViewController ()<UIPageViewControllerDataSource>
@property (nonatomic, strong) UIPageViewController *pageVC;
@property (nonatomic, strong) ReadViewController *currentViewController;
@property (nonatomic, strong) NSArray <SPChapterModel *> *models;
@property (nonatomic, assign) NSInteger chapter;
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, assign) NSInteger startIndex;
@property (nonatomic, assign) NSInteger endIndex;

@end

@implementation SPPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
        SPChapterModel *model = [SPChapterModel new];
        model.title = @"第一章 白发";
        model.content = @"\r\n\r\n一天之后，吉林开往北京的特快列车上。在最后一节车厢里，围坐着五位解放军战士。其中两名正是刚经历了“怪尸事件”的班长沈援朝和战士张柱。\r\n\r\n那件事已经被下了封口令，怪物的尸体被拍了照片，当天就送到北京的中科院生物研究所，几位研究生物进化学的院士看了之后如获至宝。这具怪尸可以说是对达尔文的生物进化论的挑战，就科学意义而言，可以说已经超过了那个失踪了半个世纪的北京人头盖骨化石。\r\n\r\n因为有那个头盖骨化石失踪的前车之鉴，为了消除运送途中的各种隐患，武警总队方面指示保密运送。为此还特批了一趟列车来单独护送。\r\n\r\n因为是特殊运送，这趟军列不设客车厢，只是在前面捎带着挂了几节货车厢。除了火车头里的两名火车司机之外，就只剩下最后一节车厢里的这五名战士了。\r\n\r\n沈援朝和张柱作为主要当事人，要到中科院去汇报事件的过程。他俩也是唯一知道运送“物品”真相的人，剩余的三名战士则是被通知因为在扑灭山火中表现突出英勇，要到首都去接受首长的嘉奖，顺便有一件大兴安岭的“特产”要同车抵达北京，希望几位战士能协助押送，保护安全。\r\n\r\n现在那具怪尸已经被几条麻袋层层包裹，安安静静地躺在车厢的角落里。沈援朝和张柱坐的角度正好能看见怪尸的位置。\r\n\r\n自打沈援朝上了火车，总是有一种心惊肉跳的感觉。一闭上眼就是战友活生生被怪尸咬死的景象，一睁眼就看见包裹怪尸的麻袋就躺在自己的眼前。闹得他坐也不是站也不是，睡也不是醒也不是。\r\n\r\n张柱倒是个粗人，上了车后除了晕车就没有别的不适感觉。坐了半天的火车，最后就连晕车都适应了，是睡也安然，吃也香甜。看得沈援朝心中直咬牙你倒是心宽，也不看看你眼前躺着的是什么东西？你的战友可是死在它手上的。那血淋淋的场面你这么快就忘了？沈援朝突然想起来，当时张柱去找连长了，那场面他还真没赶上。\r\n\r\n“援朝，你又在想啥子？一上车就跟失了魂似的。”说话的是几人中职位最高的，沈援朝隔壁连的排长姜子达。\r\n\r\n姜子达是四川人，和沈援朝是同年兵，自打新兵连俩人就在一起。虽不是无话不谈，也算是意气相投。\r\n\r\n“什么叫失了魂？老姜，别胡说八道。”沈援朝现在对这类词语有些敏感，“我在山上三天三夜都没合眼了，换你试试？早就累趴下了。”\r\n\r\n“谁不是几天几夜莫合眼。你以为就你能耐啊？再说，那还不趁现在睡一哈子。别到了北京，见了首长莫得精神，那就丢我们武警的人喽。”\r\n\r\n“谁不想睡啊？这不是……睡不着嘛。”沈援朝干巴巴地";
    SPChapterModel *model2 = [SPChapterModel new];
    model2.title = @"第二章 白发";
    model2.content = @"\r\n\r\n一天之后，吉林开往北京的特快列车上。在最后一节车厢里，围坐着五位解放军战士。其中两名正是刚经历了“怪尸事件”的班长沈援朝和战士张柱。\r\n\r\n那件事已经被下了封口令，怪物的尸体被拍了照片，当天就送到北京的中科院生物研究所，几位研究生物进化学的院士看了之后如获至宝。这具怪尸可以说是对达尔文的生物进化论的挑战，就科学意义而言，可以说已经超过了那个失踪了半个世纪的北京人头盖骨化石。\r\n\r\n因为有那个头盖骨化石失踪的前车之鉴，为了消除运送途中的各种隐患，武警总队方面指示保密运送。为此还特批了一趟列车来单独护送。\r\n\r\n因为是特殊运送，这趟军列不设客车厢，只是在前面捎带着挂了几节货车厢。除了火车头里的两名火车司机之外，就只剩下最后一节车厢里的这五名战士了。\r\n\r\n沈援朝和张柱作为主要当事人，要到中科院去汇报事件的过程。他俩也是唯一知道运送“物品”真相的人，剩余的三名战士则是被通知因为在扑灭山火中表现突出英勇，要到首都去接受首长的嘉奖，顺便有一件大兴安岭的“特产”要同车抵达北京，希望几位战士能协助押送，保护安全。\r\n\r\n现在那具怪尸已经被几条麻袋层层包裹，安安静静地躺在车厢的角落里。沈援朝和张柱坐的角度正好能看见怪尸的位置。\r\n\r\n自打沈援朝上了火车，总是有一种心惊肉跳的感觉。一闭上眼就是战友活生生被怪尸咬死的景象，一睁眼就看见包裹怪尸的麻袋就躺在自己的眼前。闹得他坐也不是站也不是，睡也不是醒也不是。\r\n\r\n张柱倒是个粗人，上了车后除了晕车就没有别的不适感觉。坐了半天的火车，最后就连晕车都适应了，是睡也安然，吃也香甜。看得沈援朝心中直咬牙你倒是心宽，也不看看你眼前躺着的是什么东西？你的战友可是死在它手上的。那血淋淋的场面你这么快就忘了？沈援朝突然想起来，当时张柱去找连长了，那场面他还真没赶上。\r\n\r\n“援朝，你又在想啥子？一上车就跟失了魂似的。”说话的是几人中职位最高的，沈援朝隔壁连的排长姜子达。\r\n\r\n姜子达是四川人，和沈援朝是同年兵，自打新兵连俩人就在一起。虽不是无话不谈，也算是意气相投。\r\n\r\n“什么叫失了魂？老姜，别胡说八道。”沈援朝现在对这类词语有些敏感，“我在山上三天三夜都没合眼了，换你试试？早就累趴下了。”\r\n\r\n“谁不是几天几夜莫合眼。你以为就你能耐啊？再说，那还不趁现在睡一哈子。别到了北京，见了首长莫得精神，那就丢我们武警的人喽。”\r\n\r\n“谁不想睡啊？这不是……睡不着嘛。”沈援朝干巴巴地";

    self.models = @[model,model2];
    self.chapter = 0;
    self.page = 0;
    
    [self addChildViewController:self.pageVC];
    [self.pageVC didMoveToParentViewController:self];
    [self.view addSubview:self.pageVC.view];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"KSPFontSizeChange" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        [self.models enumerateObjectsUsingBlock:^(SPChapterModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj updateFont];
        }];
        
        NSArray *indexs = self.models[self.chapter].pages;
        
        [indexs enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (obj.integerValue) {
                <#statements#>
            }
            
        }];
        
    }];
}

#pragma mark - Create Read View Controller

-(ReadViewController *)readViewWithChapter:(NSUInteger)chapter page:(NSUInteger)page{
    
    

    ReadViewController *readView = [[ReadViewController alloc] init];
    readView.model = self.models[chapter];
    readView.chapter = chapter;
    readView.page = page;
    self.chapter = chapter;
    self.page = page;
    
    self.startIndex = readView.model.pages[page].integerValue;
    self.endIndex = self.startIndex + [readView.model stringOfPage:page].length;
    
    return readView;
}


- (UIPageViewController *)pageVC{
    if (!_pageVC) {
        _pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        
        [_pageVC setViewControllers:@[[self readViewWithChapter:self.chapter page:self.page]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        _pageVC.doubleSided = YES;
        
        _pageVC.dataSource = self;
    }
    return _pageVC;
}





//FIXME:  -  UIPageViewControllerDataSource
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    
    if([viewController isKindOfClass:[ReadViewController class]]) {
        self.currentViewController = (ReadViewController *)viewController;
        
        BackViewController *backViewController = [BackViewController new];
        [backViewController updateWithViewController:viewController];
        return backViewController;
    }
    
    NSInteger  chapter = self.currentViewController.chapter;
    NSInteger  page = self.currentViewController.page;

    if (page == 0 || (page == NSNotFound)) {
        
        if (chapter == 0 || (chapter == NSNotFound)) {
            return nil;
        }
        chapter --;
        page = self.models[chapter].pageCount;
    }
    
    page --;
    
    ReadViewController *vc = [self readViewWithChapter:chapter page:page];

    
    return vc;
}
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
   
    if([viewController isKindOfClass:[ReadViewController class]]) {
        self.currentViewController = (ReadViewController *)viewController;
        
        BackViewController *backViewController = [BackViewController new];
        [backViewController updateWithViewController:viewController];
        return backViewController;
    }
    
    NSInteger  chapter = self.currentViewController.chapter;
    NSInteger  page = self.currentViewController.page;
    
    if ( page == NSNotFound || page >= (self.models[chapter].pageCount - 1) ) {
        
        if ( chapter == NSNotFound || chapter >= (self.models.count - 1) ) {
            return nil;
        }
        chapter ++;
        page = -1;
    }
    
    page ++;

    ReadViewController *vc = [self readViewWithChapter:chapter page:page];
    
    return vc;

}


@end

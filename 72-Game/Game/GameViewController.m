//
//  GameViewController.m
//  Game
//
//  Created by czljcb on 2018/5/14.
//  Copyright © 2018年 czljcb. All rights reserved.
//

#import "GameViewController.h"
#import "MyScene.h"

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Load the SKScene from 'GameScene.sks'
    //GameScene *scene = (GameScene *)[SKScene nodeWithFileNamed:@"GameScene"];
    MyScene *scene = [[MyScene alloc] initWithSize:[UIScreen mainScreen].bounds.size];
    //MyScene *scene = [MyScene nodeWithFileNamed:@"MyScene"];

    // Set the scale mode to scale to fit the window
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    SKView *skView = (SKView *)self.view;
    
    // Present the scene
    [skView presentScene:scene];
    
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end

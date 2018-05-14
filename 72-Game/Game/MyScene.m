//
//  MyScene.m
//  Game
//
//  Created by czljcb on 2018/5/14.
//  Copyright © 2018年 czljcb. All rights reserved.
//

#import "MyScene.h"

@interface MyScene()
@property (nonatomic, strong) SKSpriteNode *node;
@end

@implementation MyScene
- (instancetype)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self) {
        
        
        SKSpriteNode *node = [SKSpriteNode spriteNodeWithColor:[UIColor orangeColor] size: CGSizeMake(100, 100)];//[SKSpriteNode spriteNodeWithImageNamed:@"timg"];
        node.color = [UIColor redColor];
        node.name = @"node";
        [node setTexture:[SKTexture textureWithImage:[UIImage imageNamed:@"timg"]]];
        node.position =CGPointMake(node.size.width * 0.5 , node.size.height * 0.5);
        [self addChild:node];
        _node = node;
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //SKAction *move = [SKAction moveTo:CGPointMake(100, 100) duration:2.0];
    SKAction *move = [SKAction moveByX:100 y:100 duration:2.0];
    
    //2.0
    SKAction *actionMidMove = [SKAction moveByX:100 y:100 duration:2.0];
    SKAction *actionMove = [SKAction moveByX:-100 y:-100 duration:1.0];
    //SKAction *move = [SKAction sequence:@[actionMidMove,actionMove]];

    //3.0
    SKAction *delay = [SKAction waitForDuration:1.0];
//    SKAction *move = [SKAction sequence:@[actionMidMove,delay,actionMove]];
    
    // 4.0
//   SKAction *move = [SKAction runBlock:^{
//        NSLog(@"%s----runBlock", __func__);
//    }];
    

    //5.0
    //move = move.reversedAction;
//6.0
//    SKAction *halfSequence =  [SKAction sequence:@[move]];
//    move = [SKAction sequence:@[move,halfSequence.reversedAction]];
    //7.0
     move = [SKAction repeatActionForever:move];
        [self.node  runAction:move completion:^{
           NSLog(@"%s", __func__);
        }];
}

@end

//
//  GameScene.h
//  thisarrow
//

//  Copyright (c) 2016年 jamstudio. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

static const uint32_t arrowCategory  =  0x1 << 0;
static const uint32_t pickUpCategory =  0x1 << 1;
static const uint32_t dotCategory    =  0x1 << 2;
static const uint32_t weaponCategory =  0x1 << 3;

@interface GameScene : SKScene

@end

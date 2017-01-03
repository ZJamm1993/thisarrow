//
//  GameScene.h
//  thisarrow
//

//  Copyright (c) 2016年 jamstudio. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef NS_ENUM(NSInteger, SpriteZPosition)
{
    Background_Z_Position,
    Weapon_Z_Position,
    Shadow_Z_Position,
    Dot_Z_Position,
    Pick_Z_Position,
    Air_Z_Position,
    Arrow_Z_Position,
};

@interface GameScene : SKScene


@end

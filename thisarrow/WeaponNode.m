//
//  WeaponNode.m
//  thisarrow
//
//  Created by iMac206 on 16/12/21.
//  Copyright © 2016年 jamstudio. All rights reserved.
//

#import "WeaponNode.h"

@implementation WeaponNode

+(instancetype)defaultNode
{
    return [[WeaponNode alloc]initWithColor:[SKColor blueColor] size:CGSizeMake(10, 10)];
}

-(instancetype)initWithTexture:(SKTexture *)texture
{
    self=[super initWithTexture:texture];
    if (self) {
        self.zPosition=Weapon_Z_Position;
    }
    return self;
}

-(instancetype)initWithColor:(UIColor *)color size:(CGSize)size
{
    self=[super initWithColor:color size:size];
    if(self)
    {
        self.zPosition=Weapon_Z_Position;
    }
    return self;
}

-(void)actionWithTargets:(NSArray *)targets
{
    
}

-(void)disappear
{
    [self runAction:[SKAction group:[NSArray arrayWithObjects:[SKAction scaleTo:0.1 duration:0.25],[SKAction fadeAlphaTo:0 duration:0.25],nil]] completion:^{
        [self removeFromParent];
    }];
}

@end

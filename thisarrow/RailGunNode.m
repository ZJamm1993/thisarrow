//
//  RailGunNode.m
//  thisarrow
//
//  Created by iMac206 on 16/12/21.
//  Copyright © 2016年 jamstudio. All rights reserved.
//

#import "RailGunNode.h"

@implementation RailGunNode

+(instancetype)defaultNode
{
    RailGunNode* gun=[RailGunNode spriteNodeWithTexture:[MyTextureAtlas textureNamed:@"purpleLoad"]];
    return gun;
}

-(void)loadedToGun:(SKNode *)node
{
    if (node) {
        [node addChild:self];
        self.position=CGPointMake(0, node.frame.size.height/2);
        [self performSelector:@selector(prepareToShoot) withObject:nil afterDelay:2];
    }
}

-(void)prepareToShoot
{
    [self shootFromPoint:self.parent.position direction:self.parent.zRotation];
}

-(void)shootFromPoint:(CGPoint)poi direction:(CGFloat)radian
{
//    SKNode* parent=self.parent;
    [self removeFromParent];
//    [parent.parent addChild:self];
}

@end

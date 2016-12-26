//
//  DotNode.m
//  thisarrow
//
//  Created by jam on 16-12-24.
//  Copyright (c) 2016年 jamstudio. All rights reserved.
//

#import "DotNode.h"

const CGFloat defaultFollowSpeed=16/60.0;

@implementation DotNode

+(instancetype)defaultNode
{
    DotNode* dot=[DotNode spriteNodeWithColor:[SKColor redColor] size:CGSizeMake(10, 10)];
    dot.zPosition=Dot_Z_Position;
    return dot;
}

+(instancetype)groupingNode
{
    DotNode* dot=[DotNode defaultNode];
    dot.isGrouping=YES;
    return dot;
}

-(void)wakeUp
{
    self.yScale=0;
    SKAction* scales=[SKAction sequence:[NSArray arrayWithObjects:[SKAction scaleYTo:1 duration:0.2],[SKAction scaleYTo:0.5 duration:0.2],[SKAction scaleYTo:1 duration:0.2], nil]];
    [self runAction:scales completion:^{
        _isAwake=YES;
    }];
}

-(void)actionWithTarget:(SKNode *)node
{
    if (node.parent==nil) {
        [self removeFromParent];
        return;
    }
    if (_isDead||!_isAwake) {
        return;
    }
    if (!_isGrouping) {
        if ([node isKindOfClass:[ZZSpriteNode class]]) {
            ZZSpriteNode* z=(ZZSpriteNode*)node;
            CGFloat dx=z.position.x-self.position.x;
            CGFloat dy=z.position.y-self.position.y;
            CGFloat rad=atan2f(dx, dy);
            CGFloat newDx=defaultFollowSpeed*sin(rad);
            CGFloat newDy=defaultFollowSpeed*cos(rad);
            self.position=CGPointMake(self.position.x+newDx, self.position.y+newDy);
        }
    }
}

-(void)beKilledByWeapon:(WeaponNode *)weapon
{
    [self removeAllActions];
    _isDead=YES;
    if ([weapon isKindOfClass:[MegaBombNode class]])
    {
        ZZSpriteNode* burn=[ZZSpriteNode spriteNodeWithTexture:[MyTextureAtlas textureNamed:@"burnup1"]];
//        burn.alpha=0.8;
        burn.position=self.position;
        [self.parent addChild:burn];
        
        [burn runAction:[SKAction animateWithTextures:[MyTextureAtlas burnUpTextures] timePerFrame:0.02] completion:^{
            [burn removeFromParent];
        }];
    }
    else if([weapon isKindOfClass:[RailGunNode class]])
    {
        ZZSpriteNode* ball=[ZZSpriteNode spriteNodeWithTexture:[MyTextureAtlas textureNamed:@"purpleBall"]];
        ball.position=self.position;
        [self.parent addChild:ball];
        [ball runAction:[SKAction scaleTo:0 duration:0.15] completion:^{
            [ball removeFromParent];
        }];
    }
    
    [self removeFromParent];
}

-(BOOL)intersectsNode:(SKNode *)node
{
    if (_isDead||!_isAwake) {
        return NO;
    }
    return [super intersectsNode:node];
}

@end

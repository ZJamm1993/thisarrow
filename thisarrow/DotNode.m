//
//  DotNode.m
//  thisarrow
//
//  Created by jam on 16-12-24.
//  Copyright (c) 2016年 jamstudio. All rights reserved.
//

#import "DotNode.h"

const CGFloat defaultFollowSpeed=10/60.0;

@implementation DotNode

+(instancetype)defaultNode
{
    DotNode* dot=[DotNode spriteNodeWithColor:[SKColor redColor] size:CGSizeMake(10, 10)];
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

-(void)beKilled
{
    [self removeAllActions];
    _isDead=YES;
    self.color=[SKColor blackColor];
    [self runAction:[SKAction fadeAlphaTo:0 duration:0.15] completion:^{
        [self removeFromParent];
    }];
}

@end

//
//  MissileTrackNode.m
//  thisarrow
//
//  Created by iMac206 on 16/12/26.
//  Copyright © 2016年 jamstudio. All rights reserved.
//

#import "MissileTrackNode.h"

const CGFloat speed=100;
const CGFloat explosionDuration=5;

@implementation MissileTrackNode

+(instancetype)defaultNode
{
    MissileTrackNode* mi=[MissileTrackNode spriteNodeWithColor:[UIColor blueColor] size:CGSizeMake(10, 10)];
    
    [mi performSelector:@selector(selfExplosion) withObject:nil afterDelay:explosionDuration];
    return mi;
}

-(void)actionWithTargets:(NSArray *)targets
{
    if (_isHit) {
        return;
    }
    CGPoint targetPosition=self.position;
    CGFloat minDistance=MAXFLOAT;
    for (ZZSpriteNode* tar in targets) {
        CGFloat dx=tar.position.x-self.position.x;
        CGFloat dy=tar.position.y-self.position.y;
        CGFloat distance=dx*dx+dy*dy;
        if (distance<minDistance) {
            minDistance=distance;
            targetPosition=tar.position;
        }
    }
    
}

-(BOOL)intersectsNode:(SKNode *)node
{
    BOOL inter=[super intersectsNode:node];
    if (inter) {
        _isHit=YES;
    }
    return inter;
}

-(void)selfExplosion
{
    [self canPerformAction:@selector(selfExplosion) withSender:self];
    
    [self removeFromParent];
}

@end

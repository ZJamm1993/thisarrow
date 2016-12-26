//
//  MissileTrackNode.m
//  thisarrow
//
//  Created by iMac206 on 16/12/26.
//  Copyright © 2016年 jamstudio. All rights reserved.
//

#import "MissileTrackNode.h"

const CGFloat speed=100/60.0;
const CGFloat explosionDuration=10;
const CGFloat turnAngle=M_PI/60;

@implementation MissileTrackNode

+(instancetype)defaultNode
{
    MissileTrackNode* mi=[MissileTrackNode spriteNodeWithColor:[UIColor blueColor] size:CGSizeMake(6, 10)];
    ZZSpriteNode* nod=[ZZSpriteNode spriteNodeWithColor:[UIColor blueColor] size:CGSizeMake(4, 4)];
    nod.position=CGPointMake(0, 7);
    [mi addChild:nod];
    [mi performSelector:@selector(explosion) withObject:nil afterDelay:explosionDuration];
    return mi;
}

-(void)actionWithTargets:(NSArray *)targets
{
//    if (_isHit) {
//        return;
//    }
    CGPoint targetPosition=self.position;
    CGFloat minDistance=MAXFLOAT;
    for (ZZSpriteNode* tar in targets) {
        CGFloat dx=tar.position.x-self.position.x;
        CGFloat dy=tar.position.y-self.position.y;
        CGFloat distance=dx*dx+dy*dy;
        if (distance<minDistance) {
            minDistance=distance;
            targetPosition=CGPointMake(dx, dy);
        }
    }
    CGFloat tarRad=-atan2f(targetPosition.x, targetPosition.y);
    CGFloat selRad=self.zRotation;
    CGFloat deltaRad=tarRad-selRad;
    
    CGFloat sinDt=sinf(deltaRad);
    
//    NSLog(@"%f,",sinDt);
    
    self.zRotation=self.zRotation+(sinDt>0?turnAngle:-turnAngle);
    CGFloat sx=speed*(sin(-self.zRotation));
    CGFloat sy=speed*(cos(-self.zRotation));
    self.position=CGPointMake(self.position.x+sx, self.position.y+sy);
}

-(BOOL)intersectsNode:(SKNode *)node
{
    CGRect r1=self.frame;
    CGRect r2=node.frame;
    BOOL inter=CGRectIntersectsRect(r1, r2);
    if (inter) {
        [self explosion];
        _isHit=YES;
    }
    return inter;
}

-(void)explosion
{
    if (_isHit) {
        return;
    }
    [self canPerformAction:@selector(explosion) withSender:self];
    self.texture=nil;
    self.color=[UIColor clearColor];
    [self performSelector:@selector(removeFromParent) withObject:nil afterDelay:0.25];
}

@end

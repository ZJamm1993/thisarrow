//
//  MissileTrackNode.m
//  thisarrow
//
//  Created by iMac206 on 16/12/26.
//  Copyright © 2016年 jamstudio. All rights reserved.
//

#import "MissileTrackNode.h"

const CGFloat speed=100/60.0;
const CGFloat explosionDuration=4;
const CGFloat maxTurnAngle=speed/24;
const NSInteger tailNodesCount=24;

@implementation MissileTrackNode
{
    NSMutableArray* tailNodes;
}

+(instancetype)defaultNode
{
    MissileTrackNode* mi=[MissileTrackNode spriteNodeWithTexture:[MyTextureAtlas textureNamed:@"yellowDiamond"]];
    mi.xScale=0.7;
//    ZZSpriteNode* nod=[ZZSpriteNode spriteNodeWithColor:[UIColor blueColor] size:CGSizeMake(4, 4)];
//    nod.position=CGPointMake(0, 7);
//    [mi addChild:nod];
    [mi performSelector:@selector(explosion) withObject:nil afterDelay:explosionDuration];
    return mi;
}

-(void)actionWithTargets:(NSArray *)targets
{
//    if (_isHit) {
//        return;
//    }
    BOOL left=NO;
    CGFloat turnAngle=maxTurnAngle;
    
    if (targets.count>0) {
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
        left=sinDt>0;
        
        // this sinDt means turn left or right is larger than 0
        //    NSLog(@"%f,",sinDt);
        
        CGFloat countedAngle=acosf(cosf(deltaRad));
        // this countedAngle means real deltaAngle
        
        CGFloat insideAngle=M_PI_2-countedAngle;
        CGFloat radius=sqrtf(minDistance)/2/cos(insideAngle);
        turnAngle=speed/radius;
    }
    
    turnAngle=turnAngle>maxTurnAngle?maxTurnAngle:turnAngle;
    
    self.zRotation=self.zRotation+(left?turnAngle:-turnAngle);
    CGFloat sx=speed*(sin(-self.zRotation));
    CGFloat sy=speed*(cos(-self.zRotation));
    self.position=CGPointMake(self.position.x+sx, self.position.y+sy);
    [self showTail];
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
    for (SKNode* tn in tailNodes) {
        [tn removeFromParent];
    }
    ZZSpriteNode* ball=[ZZSpriteNode spriteNodeWithTexture:[MyTextureAtlas textureNamed:@"yellowBall"]];
    ball.position=self.position;
    [self.parent addChild:ball];
    [ball runAction:[SKAction scaleTo:0 duration:0.25] completion:^{
        [ball removeFromParent];
    }];
    [self performSelector:@selector(removeFromParent) withObject:nil afterDelay:0.25];
}

-(void)showTail
{
    if (tailNodes.count==0) {
        tailNodes=[NSMutableArray array];
        int count=tailNodesCount;
        CGFloat width=self.size.width*self.xScale;
        for (int i=0; i<count; i++) {
            CGFloat w=width*i/count;
            ZZSpriteNode* tn=[ZZSpriteNode spriteNodeWithColor:[SKColor colorWithRed:1 green:0.6+(0.4*i)/count blue:0 alpha:1  ] size:CGSizeMake(w, width)];
            tn.position=self.position;
            tn.zPosition=self.zPosition-1;
            [self.parent addChild:tn];
            [tailNodes addObject:tn];
        }
    }
    NSInteger cou=tailNodes.count;
    for (int i=0; i<cou-1; i++) {
        ZZSpriteNode* tn1=[tailNodes objectAtIndex:i];
        ZZSpriteNode* tn2=[tailNodes objectAtIndex:i+1];
        tn1.position=tn2.position;
        tn1.zRotation=tn2.zRotation;
    }
    ZZSpriteNode* tnLast=[tailNodes lastObject];
    tnLast.position=self.position;
    tnLast.zRotation=self.zRotation;
}

@end

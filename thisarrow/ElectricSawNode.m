//
//  ElectricSawNode.m
//  thisarrow
//
//  Created by iMac206 on 17/1/4.
//  Copyright © 2017年 jamstudio. All rights reserved.
//

#import "ElectricSawNode.h"

const CGFloat rotationRate=M_PI_4/10/60;

@implementation ElectricSawNode
{
    CGFloat deltaRotation;
    BOOL shouldSpeedUp;
}

+(instancetype)defaultNode
{
    ElectricSawNode* nod=[ElectricSawNode spriteNodeWithImageNamed:@"blueCover"];
    nod.xScale=0;
    nod.yScale=nod.xScale;
    [nod runAction:[SKAction sequence:[NSArray arrayWithObjects:[SKAction scaleTo:1 duration:0.25],nil]] completion:^{
        
        CFTimeInterval scaleTime=0.2;
        int count=8;
        for (int i=0; i<count;i++) {
            CGFloat rotation=M_PI*2/count*i;
            CFTimeInterval wait2=i*scaleTime;
            ZZSpriteNode* tooth=[ZZSpriteNode spriteNodeWithTexture:[MyTextureAtlas textureNamed:@"sawTooth"]];
            tooth.zPosition=-1;
            tooth.yScale=0;
            [nod addChild:tooth];
            tooth.zRotation=rotation;
            [tooth runAction:[SKAction sequence:[NSArray arrayWithObjects:[SKAction waitForDuration:wait2],[SKAction scaleYTo:0.9 duration:scaleTime],nil]]];
        }
        CFTimeInterval waitTime=count*scaleTime;
        [nod performSelector:@selector(speedUp) withObject:nil afterDelay:waitTime];
        [nod performSelector:@selector(slowDown) withObject:nil afterDelay:8];
    }];
    return nod;
}

-(void)speedUp
{
    shouldSpeedUp=YES;
}

-(void)slowDown
{
    shouldSpeedUp=NO;
}

-(void)actionWithHero:(SKNode *)hero
{
    self.position=hero.position;
    if (deltaRotation<0) {
        return;
    }
    if (shouldSpeedUp) {
        if (deltaRotation<M_PI_4/10) {
            deltaRotation+=rotationRate;
        }
    }
    else
    {
        if (deltaRotation>=0) {
            deltaRotation-=rotationRate;
        }
        if (deltaRotation<0) {
            [self disappear];
        }
    }
    self.zRotation+=deltaRotation;
}

-(BOOL)intersectsNode:(SKNode *)node
{
    CGPoint p0=self.position;
    CGPoint p1=node.position;
    CGFloat dx=p0.x-p1.x;
    CGFloat dy=p0.y-p1.y;
    CGFloat distance=sqrtf(dx*dx+dy*dy);
    BOOL inter=distance<self.frame.size.width/2+node.frame.size.width/2;
    return inter;
}

@end

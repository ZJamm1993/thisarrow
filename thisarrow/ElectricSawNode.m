//
//  ElectricSawNode.m
//  thisarrow
//
//  Created by iMac206 on 17/1/4.
//  Copyright © 2017年 jamstudio. All rights reserved.
//

#import "ElectricSawNode.h"

const CFTimeInterval sawLifeTime=8;
const NSString* rotationKey=@"rotationKey";

@implementation ElectricSawNode
{
    BOOL shouldSpeedUp;
    CGSize heroSize;
}

+(instancetype)defaultNode
{
    ElectricSawNode* nod=[ElectricSawNode spriteNodeWithImageNamed:@"blueCover"];
    nod.zPosition=Dot_Z_Position;
    nod.xScale=0;
    nod.yScale=nod.xScale;
    [nod runAction:[SKAction sequence:[NSArray arrayWithObjects:[SKAction scaleTo:1 duration:0.25],nil]] completion:^{
        CFTimeInterval waitTime=1;
        int count=8;
        CFTimeInterval scaleTime=waitTime/count;
        for(int i=0;i<count;i++)
        {
            CFTimeInterval w=waitTime*i/count;
            CGFloat rotation=-M_PI*2/count*i;
            ZZSpriteNode* sawTooth=[ZZSpriteNode spriteNodeWithTexture:[MyTextureAtlas textureNamed:@"sawTooth"]];
            sawTooth.zRotation=rotation;
            sawTooth.zPosition=-1;
            sawTooth.yScale=0;
            sawTooth.xScale=sawTooth.yScale;
            [nod addChild:sawTooth];
            
            [sawTooth runAction:[SKAction sequence:[NSArray arrayWithObjects:[SKAction waitForDuration:w],[SKAction scaleTo:0.9 duration:scaleTime], nil]]];
        }
        
        NSMutableArray* rotationAction=[NSMutableArray arrayWithObject:[SKAction waitForDuration:waitTime+0.2]];
        
        CFTimeInterval deltaTime=0.1;
        CFTimeInterval deltaRotation=M_PI_4;
        for(int i=0;i<count;i++)
        {
            SKAction* ro=[SKAction rotateByAngle:deltaRotation*i/count duration:deltaTime];
            if (i==count-1) {
                ro=[SKAction repeatActionForever:ro];
            }
            [rotationAction addObject:ro];
        }
        [nod runAction:[SKAction sequence:rotationAction] withKey:[rotationKey description]];
    }];
    return nod;
}

-(void)actionWithHero:(SKNode *)hero
{
    self.position=hero.position;
    if ([hero isKindOfClass:[ZZSpriteNode class]]) {
        heroSize=[((ZZSpriteNode*)hero)size];
    }
}

-(void)actionWithTimeInterval:(CFTimeInterval)timeInterval
{
    if (timeInterval-self.createTime>sawLifeTime) {
        [self disappear];
    }
}

-(void)disappear
{
    if (self.disappearing) {
        return;
    }
    self.disappearing=YES;
    
    
    NSMutableArray* rotationAction=[NSMutableArray array];
    
    CFTimeInterval deltaTime=0.1;
    CFTimeInterval deltaRotation=M_PI_4;
    int count=8;
    for(int i=0;i<count;i++)
    {
        SKAction* ro=[SKAction rotateByAngle:deltaRotation*(count-i)/count duration:deltaTime];
        [rotationAction addObject:ro];
    }
    [rotationAction insertObject:[SKAction performSelector:@selector(removeOldRotaionAction) onTarget:self] atIndex:0];
    [rotationAction insertObject:[SKAction animateWithTextures:[NSArray arrayWithObjects:
                                                                [MyTextureAtlas textureNamed:@"redCover"],[MyTextureAtlas textureNamed:@"blueCover"],
                                                                [MyTextureAtlas textureNamed:@"redCover"],[MyTextureAtlas textureNamed:@"blueCover"],
                                                                [MyTextureAtlas textureNamed:@"redCover"],[MyTextureAtlas textureNamed:@"blueCover"],
                                                                [MyTextureAtlas textureNamed:@"redCover"],[MyTextureAtlas textureNamed:@"blueCover"], nil] timePerFrame:0.5] atIndex:0];
    [self runAction:[SKAction sequence:rotationAction] completion:^{
        [self removeAllActions];
        SKAction* scales=[SKAction sequence:[NSArray arrayWithObjects:[SKAction scaleTo:1.2 duration:0.25],[SKAction scaleTo:0 duration:0.25],nil]];
        for (ZZSpriteNode* nod in self.children) {
            [nod runAction:scales];
        }
        [self runAction:[SKAction waitForDuration:0.6] completion:^{
            [self runAction:[SKAction scaleTo:0 duration:0.3] completion:^{
                [self removeFromParent];
            }];
        }];
    }];
}

-(void)removeOldRotaionAction
{
    [self removeActionForKey:[rotationKey description]];
}

-(BOOL)intersectsNode:(SKNode *)node
{
    CGPoint p0=self.position;
    CGPoint p1=node.position;
    CGFloat dx=p0.x-p1.x;
    CGFloat dy=p0.y-p1.y;
    CGFloat distance=sqrtf(dx*dx+dy*dy);
    CGFloat selfWidth=self.size.width;
    if (heroSize.width>selfWidth) {
        selfWidth=heroSize.width;
    }
    if (heroSize.height>selfWidth) {
        selfWidth=heroSize.height;
    }
    if(self.children.firstObject)
    {
        SKNode* nod=self.children.firstObject;
        if ([nod isKindOfClass:[ZZSpriteNode class]]) {
            ZZSpriteNode* tooth=(ZZSpriteNode*)nod;
            if (tooth.size.width>selfWidth) {
                selfWidth=tooth.size.width;
            }
        }
    }
//    printf("selfWidth:%f\n",selfWidth);
    BOOL inter=distance<(selfWidth/2+node.frame.size.width/2);
    return inter;
}

@end

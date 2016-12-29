//
//  MegaBombNode.m
//  thisarrow
//
//  Created by iMac206 on 16/12/21.
//  Copyright © 2016年 jamstudio. All rights reserved.
//

#import "MegaBombNode.h"

const NSString* defaultActionKey=@"defaultActionKey";

@implementation MegaBombNode
{
    ZZSpriteNode* light1;
    ZZSpriteNode* light2;
}

+(instancetype)defaultNode
{
    MegaBombNode* b=[MegaBombNode spriteNodeWithTexture:[MyTextureAtlas textureNamed:@"megabomb"]];
    b.alpha=0.7;
    [b performSelector:@selector(megabombAction) withObject:nil afterDelay:0.01];
    [b performSelector:@selector(disappear) withObject:nil afterDelay:2];
    return b;
}

-(void)megabombAction
{
    CGSize size=self.frame.size;
    CGPoint center=self.position;
    
    CFTimeInterval showTime=0.1+0.1*ZZRandom_1_0_1();
    CFTimeInterval hideTime=0.2+0.1*ZZRandom_1_0_1();
    CFTimeInterval waitTime=0.3+0.2*ZZRandom_1_0_1();
    CGFloat alpha=0.6;
    
    CGFloat offSetRate=0.25;
    
    light1=[ZZSpriteNode spriteNodeWithTexture:[MyTextureAtlas textureNamed:@"lightning1"]];
    light1.position=CGPointMake(center.x+size.width*offSetRate, center.y+size.height*offSetRate);
    light1.alpha=0;
    light1.zPosition=self.zPosition;
    light1.xScale=0.7;
    light1.yScale=light1.xScale;
    [self.parent addChild:light1];
    
    light2=[ZZSpriteNode spriteNodeWithTexture:[MyTextureAtlas textureNamed:@"lightning2"]];
    light2.position=CGPointMake(center.x-size.width*offSetRate, center.y-size.height*offSetRate);
    light2.alpha=light1.alpha;
    light2.zPosition=self.zPosition;
    light2.xScale=light1.xScale;
    light2.yScale=light2.yScale;
    [self.parent addChild:light2];
    
    SKAction* blick1=[SKAction repeatActionForever:[SKAction sequence:
                                                    [NSArray arrayWithObjects:
                                                     [SKAction fadeAlphaTo:alpha duration:showTime],
                                                     [SKAction waitForDuration:waitTime],
                                                     [SKAction fadeAlphaTo:0 duration:hideTime],
                                                     [SKAction waitForDuration:waitTime],
                                                     [SKAction moveBy:CGVectorMake(-size.width*offSetRate*2, 0)  duration:0.01],
                                                     [SKAction fadeAlphaTo:alpha duration:showTime],
                                                     [SKAction waitForDuration:waitTime],
                                                     [SKAction fadeAlphaTo:0 duration:hideTime],
                                                     [SKAction waitForDuration:waitTime],
                                                     [SKAction moveBy:CGVectorMake(size.width*offSetRate*2, 0) duration:0.01],
                                                     nil]]];
    SKAction* blick2=[SKAction repeatActionForever:[SKAction sequence:
                                                    [NSArray arrayWithObjects:
                                                     [SKAction waitForDuration:waitTime],
                                                     [SKAction fadeAlphaTo:alpha duration:showTime],
                                                     [SKAction waitForDuration:waitTime],
                                                     [SKAction fadeAlphaTo:0 duration:hideTime],
                                                     [SKAction moveBy:CGVectorMake(size.width*offSetRate*2, 0)  duration:0.01]
                                                     ,[SKAction waitForDuration:waitTime],
                                                     [SKAction fadeAlphaTo:alpha duration:showTime],
                                                     [SKAction waitForDuration:waitTime],
                                                     [SKAction fadeAlphaTo:0 duration:hideTime],
                                                     [SKAction moveBy:CGVectorMake(-size.width*offSetRate*2, 0)  duration:0.01]
                                                     , nil]]];
    
    [light1 runAction:blick1];
    [light2 runAction:blick2];
    
    self.xScale=0.3;
    self.yScale=self.xScale;
    SKAction* scales=[SKAction sequence:[NSArray arrayWithObjects:[SKAction scaleTo:1.05 duration:0.25],[SKAction scaleTo:1 duration:0.25], nil]];
    SKAction* rep=[SKAction repeatAction:scales count:3];
    [self runAction:rep];
    
    ZZSpriteNode* shockWave=[ZZSpriteNode spriteNodeWithTexture:[MyTextureAtlas textureNamed:@"shockWave"]];
    shockWave.alpha=0.4;
    shockWave.position=self.position;
    shockWave.zPosition=self.zPosition-1;
    [self.parent addChild:shockWave];
    [shockWave runAction:[SKAction scaleTo:6 duration:0.2] completion:^{
        [shockWave removeFromParent];
    }];
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

-(void)disappear
{
    ZZSpriteNode* spark=[ZZSpriteNode spriteNodeWithTexture:[MyTextureAtlas textureNamed:@"spark"]];
    spark.position=self.position;
    [self.parent addChild:spark];
    spark.alpha=0;
    SKAction* sp_show=[SKAction sequence:[NSArray arrayWithObjects:[SKAction fadeAlphaTo:0.4 duration:0],[SKAction group:[NSArray arrayWithObjects:[SKAction scaleTo:0.1 duration:0.5],[SKAction fadeAlphaTo:0 duration:0.5], nil]], nil]];
    [spark runAction:sp_show completion:^{
        [spark removeFromParent];
    }];
    
    [light1 removeFromParent];
    [light2 removeFromParent];
    [super disappear];
}

@end

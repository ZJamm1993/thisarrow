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
    WeaponNode* light1;
    WeaponNode* light2;
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
    
    CFTimeInterval showTime=0.1;
    CFTimeInterval hideTime=0.2;
    CFTimeInterval waitTime=0.3;
    CGFloat alpha=0.6;
    
    SKAction* blick1=[SKAction repeatActionForever:[SKAction sequence:[NSArray arrayWithObjects:[SKAction fadeAlphaTo:alpha duration:showTime],[SKAction waitForDuration:waitTime],[SKAction fadeAlphaTo:0 duration:hideTime],[SKAction waitForDuration:waitTime], nil]]];
    SKAction* blick2=[SKAction repeatActionForever:[SKAction sequence:[NSArray arrayWithObjects:[SKAction waitForDuration:waitTime],[SKAction fadeAlphaTo:alpha duration:showTime],[SKAction waitForDuration:waitTime],[SKAction fadeAlphaTo:0 duration:hideTime], nil]]];
    
    light1=[WeaponNode spriteNodeWithTexture:[MyTextureAtlas textureNamed:@"lightning1"]];
    light1.position=CGPointMake(center.x+size.width*0.25, center.y+size.height*0.25);
    light1.alpha=0;
    [light1 runAction:blick1];
    [self.parent addChild:light1];
    
    light2=[WeaponNode spriteNodeWithTexture:[MyTextureAtlas textureNamed:@"lightning2"]];
    light2.position=CGPointMake(center.x-size.width*0.25, center.y-size.height*0.25);
    light2.alpha=0;
    [light2 runAction:blick2];
    [self.parent addChild:light2];
    
    SKAction* scales=[SKAction sequence:[NSArray arrayWithObjects:[SKAction scaleTo:1.05 duration:0.25],[SKAction scaleTo:1 duration:0.25], nil]];
    SKAction* rep=[SKAction repeatAction:scales count:3];
    [self runAction:rep];
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
    WeaponNode* spark=[WeaponNode spriteNodeWithTexture:[MyTextureAtlas textureNamed:@"spark"]];
    spark.position=self.position;
    [self.parent addChild:spark];
    spark.alpha=0;
    SKAction* sp_show=[SKAction sequence:[NSArray arrayWithObjects:[SKAction fadeAlphaTo:0.6 duration:0.25],[SKAction group:[NSArray arrayWithObjects:[SKAction scaleTo:0.1 duration:0.5],[SKAction fadeAlphaTo:0 duration:0.5], nil]], nil]];
    [spark runAction:sp_show completion:^{
        [spark removeFromParent];
    }];
    
    [light1 disappear];
    [light2 disappear];
    [super disappear];
}

@end

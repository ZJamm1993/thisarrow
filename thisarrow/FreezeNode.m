//
//  FreezeNode.m
//  thisarrow
//
//  Created by Macx on 2017/8/21.
//  Copyright © 2017年 jamstudio. All rights reserved.
//

#import "FreezeNode.h"

@implementation FreezeNode

+(instancetype)defaultNode
{
    FreezeNode* fre=[FreezeNode spriteNodeWithColor:[SKColor clearColor] size:CGSizeMake(155, 155)];
    
    [fre performSelector:@selector(freezeAction) withObject:nil afterDelay:0.01];
    [fre performSelector:@selector(disappear) withObject:nil afterDelay:2];
    
    return fre;
}

-(void)freezeAction
{
    NSInteger icecount=12;
    
    CGFloat ranRad=(CGFloat)(arc4random()%360)/180*M_PI;
    
    for (int i=0; i<icecount; i++) {
        NSString* name=[NSString stringWithFormat:@"ice%d",arc4random()%8+1];
        ZZSpriteNode* ice=[ZZSpriteNode spriteNodeWithTexture:[MyTextureAtlas textureNamed:name]];
        ice.zRotation=M_PI*2/icecount*i+ranRad;
        ice.anchorPoint=CGPointMake(0.5, 0);
        ice.xScale=0;
        ice.yScale=0;
        
        [ice runAction:[SKAction scaleTo:1 duration:0.1] completion:^{
            
        }];
        
        [self addChild:ice];
    }
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
    NSArray* ices=self.children;
    for (ZZSpriteNode* ice in ices) {
        [ice removeFromParent];
        ice.position=self.position;
        [self.parent addChild:ice];
        [ice runAction:[SKAction sequence:[NSArray arrayWithObjects:[SKAction waitForDuration:0.5*ZZRandom_0_1()],[SKAction scaleTo:0 duration:0.75], nil]] completion:^{
            [ice removeFromParent];
        }];
    }
    [super disappear];
}

@end

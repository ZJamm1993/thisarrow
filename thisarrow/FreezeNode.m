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
    FreezeNode* fre=[FreezeNode spriteNodeWithColor:[SKColor clearColor] size:CGSizeMake(300, 300)];
    fre.zPosition=Background_Z_Position;
    [fre performSelector:@selector(freezeAction) withObject:nil afterDelay:0.01];
    [fre performSelector:@selector(disappear) withObject:nil afterDelay:2];
    
    return fre;
}

-(void)freezeAction
{
    NSInteger icecount=12;
    
    CGFloat ranRad=(CGFloat)(arc4random()%360)/180*M_PI;
    
    CGFloat totalHeight=0;
    
    for (int i=0; i<icecount; i++) {
        NSString* name=[NSString stringWithFormat:@"ice%d",arc4random()%8+1];
        ZZSpriteNode* ice=[ZZSpriteNode spriteNodeWithTexture:[MyTextureAtlas textureNamed:name]];
//        NSLog(@"%f",ice.size.height);
        
        totalHeight=totalHeight+ice.size.height;
        
        ice.zRotation=M_PI*2/icecount*i+ranRad;
        ice.anchorPoint=CGPointMake(0.5, 0);
        ice.xScale=0;
        ice.yScale=0;
        
        [ice runAction:[SKAction scaleTo:1 duration:0.1] completion:^{
            
        }];
        
        [self addChild:ice];
    }
    
    CGFloat avgHeight=(totalHeight/icecount)*2;
    self.size=CGSizeMake(avgHeight, avgHeight);
    
    NSLog(@"parent? %@",self.parent);
    
    for (int i=0; i<icecount; i++) {
        NSString* name=[NSString stringWithFormat:@"iceSmall%d",arc4random()%2+1];
        ZZSpriteNode* ic=[ZZSpriteNode spriteNodeWithImageNamed:name];
        ic.zPosition=Weapon_Z_Position+1;
        ic.zRotation=M_PI*2*ZZRandom_0_1();
        ic.position=self.position;
        [self.parent addChild:ic];
        
        CGFloat ranDis=avgHeight/2+20*ZZRandom_1_0_1();
        CGFloat dx=ranDis*sin(-ic.zRotation);
        CGFloat dy=ranDis*cos(ic.zRotation);
        [ic runAction:[SKAction sequence:[NSArray arrayWithObjects:[SKAction moveByX:dx y:dy duration:0.1],[SKAction waitForDuration:0.75],[SKAction fadeAlphaTo:0 duration:0.5], nil]] completion:^{
            [ic removeFromParent];
        }];
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

//
//  GreenCoverNode.m
//  thisarrow
//
//  Created by iMac206 on 17/1/3.
//  Copyright © 2017年 jamstudio. All rights reserved.
//

#import "GreenCoverNode.h"

@implementation GreenCoverNode

+(instancetype)defaultNode
{
    GreenCoverNode* nod=[GreenCoverNode spriteNodeWithImageNamed:@"greenCover"];
    return nod;
}

-(void)actionWithHero:(SKNode *)hero
{
    self.position=hero.position;
    if (arc4random()%2==0) {
        return;
    }
    ZZSpriteNode* cir=[ZZSpriteNode spriteNodeWithImageNamed:@"yellowCircle"];
    [hero.parent addChild:cir];
    cir.xScale=0.9;
    cir.yScale=cir.xScale;
    cir.zPosition=Background_Z_Position;
    cir.position=self.position;
    [cir runAction:[SKAction scaleTo:0 duration:1] completion:^{
        [cir removeFromParent];
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

@end

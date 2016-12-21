//
//  MegaBombNode.m
//  thisarrow
//
//  Created by iMac206 on 16/12/21.
//  Copyright © 2016年 jamstudio. All rights reserved.
//

#import "MegaBombNode.h"

@implementation MegaBombNode

+(instancetype)defaultNode
{
    MegaBombNode* b=[MegaBombNode spriteNodeWithTexture:[MyTextureAtlas textureNamed:@"megabomb"]];
    b.alpha=0.8;
    
    [b performSelector:@selector(disappear) withObject:nil afterDelay:1];
    return b;
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

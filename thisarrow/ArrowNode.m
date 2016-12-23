//
//  ArrowNode.m
//  thisarrow
//
//  Created by iMac206 on 16/12/13.
//  Copyright © 2016年 jamstudio. All rights reserved.
//

#import "ArrowNode.h"

@implementation ArrowNode

+(instancetype)defaultNode
{
    return [ArrowNode spriteNodeWithTexture:[MyTextureAtlas textureNamed:@"arrow"]];
}

-(void)actionWithAcceleration:(CMAcceleration)acc
{
    SKNode* parent=self.parent;
    if (parent) {
        CGFloat m=20;
        CGFloat y=-acc.x*m;
        CGFloat x=acc.y*m;
        
        CGFloat acc_speed=sqrt(acc.x*acc.x+acc.y*acc.y);
//        NSLog(@"acc_speed: %f",acc_speed);
//        NSLog(@"x:%f,y:%f,z:%f",acc.x,acc.y,acc.z);
        if (acc_speed>0.02) {
            CGFloat ra=atan2f(-x, y);
            [self runAction:[SKAction rotateToAngle:ra duration:0.1 shortestUnitArc:YES]];
        }
        CGFloat sx=self.position.x+x;
        CGFloat sy=self.position.y+y;
        CGFloat w=self.size.width/2;
        if (sx-w<0) {
            sx=w;
        }
        if (sx+w>parent.frame.size.width) {
            sx=parent.frame.size.width-w;
        }
        if (sy-w<0) {
            sy=w;
        }
        if (sy+w>parent.frame.size.height) {
            sy=parent.frame.size.height-w;
        }
        CGPoint newP=CGPointMake(sx, sy);
        self.position=newP;
    }
}

-(void)actionWithPoint:(CGPoint)point
{
    CGFloat dx=point.x-self.position.x;
    CGFloat dy=point.y-self.position.y;
    CGFloat rotation=atan2f(-dx, dy);
    CGFloat distance=sqrtf(dx*dx+dy*dy);
    [self runAction:[SKAction rotateToAngle:rotation duration:0.1 shortestUnitArc:YES]];
    [self runAction:[SKAction moveTo:point duration:distance/60]];
}

@end

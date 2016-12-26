//
//  ArrowNode.m
//  thisarrow
//
//  Created by iMac206 on 16/12/13.
//  Copyright © 2016年 jamstudio. All rights reserved.
//

#import "ArrowNode.h"

@implementation ArrowNode
{
    NSMutableArray* tailNodes;
}

+(instancetype)defaultNode
{
    ArrowNode* arrow=[ArrowNode spriteNodeWithTexture:[MyTextureAtlas textureNamed:@"arrow"]];
    return arrow;
}

-(void)actionWithAcceleration:(CMAcceleration)acc
{
    SKNode* parent=self.parent;
    if (parent) {
        CGFloat m=10;
        CGFloat y=-acc.x*m;
        CGFloat x=acc.y*m;
        
        CGFloat acc_speed=sqrt(acc.x*acc.x+acc.y*acc.y);
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
    [self showTail];
}

-(void)actionWithPoint:(CGPoint)point
{
    CGFloat dx=point.x-self.position.x;
    CGFloat dy=point.y-self.position.y;
    CGFloat rotation=atan2f(-dx, dy);
    CGFloat distance=sqrtf(dx*dx+dy*dy);
    [self runAction:[SKAction rotateToAngle:rotation duration:0.1 shortestUnitArc:YES]];
    [self runAction:[SKAction moveTo:point duration:distance/90]];
    [self showTail];
}

-(void)showTail
{
    if (tailNodes.count==0) {
        tailNodes=[NSMutableArray array];
        int count=20;
        for (int i=0; i<count; i++) {
            CGFloat w=self.size.width*0.4*i/count;
            ZZSpriteNode* tn=[ZZSpriteNode spriteNodeWithColor:[SKColor purpleColor] size:CGSizeMake(w, w)];
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
    }
    ZZSpriteNode* tnLast=[tailNodes lastObject];
    tnLast.position=self.position;
}

@end

//
//  ZZSpriteNode.m
//  thisarrow
//
//  Created by iMac206 on 16/12/20.
//  Copyright © 2016年 jamstudio. All rights reserved.
//

#import "ZZSpriteNode.h"

@implementation ZZSpriteNode

-(BOOL)intersectsNode:(SKNode *)node
{
    CGFloat scaleRate=0.8;
    CGRect r1=self.frame;
    CGRect r2=node.frame;
    CGRect newR1=[ZZSpriteNode resizeRect:r1 Scale:scaleRate];
    CGRect newR2=[ZZSpriteNode resizeRect:r2 Scale:scaleRate];
    BOOL intersects=CGRectIntersectsRect(newR1, newR2);
    return intersects;
    
//    return [super intersectsNode:node];
}

-(void)removeAllActions
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [super removeAllActions];
    for (SKNode* child in self.children) {
        [child removeAllActions];
    }
}

+(CGRect)resizeRect:(CGRect)rect Scale:(CGFloat)rate
{
    if (rate<=0) {
        return rect;
    }
    
    CGFloat w=rect.size.width;
    CGFloat h=rect.size.height;
    CGFloat cx=rect.origin.x+w/2;
    CGFloat cy=rect.origin.y+h/2;
    CGFloat wh=(w<h?w:h)*rate;
    CGRect newRect=CGRectMake(cx-wh/2, cy-wh/2, wh, wh);
    return newRect;
}

-(BOOL)touchBottomBound
{
    return (self.frame.origin.y<0);
}

-(BOOL)touchTopBound
{
    return (CGRectGetMaxY(self.frame)>self.parent.frame.size.height);
}

-(BOOL)touchLeftBound
{
    return (self.frame.origin.x<0);
}

-(BOOL)touchRightBound
{
    return (CGRectGetMaxX(self.frame)>self.parent.frame.size.width);
}

+(CGPoint)rotateVector:(CGPoint)vec rotation:(CGFloat)rad
{
    CGFloat x=vec.x*cos(rad)-vec.y*sin(rad);
    CGFloat y=vec.x*sin(rad)+vec.y*cos(rad);
    return CGPointMake(x, y);    
}

+(CGPoint)rotatePoint:(CGPoint)poi origin:(CGPoint)ori rotation:(CGFloat)rad
{
    CGPoint tempPoint=CGPointMake(poi.x-ori.x, poi.y-ori.y);
    CGPoint rotatedPoint=[self rotateVector:tempPoint rotation:rad];
    CGPoint newPoint=CGPointMake(rotatedPoint.x+ori.x,rotatedPoint.y+ori.y);
    return newPoint;
}

+(CGPoint)randomPositionInRect:(CGRect)rect
{
    CGFloat x=ZZRandom_0_1()*rect.size.width;
    CGFloat y=ZZRandom_0_1()*rect.size.height;
    return CGPointMake(x+rect.origin.x, y+rect.origin.y);
}

+(CGRect)rectWithCenter:(CGPoint)center width:(CGFloat)width height:(CGFloat)height
{
    CGRect rect=CGRectMake(center.x-width/2, center.y-height/2, width, height);
    return rect;
}

-(void)actionWithTimeInterval:(CFTimeInterval)timeInterval
{
    
}

@end

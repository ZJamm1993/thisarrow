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
    CGRect newR1=[self rect:r1 Scale:scaleRate];
    CGRect newR2=[self rect:r2 Scale:scaleRate];
    BOOL intersects=CGRectIntersectsRect(newR1, newR2);
    return intersects;
    
//    return [super intersectsNode:node];
}

-(CGRect)rect:(CGRect)rect Scale:(CGFloat)rate
{
    if (rate<=0) {
        return rect;
    }
    CGFloat x=rect.origin.x;
    CGFloat y=rect.origin.y;
    CGFloat w=rect.size.width;
    CGFloat h=rect.size.height;
    CGRect newRect=CGRectMake(x+w/2-(w*rate/2), y+h/2-(h*rate/2), w*rate, h*rate);
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

-(CGPoint)rotateVector:(CGPoint)vec rotation:(CGFloat)rad
{
    CGFloat x=vec.x*cos(rad)-vec.y*sin(rad);
    CGFloat y=vec.x*sin(rad)+vec.y*cos(rad);
    return CGPointMake(x, y);    
}

-(CGPoint)rotatePoint:(CGPoint)poi origin:(CGPoint)ori rotation:(CGFloat)rad
{
    CGPoint tempPoint=CGPointMake(poi.x-ori.x, poi.y-ori.y);
    CGPoint rotatedPoint=[self rotateVector:tempPoint rotation:rad];
    CGPoint newPoint=CGPointMake(rotatedPoint.x+ori.x,rotatedPoint.y+ori.y);
    return newPoint;
}

@end

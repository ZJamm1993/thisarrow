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

@end

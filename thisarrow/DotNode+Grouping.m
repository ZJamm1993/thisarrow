//
//  DotNode+Grouping.m
//  thisarrow
//
//  Created by ohaha on 2019/8/13.
//  Copyright © 2019年 jamstudio. All rights reserved.
//

#import "DotNode+Grouping.h"

@implementation DotNode (Grouping)

+(NSArray*)randomGroupNodeWithDots:(NSArray *)dots target:(SKNode *)target
{
    //dont add child here.
    
    DotGroupType ranType=
    //    DotGroupTypePointer;
    arc4random()%DotGroupTypeNothing;
    
    //    ranType=DotGroupTypePointer;
    
    NSMutableArray* newDots=[NSMutableArray array];
    
    CGSize bound=target.parent.frame.size;
    
    if (ranType==DotGroupTypeSurround) {
        CGFloat r=bound.height*0.5*0.9;
        int count=16;
        int ran=arc4random()%100;
        int numCircle=0;
        if (ran<50) {
            numCircle=1;
        }else if(ran<75)
        {
            numCircle=2;
        }
        else {
            numCircle=3;
        }
        for (int i=0; i<count; i++) {
            for(int j=0;j<numCircle;j++)
            {
                CGFloat rr=r-12*j;
                CGFloat rad=M_PI*2*i/count;
                CGFloat x=target.position.x+rr*sin(rad);
                CGFloat y=target.position.y+rr*cos(rad);
                if (x<0||x>bound.width) {
                    continue;
                }
                if (y<0||y>bound.height) {
                    continue;
                }
                DotNode* dot=[DotNode defaultNode];
                dot.groupType=DotGroupTypeSurround;
                dot.position=CGPointMake(x, y);
                dot.followSpeed=defaultFollowSpeed*1.5;
                [dot wakeUp];
                [newDots addObject:dot];
            }
        }
    }
    
    else if(ranType==DotGroupTypeQueue)
    {
        
        CGFloat w=[DotNode defaultWidth];
        BOOL vertical=
        //NO;
        arc4random()%2==0;
        if (vertical) {
            int queueCount=20;
            CGFloat interval=bound.width/queueCount;
            for(int i=0;i<queueCount;i++)
            {
                CGFloat x=interval/2+i*interval;
                for (int j=0; j<2; j++) {
                    BOOL isB=j==0;
                    CGFloat y=isB?w/2:bound.height-w/2;
                    DotNode* d=[DotNode defaultNode];
                    d.position=CGPointMake(x, y);
                    d.groupType=DotGroupTypeQueue;
                    d.speedY=isB?defaultFollowSpeed:-defaultFollowSpeed;
                    [newDots addObject:d];
                    
                    d.xScale=0;
                    d.yScale=0;
                    
                    CFTimeInterval fre=0.1;
                    CFTimeInterval waitTime=fre*queueCount;
                    [d runAction:[SKAction waitForDuration:i*fre] completion:^{
                        [d runAction:[DotNode wakeUpAction] completion:^{
                            [d runAction:[SKAction waitForDuration:waitTime-i*fre]
                              completion:^{
                                  d.isAwake=YES;
                              }];
                        }];
                    }];
                }
            }
        }
        else
        {
            int em=0;
            int queueCount=bound.height/w-em*2-3;
            BOOL isL=arc4random()%2==0;
            CGFloat x=isL?w/2:bound.width-w/2;
            CGFloat speedX=2*defaultFollowSpeed*(isL?1:-1);
            for (int i=0; i<queueCount; i++) {
                CGFloat y=em*w+w/2+i*w;
                DotNode* d=[DotNode defaultNode];
                d.position=CGPointMake(x, y);
                d.groupType=DotGroupTypeQueue;
                d.speedX=speedX;
                [newDots addObject:d];
                [d wakeUp];
            }
        }
    }
    
    else if(ranType==DotGroupTypePointer)
    {
        int catchDotBound=160;
        
        int numPointer=1;
        int raa=arc4random()%100;
        if (raa<40) {
            numPointer=1;
        }
        else if(raa<70)
        {
            numPointer=2;
        }
        else if(raa<90)
        {
            numPointer=3;
        }
        else{
            numPointer=4;
        }
        
        NSMutableArray* groupedDots=[NSMutableArray array];
        
        NSMutableArray* positions=[NSMutableArray array];
        
        NSMutableArray* freeDots=[NSMutableArray array];
        
        for (int i=0; i<numPointer; i++) {
            CGRect rect=[ZZSpriteNode rectWithCenter:ccp(bound.width/2, bound.height/2) width:bound.width-catchDotBound height:bound.height-catchDotBound];
            CGPoint randomPoint=[ZZSpriteNode randomPositionInRect:rect];
            
            //            randomPoint=CGPointMake(bound.width/2, bound.height/2);
            
            NSValue* value=[NSValue valueWithCGPoint:randomPoint];
            
            [positions addObject:value];
            [groupedDots addObject:[NSMutableArray array]];
        }
        
        //find those who is no grouping, and group them
        for (DotNode* d in dots) {
            if ((d.groupType==DotGroupTypeNothing)&&(arc4random()%3==0)&&!d.isFreeze)
            {
                [freeDots addObject:d];
            }
        }
        
        for (DotNode* d in freeDots) {
            for (int i=0; i<positions.count; i++) {
                NSValue* value=[positions objectAtIndex:i];
                CGPoint p=value.CGPointValue;
                CGRect rect=[ZZSpriteNode rectWithCenter:p width:catchDotBound height:catchDotBound];
                if (CGRectContainsPoint(rect, d.position)) {
                    NSMutableArray* ar=[groupedDots objectAtIndex:i];
                    [ar addObject:d];
                    break;
                }
            }
        }
        
        //i guess x dots is enough to shape a pointer
        NSInteger pointerDotCount=14;
        
        for (int i=0;i<groupedDots.count;i++) {
            NSValue* value=[positions objectAtIndex:i];
            CGPoint p=value.CGPointValue;
            CGRect rect=[ZZSpriteNode rectWithCenter:p width:catchDotBound height:catchDotBound];
            NSMutableArray* arr=[groupedDots objectAtIndex:i];
            
            while (arr.count<pointerDotCount) {
                DotNode* d=[DotNode defaultNode];
                d.position=[ZZSpriteNode randomPositionInRect:rect];
                [arr addObject:d];
            }
            
            while (arr.count>pointerDotCount) {
                [arr removeLastObject];
            }
            
            CFTimeInterval shapingTime=2+0.5*ZZRandom_1_0_1();
            CFTimeInterval reshapingTime=1+0.5*ZZRandom_1_0_1();
            
            for (int j=0;j<arr.count;j++) {
                DotNode* d=[arr objectAtIndex:j];
                d->pointerGroup = [NSArray arrayWithArray:arr];
                d.groupType=DotGroupTypePointer;
                d.isAwake=NO;
                
                CGFloat w=d.size.width/2;
                CGFloat dx=0;
                CGFloat dy=0;
                dx=w*2*ZZRandom_1_0_1();
                dy=w*2*ZZRandom_1_0_1();
                
                NSInteger la=arr.count-1-j;
                CGFloat nx=0;
                CGFloat ny=j*w-5*w;
                if (la==0) {
                    nx=-w;
                    ny=3*w;
                }
                else if(la==1)
                {
                    nx=w;
                    ny=3*w;
                }
                else if(la==2)
                {
                    nx=-2*w;
                    ny=2*w;
                }
                else if(la==3)
                {
                    nx=2*w;
                    ny=2*w;
                }
                
                nx=nx*0.6;
                
                if (d.parent==nil) {
                    d.xScale=0;
                    d.yScale=0;
                }
                [d removeFromParent];
                
                d.speedX=0;
                d.speedY=0;
                
                SKAction* reshape=[SKAction moveTo:CGPointMake(nx+p.x, ny+p.y) duration:reshapingTime];
                d.originPoint=CGPointMake(-nx, -ny);
                CGPoint newP=CGPointMake(p.x+dx, p.y+dy);
                [d runAction:[SKAction group:[NSArray arrayWithObjects:
                                              [SKAction moveTo:newP duration:shapingTime],
                                              [SKAction sequence:[NSArray arrayWithObjects:
                                                                  [SKAction scaleTo:0.0 duration:shapingTime/2],
                                                                  [SKAction scaleTo:1 duration:shapingTime/2], nil]],
                                              nil]] completion:^{
                    [d runAction:[SKAction sequence:[NSArray arrayWithObjects:[SKAction waitForDuration:0.1],reshape, nil]] completion:^{
                        d.isAwake=YES;
                        [d runAction:[SKAction waitForDuration:1.5] completion:^{
                            [d shootPointer];
                        }];
                    }];
                    
                }];
            }
            
            [newDots addObjectsFromArray:arr];
        }
    }
    //    else if(ranType==DotGroupTypeTennis)
    //    {
    //        int catchDotBound=160;
    //
    //        int numPointer=1;
    //        int raa=arc4random()%100;
    //        if (raa<40) {
    //            numPointer=1;
    //        }
    //        else if(raa<70)
    //        {
    //            numPointer=2;
    //        }
    //        else if(raa<90)
    //        {
    //            numPointer=3;
    //        }
    //        else{
    //            numPointer=4;
    //        }
    //
    //        NSMutableArray* groupedDots=[NSMutableArray array];
    //
    //        NSMutableArray* positions=[NSMutableArray array];
    //
    //        NSMutableArray* freeDots=[NSMutableArray array];
    //
    //        for (int i=0; i<numPointer; i++) {
    //            CGRect rect=[ZZSpriteNode rectWithCenter:ccp(bound.width/2, bound.height/2) width:bound.width-catchDotBound height:bound.height-catchDotBound];
    //            CGPoint randomPoint=[ZZSpriteNode randomPositionInRect:rect];
    //
    //            //            randomPoint=CGPointMake(bound.width/2, bound.height/2);
    //
    //            NSValue* value=[NSValue valueWithCGPoint:randomPoint];
    //
    //            [positions addObject:value];
    //            [groupedDots addObject:[NSMutableArray array]];
    //        }
    //
    //        //find those who is no grouping, and group them
    //        for (DotNode* d in dots) {
    //            if ((d.groupType==DotGroupTypeNothing)&&(arc4random()%3==0)&&!d.isFreeze)
    //            {
    //                [freeDots addObject:d];
    //            }
    //        }
    //
    //        for (DotNode* d in freeDots) {
    //            for (int i=0; i<positions.count; i++) {
    //                NSValue* value=[positions objectAtIndex:i];
    //                CGPoint p=value.CGPointValue;
    //                CGRect rect=[ZZSpriteNode rectWithCenter:p width:catchDotBound height:catchDotBound];
    //                if (CGRectContainsPoint(rect, d.position)) {
    //                    NSMutableArray* ar=[groupedDots objectAtIndex:i];
    //                    [ar addObject:d];
    //                    break;
    //                }
    //            }
    //        }
    //    }
    
    return newDots;
}


@end

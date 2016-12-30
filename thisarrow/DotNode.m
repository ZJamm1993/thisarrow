//
//  DotNode.m
//  thisarrow
//
//  Created by jam on 16-12-24.
//  Copyright (c) 2016年 jamstudio. All rights reserved.
//

#import "DotNode.h"

const CGFloat defaultFollowSpeed=16/60.0;
const CGFloat defaultSlowDownRate=0.98;
const CGFloat defaultReboundRate=0.4;
const CGFloat defaultPointerSpeed=120/60.0;

@implementation DotNode
{
    ZZSpriteNode* shadow;
}

+(instancetype)defaultNode
{
    DotNode* dot=[DotNode spriteNodeWithTexture:[MyTextureAtlas textureNamed:@"redDot"]];
    return dot;
}

+(instancetype)randomPositionNodeOnSize:(CGSize)size
{
    DotNode* dot=[DotNode defaultNode];
    CGFloat r=dot.size.width/2;
    CGFloat x=(arc4random()%(int)(size.width-2*r));
    CGFloat y=(arc4random()%(int)(size.height-2*r));
    CGPoint p=CGPointMake(r+x, r+y);
    dot.position=p;
    return dot;
}

-(instancetype)initWithTexture:(SKTexture *)texture
{
    self=[super initWithTexture:texture];
    if (self) {
        self.zPosition=Dot_Z_Position;
        self.followSpeed=defaultFollowSpeed;
        self.groupType=DotGroupTypeNothing;
        
        shadow=[ZZSpriteNode spriteNodeWithTexture:[MyTextureAtlas textureNamed:@"dotShadow"]];
        shadow.xScale=1.1;
        shadow.yScale=shadow.xScale;
        shadow.zPosition=-1;
        [self addChild:shadow];
    }
    return self;
}

+(NSArray*)randomGroupNodeWithDots:(NSArray *)dots target:(SKNode *)target
{
    //dont add child here.
    
    DotGroupType ranType=
//    DotGroupTypePointer;
    arc4random()%DotGroupTypeNothing;
    
    NSMutableArray* newDots=[NSMutableArray array];
    
    CGSize bound=target.parent.frame.size;
    
    if (ranType==DotGroupTypeSurround) {
        CGFloat r=bound.height*0.5*0.9;
        int count=16;
        int numCircle=arc4random()%3+1;
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
                dot.followSpeed=defaultFollowSpeed*1.3;
                [dot wakeUp];
                [newDots addObject:dot];
            }
        }
    }
    
    else if(ranType==DotGroupTypePointer)
    {
        int numPointer=//1;
        arc4random()%2+1;
        NSMutableArray* freeDots=[NSMutableArray array];
        
        //find those who is no grouping, and group them
        for (DotNode* d in dots) {
            if (d.groupType==DotGroupTypeNothing) {
                [freeDots addObject:d];
            }
        }
        
        //i guess x dots is enough to shape a pointer
        NSInteger pointerDotCount=34;
        NSInteger totalCount=pointerDotCount*numPointer;
        
        while (freeDots.count<totalCount) {
            DotNode* d=[DotNode randomPositionNodeOnSize:bound];
            [freeDots addObject:d];
        }
        
        while (freeDots.count>totalCount) {
            DotNode* d=[freeDots lastObject];
            [d removeFromParent];
            [freeDots removeLastObject];
        }
        
        //remove if need
        for (DotNode* d in freeDots) {
            d.groupType=DotGroupTypePointer;
            d.isAwake=NO;
//            if (d.parent) {
//                [d removeFromParent];
//            }
        }
        
        NSMutableArray* origins=[NSMutableArray array];
        if (numPointer==1)
        {
            [origins addObject:[NSValue valueWithCGPoint:CGPointMake(bound.width*0.5, bound.height*0.5)]];
        }
        else if(numPointer==2)
        {
            [origins addObject:[NSValue valueWithCGPoint:CGPointMake(bound.width*0.33, bound.height*0.33)]];
            [origins addObject:[NSValue valueWithCGPoint:CGPointMake(bound.width*0.66, bound.height*0.66)]];
        }
        else if(numPointer==3)
        {
            [origins addObject:[NSValue valueWithCGPoint:CGPointMake(bound.width*0.5, bound.height*0.75)]];
            [origins addObject:[NSValue valueWithCGPoint:CGPointMake(bound.width*0.25, bound.height*0.25)]];
            [origins addObject:[NSValue valueWithCGPoint:CGPointMake(bound.width*0.75, bound.height*0.25)]];
        }
        else
        {
            for (int i=0; i<10; i++) {
                [origins addObject:[NSValue valueWithCGPoint:CGPointZero]];
            }
        }
        
        for(int i=0;i<numPointer;i++)
        {
            NSArray* dotsGroup=[freeDots subarrayWithRange:NSMakeRange(i*pointerDotCount, pointerDotCount)];
            CGPoint ori=[[origins objectAtIndex:i]CGPointValue];
            [DotNode buildPointerShaperWithDots:dotsGroup origin:ori];
        }
        
        [newDots addObjectsFromArray:freeDots];
    }
    
    return newDots;
}

+(NSArray*)buildPointerShaperWithDots:(NSArray*)dots origin:(CGPoint)ori
{
    for (int i=0; i<dots.count; i++) {
        DotNode* d=[dots objectAtIndex:i];
        CGFloat w=d.size.width/2;
        CGFloat dx=0;
        CGFloat dy=0;
        dx=i%3*(w)-w;
        dy=i/3*(w)-(w*4);
        
        NSInteger la=dots.count-1-i;
        if (la==0) {
            dx=0;
            dy=w*5;
        }
        else if(la==1)
        {
            dx=-w*2;
            dy=w*3;
        }
        else if(la==2)
        {
            dx=w*2;
            dy=w*3;
        }
        else if(la==3)
        {
            dx=-w*2;
            dy=w*2;
        }
        else if(la==4)
        {
            dx=w*2;
            dy=w*2;
        }
        else if(la==5)
        {
            dx=-w*3;
            dy=w*2;
        }
        else if(la==6)
        {
            dx=w*3;
            dy=w*2;
        }
        
        if (d.parent==nil) {
            d.xScale=0;
            d.yScale=0;
        }
        [d removeFromParent];
        d.originPoint=CGPointMake(-dx, -dy);
        d.speedX=0;
        d.speedY=0;
        CFTimeInterval shapingTime=2;
        CGPoint newP=CGPointMake(ori.x+dx, ori.y+dy);
        [d runAction:[SKAction group:[NSArray arrayWithObjects:
                       [SKAction moveTo:newP duration:shapingTime],
                       [SKAction sequence:[NSArray arrayWithObjects:
                                           [SKAction scaleTo:0.5 duration:shapingTime/2],
                                           [SKAction scaleTo:1 duration:shapingTime/2], nil]],
                                      nil]] completion:^{
            d.isAwake=YES;
            [d runAction:[SKAction waitForDuration:1.5] completion:^{
                [d shootPointer];
            }];
        }];
    }
    return dots;
}

-(void)wakeUp
{
    _isAwake=NO;
    
    self.xScale=0;
    self.yScale=0;
    
    CFTimeInterval blinkTime=0.25;
    
    SKAction* scales=[SKAction sequence:[NSArray arrayWithObjects:[SKAction scaleTo:1 duration:blinkTime*2],[SKAction scaleTo:0.5 duration:blinkTime],[SKAction scaleTo:1 duration:blinkTime], nil]];
    [self runAction:scales completion:^{
        _isAwake=YES;
    }];
}

-(void)shootPointer
{
    self.originPoint=CGPointZero;
    self.speedX=defaultPointerSpeed*sinf(-self.zRotation);
    self.speedY=defaultPointerSpeed*cosf(-self.zRotation);
}

-(void)actionWithTarget:(SKNode *)node
{
    if (node.parent==nil) {
        [self removeFromParent];
        return;
    }
    
    if (_isDead||!_isAwake) {
        return;
    }

    self.position=CGPointMake(self.position.x+self.speedX, self.position.y+self.speedY);
    
    if (self.groupType!=DotGroupTypePointer) {
        self.speedX=self.speedX*defaultSlowDownRate;
        self.speedY=self.speedY*defaultSlowDownRate;
    }
    
    if (self.touchTopBound) {
        self.speedY=-fabsf(self.speedY)*ZZRandom_0_1()*defaultReboundRate;
        self.speedX=defaultPointerSpeed*ZZRandom_1_0_1()*defaultReboundRate;
    }
    if (self.touchBottomBound) {
        self.speedY=fabsf(self.speedY)*ZZRandom_0_1()*defaultReboundRate;
        self.speedX=defaultPointerSpeed*ZZRandom_1_0_1()*defaultReboundRate;
    }
    if (self.touchLeftBound) {
        self.speedX=fabsf(self.speedX)*ZZRandom_0_1()*defaultReboundRate;
        self.speedY=defaultPointerSpeed*ZZRandom_1_0_1()*defaultReboundRate;
    }
    if (self.touchRightBound) {
        self.speedX=-fabsf(self.speedX)*ZZRandom_0_1()*defaultReboundRate;
        self.speedY=defaultPointerSpeed*ZZRandom_1_0_1()*defaultReboundRate;
    }
    
    
    
    if (self.groupType==DotGroupTypeNothing||self.groupType==DotGroupTypeSurround) {
        CGFloat dx=node.position.x-self.position.x;
        CGFloat dy=node.position.y-self.position.y;
        CGFloat rad=atan2f(dx, dy);
        CGFloat newDx=self.followSpeed*sin(rad);
        CGFloat newDy=self.followSpeed*cos(rad);
        self.position=CGPointMake(self.position.x+newDx, self.position.y+newDy);
    }
    else if(self.groupType==DotGroupTypePointer)
    {
        CGPoint deltaOrigin=[self rotateVector:self.originPoint rotation:self.zRotation];
        CGPoint realOrigin=CGPointMake(deltaOrigin.x+self.position.x, deltaOrigin.y+self.position.y);
        CGFloat dx=node.position.x-realOrigin.x;
        CGFloat dy=node.position.y-realOrigin.y;
        CGFloat rad=-atan2f(dx, dy);
        self.zRotation=rad;
        
        if(self.touchBottomBound||self.touchLeftBound||self.touchRightBound||self.touchTopBound)
        {
            self.groupType=DotGroupTypeNothing;
        }
    }
}

-(void)setZRotation:(CGFloat)zRotation
{
    if (self.groupType==DotGroupTypePointer) {
        CGPoint deltaOrigin=[self rotateVector:self.originPoint rotation:self.zRotation];
        CGPoint realOrigin=CGPointMake(deltaOrigin.x+self.position.x, deltaOrigin.y+self.position.y);
        
        CGPoint dotsRotatedPosition=[self rotatePoint:self.position origin:realOrigin rotation:(zRotation-self.zRotation)];
        self.position=dotsRotatedPosition;
        
//        ZZSpriteNode* originNode=[ZZSpriteNode spriteNodeWithColor:[SKColor cyanColor] size:CGSizeMake(2, 2)];
//        originNode.position=realOrigin;
//        originNode.zPosition=Arrow_Z_Position;
//        [self.parent addChild:originNode];
//        [originNode runAction:[SKAction fadeAlphaTo:0.1 duration:0.1] completion:^{
//            [originNode removeFromParent];
//        }];
    }
    
    [super setZRotation:zRotation];
}

-(CGPoint)originPoint
{
    if (self.groupType==DotGroupTypePointer) {
        return _originPoint;
    }
    else
    {
        return self.position;
    }
}

-(void)setGroupType:(DotGroupType)groupType
{
    _groupType=groupType;
    self.originPoint=CGPointZero;
    self.zRotation=0;
}

-(void)beKilledByWeapon:(WeaponNode *)weapon
{
    [self removeAllActions];
    _isDead=YES;
    if ([weapon isKindOfClass:[MegaBombNode class]])
    {
        ZZSpriteNode* burn=[ZZSpriteNode spriteNodeWithTexture:[MyTextureAtlas textureNamed:@"burnup1"]];
        burn.alpha=0.6;
        burn.position=self.position;
        [self.parent addChild:burn];
        NSArray* burnTextures=[MyTextureAtlas burnUpTextures];
        CFTimeInterval timePer=0.02;
        CGFloat dx=burn.position.x-weapon.position.x;
        CGFloat dy=burn.position.y-weapon.position.y;
        CGFloat rad=atan2f(dx, dy);
        CGFloat distance=10;
        CGFloat vx=distance*sin(rad);
        CGFloat vy=distance*cos(rad);
        [burn runAction:[SKAction group:[NSArray arrayWithObjects:[SKAction animateWithTextures:burnTextures timePerFrame:timePer],[SKAction moveBy:CGVectorMake(vx, vy) duration:burnTextures.count*timePer],nil]] completion:^{
            [burn removeFromParent];
        }];
    }
    else if([weapon isKindOfClass:[RailGunNode class]])
    {
        ZZSpriteNode* ball=[ZZSpriteNode spriteNodeWithTexture:[MyTextureAtlas textureNamed:@"purpleBall"]];
        ball.position=self.position;
        [self.parent addChild:ball];
        [ball runAction:[SKAction scaleTo:0 duration:0.5] completion:^{
            [ball removeFromParent];
        }];
    }
    else if([weapon isKindOfClass:[MissileTrackNode class]])
    {
        ZZSpriteNode* ball=[ZZSpriteNode spriteNodeWithTexture:[MyTextureAtlas textureNamed:@"yellowBall"]];
        ball.position=self.position;
        [self.parent addChild:ball];
        [ball runAction:[SKAction scaleTo:0 duration:0.5] completion:^{
            [ball removeFromParent];
        }];
    }
    [self removeFromParent];
}

-(BOOL)intersectsNode:(SKNode *)node
{
    if (_isDead||!_isAwake) {
        return NO;
    }
    return [super intersectsNode:node];
}

-(void)removeFromParent
{
    [super removeFromParent];
}

@end

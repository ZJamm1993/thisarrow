//
//  GameScene.m
//  thisarrow
//
//  Created by jam on 16/12/12.
//  Copyright (c) 2016年 jamstudio. All rights reserved.
//

#import "GameScene.h"
#import "ArrowNode.h"
#import "PickUpNode.h"
#import "WeaponNode.h"
#import "DotNode.h"

const CFTimeInterval frequentPickUp=0.25;
const CFTimeInterval frequentDot=0.1;
const CFTimeInterval frequentDotGroup=5;
const CFTimeInterval pickUpLifeTime=60;
const NSInteger dotIncreasingCount=1;
const NSInteger maxPickUpCount=3;
const NSInteger maxDotCount=200;
//const CGFloat safeZoneRadius=32;

@interface GameScene()
@end

@implementation GameScene
{
    CMMotionManager* _motionManager;
    ArrowNode* arrow;
    ZZSpriteNode* bgNode;
    CFTimeInterval pickUpTimeInterval;
    CFTimeInterval dotTimeInterval;
    CFTimeInterval dotGroupTimeTnterval;
    NSInteger currentMaxDotCount;
}

-(void)didMoveToView:(SKView *)view {
    
    currentMaxDotCount=1;
    
    self.backgroundColor=[SKColor colorWithWhite:0.4 alpha:1];
    
    CGPoint centerPoint=CGPointMake(self.size.width/2, self.size.height/2);
    
    CGFloat mx=5;
    CGFloat my=25;
    
    bgNode=[ZZSpriteNode spriteNodeWithColor:[SKColor clearColor] size:CGSizeMake(self.size.width-2*mx, self.size.height-2*my)];
    bgNode.position=CGPointMake(mx, my);
    bgNode.zPosition=Background_Z_Position;
    [super addChild:bgNode];
    //
    SKTexture* roundCornerRect=[MyTextureAtlas textureNamed:@"roundCornerRect"];
    ZZSpriteNode* bgRect=[ZZSpriteNode spriteNodeWithTexture:roundCornerRect];
    bgRect.centerRect=CGRectMake(0.45, 0.45, 0.1,0.1);
    bgRect.xScale=bgNode.size.width/bgRect.size.width;
    bgRect.yScale=bgNode.size.height/bgRect.size.height;
    bgRect.position=CGPointMake(bgNode.size.width/2, bgNode.size.height/2);
    bgRect.zPosition=Background_Z_Position;
    [bgNode addChild:bgRect];
    
    arrow=[ArrowNode defaultNode];
    arrow.position=centerPoint;
    arrow.zPosition=Arrow_Z_Position;
    [self addChild:arrow];
    
    _motionManager=[[CMMotionManager alloc]init];
    [_motionManager startAccelerometerUpdates];
    [_motionManager setAccelerometerUpdateInterval:1/60.0];
}

-(void)addChild:(SKNode *)node
{
    [bgNode addChild:node];
}

-(NSArray*)children
{
    return bgNode.children;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesMoved:touches withEvent:event];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(![_motionManager isAccelerometerAvailable])
    {
        UITouch* touch=[touches anyObject];
        CGPoint p=[touch locationInNode:bgNode];
        [arrow actionWithPoint:p];
    }
    else
    {
        self.paused=!self.paused;
    }
}

-(void)addPickUpWithPickUps:(NSArray*)picks
{
    int sepNum=3;
    CGFloat sep=bgNode.size.width/sepNum;
    PickUpNode* pick=[PickUpNode randomNode];
    pick.createTime=pickUpTimeInterval+ZZRandom_0_1()*5;
    CGFloat r=pick.size.width/2;
    CGFloat x=(arc4random()%(int)(sep-2*r));
    CGFloat y=(arc4random()%(int)(bgNode.size.height-2*r));
    
//    num=num+(rand()%2==0?-1:1);
//    if (num>=sepNum) {
//        num=0;
//    }
//    else if(num<0)
//    {
//        num=sepNum-1;
//    }
//    x=x+num*sep;
    
    BOOL le=NO;
    BOOL ri=NO;
    BOOL mi=NO;
    
    for (SKNode* nod in picks) {
        CGFloat px=nod.position.x;
        if (px<=sep) {
            le=YES;
        }
        else if(px>=2*sep)
        {
            ri=YES;
        }
        else
        {
            mi=YES;
        }
    }
    
    int num=0;
    if (!mi) {
        num=1;
    }
    else if(!le)
    {
        num=0;
    }
    else if(!ri)
    {
        num=2;
    }
    x=x+num*sep;
    
    CGPoint p=CGPointMake(r+x, r+y);
    pick.position=p;
    [self addChild:pick];}

-(void)addDot
{
    DotNode* dot=[DotNode randomPositionNodeOnSize:bgNode.size];
    [self addChild:dot];
    [dot wakeUp];
}

-(void)addRandomGroupingDots:(NSArray*)dots
{
    NSArray* newGroupingDots=[DotNode randomGroupNodeWithDots:dots target:arrow];
    for (SKNode* nod in newGroupingDots) {
        [self addChild:nod];
    }
}

-(void)update:(CFTimeInterval)currentTime {
//    
//    CGFloat ran=ZZRandom_1_0_1();
//    NSLog(@"ran:%f",ran);
//    if (ran>1||ran<-1) {
//        NSLog(@"ran wrong");
//    }
//
    
    if (self.paused) {
        return;
    }
    
    if ([_motionManager isAccelerometerAvailable]) {
        [arrow actionWithAcceleration:_motionManager.accelerometerData.acceleration];
    }
    
    NSArray* children=[NSArray arrayWithArray:self.children];
    NSMutableArray* pickUps=[NSMutableArray array];
    NSMutableArray* dots=[NSMutableArray array];
    NSMutableArray* weapons=[NSMutableArray array];
    
    for (SKNode* node in children) {
        if ([node isKindOfClass:[PickUpNode class]]) {
            [pickUps addObject:node];
        }
        else if([node isKindOfClass:[WeaponNode class]]) {
            [weapons addObject:node];
        }
        else if([node isKindOfClass:[DotNode class]]) {
            [dots addObject:node];
        }
    }
    
    //add something if need
    
    if (currentTime-pickUpTimeInterval>=frequentPickUp) {
        pickUpTimeInterval=currentTime;
        if (pickUps.count<maxPickUpCount) {
            [self addPickUpWithPickUps:pickUps];
        }
    }
    
    if (currentTime-dotTimeInterval>=frequentDot) {
        dotTimeInterval=currentTime;
        if (dots.count<currentMaxDotCount) {
            [self addDot];
        }
    }
    
    if (dotGroupTimeTnterval==0) {
        dotGroupTimeTnterval=currentTime;
    }
    
    if (currentTime-dotGroupTimeTnterval>=frequentDotGroup)
    {
        dotGroupTimeTnterval=currentTime;
        if (currentMaxDotCount<maxDotCount) {
            currentMaxDotCount+=dotIncreasingCount;
        }
        if (dots.count<maxDotCount) {
            [self addRandomGroupingDots:dots];
        }
    }
    
    for (PickUpNode * pic in pickUps) {
        [pic movingAround];
        if (pic.type==PickUpTypePurple) {
            [pic runAction:[SKAction rotateToAngle:-arrow.zRotation+M_PI_2 duration:0.1 shortestUnitArc:YES]];
        }
        if ([arrow intersectsNode:pic]) {
            [pic bePickedUpByNode:arrow];
            continue;
        }
        if (currentTime-pic.createTime>=pickUpLifeTime) {
            [pic disappear];
            continue;
        }
    }
    
    for (DotNode* dot in dots) {
        [dot actionWithTarget:arrow];
    }
    
    for (WeaponNode* wea in weapons) {
        [wea actionWithTargets:dots];
        for (DotNode* dot in dots) {
            if ([wea intersectsNode:dot]) {
                [dot beKilledByWeapon:wea];
            }
        }
    }
}

@end

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
#import "DotNode+Grouping.h"

const CFTimeInterval frequentPickUp=0.25;
const CFTimeInterval frequentDot=1;
const CFTimeInterval frequentDotGroup=10;
const NSInteger dotIncreasingCount=1;
const NSInteger maxPickUpCount=3;
const NSInteger maxDotCount=100;

@interface GameScene()
@end

@implementation GameScene
{
    CMMotionManager* _motionManager;
    NSNumberFormatter* formatter;
    ArrowNode* arrow;
    ZZSpriteNode* bgNode;
    SKLabelNode* scoreLabel;
    CFTimeInterval pickUpTimeInterval;
    CFTimeInterval dotTimeInterval;
    CFTimeInterval dotGroupTimeTnterval;
    NSInteger currentMaxDotCount;
    BOOL gameOver;
    NSInteger killedDotsCount;
    CMAcceleration originAcceleration;
}

-(void)didMoveToView:(SKView *)view {
    
    currentMaxDotCount=30;
    
    self.size=view.frame.size;
    
    self.backgroundColor=[SKColor colorWithRed:0.5 green:0 blue:0 alpha:1];
    
    CGPoint centerPoint=CGPointMake(self.size.width/2, self.size.height/2);
    
    CGFloat mx=5;
    CGFloat WHRate=self.size.width/self.size.height;
    if (WHRate>480.0/320.0) {
        CGFloat ww=self.size.height/320*480;
        mx=(self.size.width-ww)/2+mx;
    }
    CGFloat my=25;
    
    bgNode=[ZZSpriteNode spriteNodeWithColor:[SKColor clearColor] size:CGSizeMake(self.size.width-2*mx, self.size.height-2*my)];
    bgNode.position=CGPointMake(mx, my);
    bgNode.zPosition=Background_Z_Position;
    [super addChild:bgNode];
    
    formatter=[[NSNumberFormatter alloc]init];
    formatter.numberStyle=NSNumberFormatterDecimalStyle;
    
    scoreLabel=[SKLabelNode labelNodeWithFontNamed:@"Menlo"];
//    scoreLabel.horizontalAlignmentMode=SKLabelHorizontalAlignmentModeLeft;
    scoreLabel.position=CGPointMake(self.size.width/2, self.size.height-my);
    scoreLabel.fontColor=[SKColor whiteColor];
    scoreLabel.fontSize=14;
    [super addChild:scoreLabel];
    
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
    
    if ([_motionManager isAccelerometerAvailable]) {
//        [arrow actionWithAcceleration:_motionManager.accelerometerData.acceleration];
        originAcceleration=_motionManager.accelerometerData.acceleration;
    }
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
//    int sepNum=3;
//    CGFloat sep=bgNode.size.width/sepNum;
    PickUpNode* pick=[PickUpNode randomNode];
    pick.createTime=pickUpTimeInterval+ZZRandom_0_1()*5;
    CGFloat r=pick.size.width/2;
    CGFloat x=(arc4random()%(int)(bgNode.size.width-2*r));
    CGFloat y=(arc4random()%(int)(bgNode.size.height-2*r));
    
////    num=num+(rand()%2==0?-1:1);
////    if (num>=sepNum) {
////        num=0;
////    }
////    else if(num<0)
////    {
////        num=sepNum-1;
////    }
////    x=x+num*sep;
//    
//    BOOL le=NO;
//    BOOL ri=NO;
//    BOOL mi=NO;
//    
//    for (SKNode* nod in picks) {
//        CGFloat px=nod.position.x;
//        if (px<=sep) {
//            le=YES;
//        }
//        else if(px>=2*sep)
//        {
//            ri=YES;
//        }
//        else
//        {
//            mi=YES;
//        }
//    }
//    
//    int num=0;
//    if (!mi) {
//        num=1;
//    }
//    else if(!le)
//    {
//        num=0;
//    }
//    else if(!ri)
//    {
//        num=2;
//    }
//    x=x+num*sep;
    
    CGPoint p=CGPointMake(r+x, r+y);
    pick.position=p;
    [self addChild:pick];}

-(void)addDot
{
    DotNode* dot=[DotNode randomPositionNodeOnSize:bgNode.size];
//    dot.position=arrow.position;
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

-(void)gameIsOver
{
    gameOver=YES;
    ZZSpriteNode* smashedArrow=[ZZSpriteNode spriteNodeWithTexture:[MyTextureAtlas textureNamed:@"arrowSmashed"]];
    smashedArrow.xScale=0.0;
    smashedArrow.yScale=smashedArrow.xScale;
    smashedArrow.position=arrow.position;
    smashedArrow.zPosition=Arrow_Z_Position;
    
    NSArray* children=[NSArray arrayWithArray:self.children];
    for (SKNode* chil in children) {
        [chil removeAllActions];
        if ([chil isKindOfClass:[DotNode class]]) {
            [(DotNode*)chil bleeding];
            [chil removeFromParent];
        }
    }
    
    [self addChild:smashedArrow];
    
    SKAction* scale=[SKAction scaleTo:1 duration:0.25];
    scale.timingMode=SKActionTimingEaseOut;
    
    [smashedArrow runAction:[SKAction sequence:[NSArray arrayWithObjects:
//                                                [SKAction waitForDuration:0.7],
                                                [SKAction performSelector:@selector(removeFromParent) onTarget:arrow],
                                                scale
                                                , nil]] completion:^{
        [self performSelector:@selector(restartGame) withObject:nil afterDelay:1];
    }];
}

-(void)restartGame
{
    GameScene *scene = [GameScene sceneWithSize:self.view.frame.size];
    scene.scaleMode = SKSceneScaleModeResizeFill;
    [self.view presentScene:scene];
}

-(void)update:(CFTimeInterval)currentTime {

    if (self.paused||gameOver) {
        return;
    }
    
    if ([_motionManager isAccelerometerAvailable]) {
        CMAcceleration thisAcc=_motionManager.accelerometerData.acceleration;
        thisAcc.x=thisAcc.x-originAcceleration.x;
        thisAcc.y=thisAcc.y-originAcceleration.y;
        thisAcc.z=thisAcc.z-originAcceleration.z;
        [arrow actionWithAcceleration:thisAcc];
    }
    
    NSArray* children=[NSArray arrayWithArray:self.children];
    NSMutableArray* pickUps=[NSMutableArray array];
    NSMutableArray* dots=[NSMutableArray array];
    NSMutableArray* nothingDots=[NSMutableArray array];
    NSMutableArray* weapons=[NSMutableArray arrayWithObject:arrow];
    
    for (SKNode* node in children) {
        if ([node isKindOfClass:[PickUpNode class]]) {
            [pickUps addObject:node];
        }
        else if([node isKindOfClass:[WeaponNode class]]) {
            [weapons addObject:node];
        }
        else if([node isKindOfClass:[DotNode class]]) {
            [dots addObject:node];
            DotNode* dot=(DotNode*)node;
            if (dot.groupType==DotGroupTypeNothing) {
                [nothingDots addObject:dot];
            }
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
        if (nothingDots.count<currentMaxDotCount) {
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
        if (dots.count<currentMaxDotCount) {
            [self addRandomGroupingDots:dots];
        }
    }
    
    [arrow actionWithWeapons:weapons];
    
    for (PickUpNode * pic in pickUps) {
        [pic movingAround];
        [pic actionWithTimeInterval:currentTime];
        if (pic.type==PickUpTypePurple||pic.type==PickUpTypeGreen) {
            [pic runAction:[SKAction rotateToAngle:-arrow.zRotation+M_PI_2 duration:0.1 shortestUnitArc:YES]];
        }
        if ([arrow intersectsNode:pic]) {
            [pic bePickedUpByNode:arrow];
        }
    }
    
    for (WeaponNode* wea in weapons) {
        [wea actionWithTargets:dots];
        [wea actionWithHero:arrow];
        [wea actionWithTimeInterval:currentTime];
        NSArray* readDots=[NSArray arrayWithArray:dots];
        for (DotNode* dot in readDots) {
            if ([wea intersectsNode:dot]) {
                
                [dot beKilledByWeapon:wea];
                if (dot.isDead) {
                    [dots removeObject:dot];
                    killedDotsCount++;
                }
            }
        }
    }
    
    for (DotNode* dot in dots) {
        [dot actionWithTarget:arrow];
        if ([dot intersectsNode:arrow]) {
            [self gameIsOver];
            return;
        }
    }
    
    scoreLabel.text=[NSString stringWithFormat:@"killed dots: %@",[formatter stringFromNumber:[NSNumber numberWithInteger:killedDotsCount]]];
}

@end

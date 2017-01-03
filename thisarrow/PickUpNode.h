//
//  PickUpNode.h
//  thisarrow
//
//  Created by jam on 16/12/19.
//  Copyright © 2016年 jamstudio. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef NS_ENUM(NSInteger,PickUpType){
    PickUpTypeOrange,
    PickUpTypePurple,
    PickUpTypeYellow,
    PickUpTypeGreen,
    PickUpTypeNothing
};

@interface PickUpNode : ZZSpriteNode

@property (nonatomic,assign) BOOL shouldMoving;
@property (nonatomic,assign) PickUpType type;
@property (nonatomic,assign) CFTimeInterval createTime;
@property (nonatomic,assign) BOOL disappearing;

+(instancetype)randomNode;

-(void)movingAround;
-(void)disappear;

-(void)bePickedUpByNode:(SKNode*)node;

@end

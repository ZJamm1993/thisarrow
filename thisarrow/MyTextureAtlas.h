//
//  MyTextureAtlas.h
//  thisarrow
//
//  Created by iMac206 on 16/12/13.
//  Copyright © 2016年 jamstudio. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MyTextureAtlas : SKTextureAtlas

+(instancetype)sharedTextureAtlas;

+(NSDictionary*)sharedTextureDictionary;

+(SKTexture*)textureNamed:(NSString*)name;

+(NSArray*)burnUpTextures;

+(NSArray*)bloodWhiteTextures;

+(NSArray*)bloodRedTextures;

@end

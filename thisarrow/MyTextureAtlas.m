//
//  MyTextureAtlas.m
//  thisarrow
//
//  Created by iMac206 on 16/12/13.
//  Copyright © 2016年 jamstudio. All rights reserved.
//

#import "MyTextureAtlas.h"

static NSArray* burnUpTextureArray;

static MyTextureAtlas* sharedTextureAtlasInstancetype;

@implementation MyTextureAtlas

+(instancetype)sharedTextureAtlas
{
    if (sharedTextureAtlasInstancetype==nil) {
        sharedTextureAtlasInstancetype=[MyTextureAtlas atlasNamed:@"texture.atlas"];
    }
    return sharedTextureAtlasInstancetype;
}

+(SKTexture*)textureNamed:(NSString *)name
{
    SKTexture* texture=[[MyTextureAtlas sharedTextureAtlas]textureNamed:name];
    return texture;
}

+(NSArray*)burnUpTextures
{
    if (burnUpTextureArray==nil) {
        NSMutableArray* textures=[NSMutableArray array];
        for (int i=1; i<=20; i++) {
            NSString* name=[NSString stringWithFormat:@"burnup%d",i];
            SKTexture* text=[MyTextureAtlas textureNamed:name];
            [textures addObject:text];
        }
        burnUpTextureArray=[NSArray arrayWithArray:textures];
    }
    return burnUpTextureArray;
}

@end

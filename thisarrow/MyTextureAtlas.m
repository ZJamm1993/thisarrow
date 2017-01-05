//
//  MyTextureAtlas.m
//  thisarrow
//
//  Created by iMac206 on 16/12/13.
//  Copyright © 2016年 jamstudio. All rights reserved.
//

#import "MyTextureAtlas.h"

static NSArray* burnUpTextureArray;
static NSArray* bloodWhiteTextureArray;
static NSArray* bloodRedTextureArray;
static NSDictionary* textureDictionary;
static MyTextureAtlas* sharedTextureAtlasInstancetype;

@implementation MyTextureAtlas

+(instancetype)sharedTextureAtlas
{
    if (sharedTextureAtlasInstancetype==nil) {
        sharedTextureAtlasInstancetype=[MyTextureAtlas atlasNamed:@"texture.atlas"];
    }
    return sharedTextureAtlasInstancetype;
}

+(NSDictionary*)sharedTextureDictionary
{
    if (textureDictionary==nil) {
        NSMutableDictionary* dict=[NSMutableDictionary dictionary];
        NSArray* names=[MyTextureAtlas sharedTextureAtlas].textureNames;
        for (NSString* na in names) {
            NSArray* compos=[na componentsSeparatedByString:@"@"];
            SKTexture* texture=[[MyTextureAtlas sharedTextureAtlas]textureNamed:na];
            [dict setValue:texture forKey:[compos firstObject]];
        }
        textureDictionary=[NSDictionary dictionaryWithDictionary:dict];
    }
    return textureDictionary;
}

+(SKTexture*)textureNamed:(NSString *)name
{
    SKTexture* texture=[[MyTextureAtlas sharedTextureDictionary]valueForKey:name];
    //[[MyTextureAtlas sharedTextureAtlas]textureNamed:name];
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

+(NSArray*)bloodRedTextures
{
    if (bloodRedTextureArray==nil) {
        NSMutableArray* textures=[NSMutableArray array];
        for (int i=1; i<=15; i++) {
            NSString* name=[NSString stringWithFormat:@"bloodRed%d",i];
            SKTexture* text=[MyTextureAtlas textureNamed:name];
            [textures addObject:text];
        }
        bloodRedTextureArray=[NSArray arrayWithArray:textures];
    }
    return bloodRedTextureArray;
}

+(NSArray*)bloodWhiteTextures
{
    if (bloodWhiteTextureArray==nil) {
        NSMutableArray* textures=[NSMutableArray array];
        for (int i=1; i<=15; i++) {
            NSString* name=[NSString stringWithFormat:@"bloodWhite%d",i];
            SKTexture* text=[MyTextureAtlas textureNamed:name];
            [textures addObject:text];
        }
        bloodWhiteTextureArray=[NSArray arrayWithArray:textures];
    }
    return bloodWhiteTextureArray;
}

@end

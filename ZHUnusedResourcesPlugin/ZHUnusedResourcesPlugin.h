//
//  ZHUnusedResourcesPlugin.h
//  ZHUnusedResourcesPlugin
//
//  Created by taffy on 15/11/6.
//  Copyright © 2015年 taffy. All rights reserved.
//

#import <AppKit/AppKit.h>

@class ZHUnusedResourcesPlugin;

static ZHUnusedResourcesPlugin *sharedPlugin;

@interface ZHUnusedResourcesPlugin : NSObject

+ (instancetype)sharedPlugin;
- (id)initWithBundle:(NSBundle *)plugin;

@property (nonatomic, strong, readonly) NSBundle* bundle;
@end
//
//  ZHUnusedResourcesPlugin.m
//  ZHUnusedResourcesPlugin
//
//  Created by taffy on 15/11/6.
//  Copyright © 2015年 taffy. All rights reserved.
//

#import "ZHUnusedResourcesPlugin.h"
#import "FilesManager.h"
#import "PrivateAPI.h"

@interface ZHUnusedResourcesPlugin()

@property (nonatomic, strong, readwrite) NSBundle *bundle;
@end

@implementation ZHUnusedResourcesPlugin

+ (instancetype)sharedPlugin {
    return sharedPlugin;
}

- (id)initWithBundle:(NSBundle *)plugin {
  if (self = [super init]) {
    // reference to plugin's bundle, for resource access
    self.bundle = plugin;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didApplicationFinishLaunchingNotification:)
                                                 name:NSApplicationDidFinishLaunchingNotification
                                               object:nil];
  }
  return self;
}

- (void)didApplicationFinishLaunchingNotification:(NSNotification*)noti {
  //removeObserver
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:NSApplicationDidFinishLaunchingNotification
                                                object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(IDEWorkspaceBuildProductsLocationDidChange:)
                                               name:@"IDEWorkspaceBuildProductsLocationDidChangeNotification"
                                             object:nil];
}

- (void) IDEWorkspaceBuildProductsLocationDidChange: (NSNotification *)notity {
 
  if ([notity.object isKindOfClass:[IDEWorkspace class]]) {
    IDEWorkspace *workspace = notity.object;
    DVTFilePath *filePath = [workspace _wrappingContainerPath];
    
//    NSLog(@"%@", [filePath fileName]);
//    NSLog(@"%@", [filePath pathString]);
    
    NSString *dir = [[filePath pathString] stringByReplacingOccurrencesOfString:
                     [NSString stringWithFormat:@"/%@", [filePath fileName]] withString:@""];
    
    if (!dir || [dir isEqualToString:@""]) {
      return;
    }
    
    [[FilesManager sharedObject] startWithProjectPath:dir fileSuffixs:@".m;.mm;.swift;.plist;.xib;.storyboard"];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"IDEWorkspaceBuildProductsLocationDidChangeNotification"
                                                  object:nil];
  }
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

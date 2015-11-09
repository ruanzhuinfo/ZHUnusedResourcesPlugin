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
                                             selector:@selector(IDEWorkspaceBuildProductsLocationDidChange:)
                                                 name:@"IDEWorkspaceBuildProductsLocationDidChangeNotification"
                                               object:nil];
  }
  return self;
}

- (void) IDEWorkspaceBuildProductsLocationDidChange: (NSNotification *)notity {
 
  if ([notity.object isKindOfClass:[IDEWorkspace class]]) {
    
    IDEWorkspace *workspace = notity.object;
    DVTFilePath *filePath = [workspace _wrappingContainerPath];
    
    if ([[filePath fileName] isEqualToString:@"ZHUnusedResourcesPlugin.xcodeproj"] ||
        ![filePath fileName] ||
        [[filePath fileName] isEqualToString:@""]) {
      return;
    }
    
    NSString *dir = [[filePath pathString] stringByReplacingOccurrencesOfString:
                     [NSString stringWithFormat:@"/%@", [filePath fileName]] withString:@""];
    
    if (!dir || [dir isEqualToString:@""]) {
      return;
    }
    
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"IDEWorkspaceBuildProductsLocationDidChangeNotification"
                                                  object:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      [[FilesManager sharedObject] startWithProjectPath:dir fileSuffixs:@".m;.mm;.swift;.plist;.xib;.storyboard"];
    });
  }
  
}

- (void)addLog:(NSString *)str {
  for (NSWindow *window in [NSApp windows]) {
    NSView *contentView = window.contentView;
    IDEConsoleTextView *console = [self consoleViewInMainView:contentView];
    console.logMode = 1;
    [console insertText:str];
    [console insertNewline:@""];
    [console _scrollToBottom];
  }
}

- (IDEConsoleTextView *)consoleViewInMainView:(NSView *)mainView {
  for (NSView *childView in mainView.subviews) {
    if ([childView isKindOfClass:NSClassFromString(@"IDEConsoleTextView")]) {
      return (IDEConsoleTextView *)childView;
    } else {
      NSView *v = [self consoleViewInMainView:childView];
      if ([v isKindOfClass:NSClassFromString(@"IDEConsoleTextView")]) {
        return (IDEConsoleTextView *)v;
      }
    }
  }
  return nil;
}




- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

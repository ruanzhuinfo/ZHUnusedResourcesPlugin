//
//  IDEEditorContext+Plugin.m
//  ZHUnusedResourcesPlugin
//
//  Created by taffy on 15/11/6.
//  Copyright © 2015年 taffy. All rights reserved.
//

#import "IDEEditorContext+Plugin.h"
#import "MethodSwizzle.h"
#import "FilesManager.h"

@implementation IDEEditorContext (Plugin)

+ (void)load {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    MethodSwizzle(self,
                  @selector(_openNavigableItem:documentExtension:document:shouldInstallEditorBlock:),
                  @selector(zh__openNavigableItem:documentExtension:document:shouldInstallEditorBlock:));
  });
}

/**
 *  点击左边栏中 item 出发的事件
 *
 *  @param arg1 <IDEFileReferenceNavigableItem 0x6080003448e0: (supports Any IDEFileReference, represents: <Xcode3FileReference, 0x6000001aad40 (Represents: <PBXFileReference:0x608000184440:0499D90A1BB14A91009345FE:name='DynamicAnimationViewController.h'>)>)>
 *  @param arg2 <DVTExtension 0x6000008aaec0: Source Code Document (Xcode.IDEKit.EditorDocument.SourceCode) v0.2 from com.apple.dt.IDE.IDESourceEditor>
 *  @param arg3 <IDESourceCodeDocument: 0x104d6b550> URL: file:///Users/taffy/Project/Mobile/Demos/Demos/UIKit%20Dynamic%20demo/DynamicAnimationViewController.h
 *  @param arg4 <__NSMallocBlock__: 0x600001445e50>
 *
 *  @return int
 */
- (int)zh__openNavigableItem:(id)arg1 documentExtension:(id)arg2 document:(id)arg3 shouldInstallEditorBlock:(id)arg4 {
  
  IDEFileReferenceNavigableItem *item = arg1;
//  NSLog(@"%@",[item name]);
  
  if (![[FilesManager sharedObject] isUsedAtResourceName:[item name]]) {
    NSString *log = [NSString stringWithFormat:@"%@ unuse!!!",[item name]];
    [self addLog:log];
  }
  
  int i =[self zh__openNavigableItem:arg1 documentExtension:arg2 document:arg3 shouldInstallEditorBlock:arg4];
  return i;
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

@end

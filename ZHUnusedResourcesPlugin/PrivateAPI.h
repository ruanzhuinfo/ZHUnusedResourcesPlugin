//
//  PrivateAPI.h
//  ZHUnusedResourcesPlugin
//
//  Created by taffy on 15/11/6.
//  Copyright © 2015年 taffy. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface DVTViewController : NSViewController
@end

@interface IDEViewController : DVTViewController
@end

@interface IDENavigableItem : NSObject
@end

@interface IDEFileNavigableItem : IDENavigableItem
@end

@interface DVTCompletingTextView : NSObject
@end

@interface DVTOutlineView : NSOutlineView
@end
@interface IDENavigator : IDEViewController
@end

@interface DVTModelObject : NSObject
@end
@interface IDEContainer : DVTModelObject
@end
@interface IDEXMLPackageContainer : IDEContainer
@end


@interface IDEEditorContext : IDEViewController
- (int)_openNavigableItem:(id)arg1 documentExtension:(id)arg2 document:(id)arg3 shouldInstallEditorBlock:(id)arg4;
@end

@interface IDEFileReferenceNavigableItem : IDEFileNavigableItem

- (id)newImage;
- (id)name;
- (id)documentType;
- (id)fileURL;
- (void)updateAttributes;
- (NSColor *)textColor;
@end

@interface IDEConsoleTextView : DVTCompletingTextView

@property(nonatomic) int logMode; // @synthesize logMode=_logMode;

- (void)insertText:(id)arg1;
- (void)insertNewline:(id)arg1;
- (void)_appendConsoleItem:(id)arg1;
- (void)_scrollToBottom;
@end

@interface IDEOutlineBasedNavigator : IDENavigator
- (void)openClickedNavigableItemAction:(id)arg1;
@end

@interface IDENavigatorOutlineView : DVTOutlineView
- (void)mouseDown:(id)arg1;
- (void)highlightSelectionInClipRect:(struct CGRect)arg1;
- (void)_setNeedsDisplayInSelectedRows;
- (void)expandItem:(id)arg1;
- (void)expandItem:(id)arg1 expandChildren:(BOOL)arg2;
- (BOOL)sendAction:(SEL)arg1 to:(id)arg2;
- (void)collapseItem:(id)arg1;
- (void)collapseItem:(id)arg1 collapseChildren:(BOOL)arg2;
@end

@interface DVTFilePath : NSObject

- (NSString *)fileName;
- (NSString *)pathString;
@end


@interface IDEWorkspace : IDEXMLPackageContainer
- (id)_wrappingContainerPath;
@end



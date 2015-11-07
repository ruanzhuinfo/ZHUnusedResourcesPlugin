//
//  StringUtils.m
//  LSUnusedResources
//
//  Created by lslin on 15/9/1.
//  Copyright (c) 2015年 lessfun.com. All rights reserved.
//

#import "StringUtils.h"

static NSString * const kSuffix2x = @"@2x";
static NSString * const kSuffix3x = @"@3x";

static NSString * const kMethodNameCustom = @"GET_IMAGE";
static NSString * const kMethodNameSystem = @"imageNamed";

@implementation StringUtils

+ (NSString *)stringByRemoveResourceSuffix:(NSString *)str {
    NSString *suffix = [str pathExtension];
    return [self stringByRemoveResourceSuffix:str suffix:suffix];
}

+ (NSString *)getNameFormString: (NSString *)str {
  
  if ([str hasPrefix:kMethodNameCustom]) {
    NSArray *strs = [str componentsSeparatedByString:@"("];
    for (NSString *s in strs) {
      if ([s hasSuffix:@")"]) {
        return [s substringToIndex:s.length -1];
      }
    }
  }
  
  if ([str hasPrefix:kMethodNameSystem]) {
    NSArray *strs = [str componentsSeparatedByString:@"\""];
    for (NSString *s in strs) {
      if (![s hasPrefix:kMethodNameSystem]) {
        return s;
      }
    }
  }
  
  return nil;
}

+ (NSString *) getNameFromFullName: (NSString *)fullName {
  if ([StringUtils isImageTypeWithName:fullName]) {
    return [StringUtils stringByRemoveResourceSuffix:fullName];
  }
  
  return nil;
}

+ (NSString *)stringByRemoveResourceSuffix:(NSString *)str suffix:(NSString *)suffix {
    NSString *keyName = str;
    
    if (suffix.length && [keyName hasSuffix:suffix]) {
        keyName = [keyName stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@".%@", suffix] withString:@""];
    }
    if ([keyName hasSuffix:kSuffix2x]) {
        keyName = [keyName stringByReplacingOccurrencesOfString:kSuffix2x withString:@""];
    } else if ([keyName hasSuffix:kSuffix3x]) {
        keyName = [keyName stringByReplacingOccurrencesOfString:kSuffix3x withString:@""];
    }
    return keyName;
}

+ (BOOL)isImageTypeWithName:(NSString *)name {
    static NSArray *arr = nil;
    arr = @[@"png", @"jpg", @"jpeg", @"gif", @"bmp"];
    NSString *ext = [[name pathExtension] lowercaseString];
    if ([arr containsObject:ext]) {
        return YES;
    }
    return NO;
}

+ (NSArray *)fileSuffixs: (NSString *)suffixs {
  if (!suffixs || [suffixs isEqualToString:@""]) {
    return [NSArray array];
  }
  suffixs = [suffixs lowercaseString];
  suffixs = [suffixs stringByReplacingOccurrencesOfString:@" " withString:@""];
  suffixs = [suffixs stringByReplacingOccurrencesOfString:@"." withString:@""];
  return [suffixs componentsSeparatedByString:@";"];
}


@end

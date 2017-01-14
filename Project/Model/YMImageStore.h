//
//  YMImageStore.h
//  Homepwner
//
//  Created by Lym on 2017/1/2.
//  Copyright © 2017年 Lym. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UIImage;

@interface YMImageStore : NSObject

+ (instancetype)sharedStore;

- (void)setImage:(UIImage *)image forKey:(NSString *)key;

- (UIImage *)imageForKey:(NSString *)key;

- (void)deleteImageForKey:(NSString *)key;

- (NSString *)imagePathForKey:(NSString *)key;

@end

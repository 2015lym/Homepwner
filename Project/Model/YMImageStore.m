//
//  YMImageStore.m
//  Homepwner
//
//  Created by Lym on 2017/1/2.
//  Copyright © 2017年 Lym. All rights reserved.
//

#import "YMImageStore.h"

@interface YMImageStore ()

@property (strong, nonatomic) NSMutableDictionary *dictionary;

@end

@implementation YMImageStore

+ (instancetype)sharedStore {
    static YMImageStore *sharedStore = nil;
    if (!sharedStore) {
        sharedStore = [[self alloc] initPrivate];
    }
    return sharedStore;
}

- (instancetype)init {
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use + [YMItemStore sharedStore]"
                                 userInfo:nil];
    return nil;
}

- (instancetype)initPrivate {
    self = [super init];
    if (self) {
        _dictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)setImage:(UIImage *)image forKey:(NSString *)key {
    [self.dictionary setObject:image forKey:key];
}

- (UIImage *)imageForKey:(NSString *)key {
    return [self.dictionary objectForKey:key];
}

- (void)deleteImageForKey:(NSString *)key {
    if (!key) {
        return;
    }
    [self.dictionary removeObjectForKey:key];
}

@end

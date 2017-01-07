//
//  YMItemStore.m
//  Homepwner
//
//  Created by Lym on 2016/12/11.
//  Copyright © 2016年 Lym. All rights reserved.
//

#import "YMItemStore.h"
#import "YMItem.h"
#import "YMImageStore.h"

@interface YMItemStore ()

@property (strong, nonatomic) NSMutableArray *privateItems;

@end

@implementation YMItemStore

+ (instancetype)sharedStore {
    static YMItemStore *sharedStore = nil;
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
        _privateItems = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSArray *)allItems {
    return [self.privateItems copy];
}

- (YMItem *)createItem {
    YMItem *item = [YMItem randomItem];
    
    [self.privateItems addObject:item];
    
    return item;
}

- (void)removeItem:(YMItem *)item {
    NSString *key = item.itemKey;
    [[YMImageStore sharedStore] deleteImageForKey:key];
    [self.privateItems removeObjectIdenticalTo:item];
}

- (void)moveItemAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex {
    if (fromIndex == toIndex) {
        return;
    }
    
    YMItem *item = self.privateItems[fromIndex];
    
    [self.privateItems removeObjectAtIndex:fromIndex];
    
    [self.privateItems insertObject:item atIndex:toIndex];
}

@end

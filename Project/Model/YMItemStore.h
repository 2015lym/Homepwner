//
//  YMItemStore.h
//  Homepwner
//
//  Created by Lym on 2016/12/11.
//  Copyright © 2016年 Lym. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YMItem;

@interface YMItemStore : NSObject

@property (strong, nonatomic, readonly) NSArray *allItems;

+ (instancetype)sharedStore;

- (YMItem *)createItem;
- (void)removeItem:(YMItem *)item;
- (void)moveItemAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;

- (BOOL)saveChanges;

@end

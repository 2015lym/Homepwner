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

+ (instancetype)sharedStore
{
    static YMItemStore *sharedStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc] initPrivate];
    });
    
    return sharedStore;
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use + [YMItemStore sharedStore]"
                                 userInfo:nil];
    return nil;
}

- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        NSString *path = [self itemArchivePath];
        _privateItems = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        //如果之前没有保存过privateItems，就创建一个新的
        if (!_privateItems) {
            _privateItems = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

- (NSArray *)allItems
{
    return [self.privateItems copy];
}

- (YMItem *)createItem
{
    YMItem *item = [YMItem randomItem];
    
    [self.privateItems addObject:item];
    
    return item;
}

- (void)removeItem:(YMItem *)item
{
    NSString *key = item.itemKey;
    [[YMImageStore sharedStore] deleteImageForKey:key];
    [self.privateItems removeObjectIdenticalTo:item];
}

- (void)moveItemAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex
{
    if (fromIndex == toIndex) {
        return;
    }
    
    YMItem *item = self.privateItems[fromIndex];
    
    [self.privateItems removeObjectAtIndex:fromIndex];
    
    [self.privateItems insertObject:item atIndex:toIndex];
}

- (NSString *)itemArchivePath
{
    //注意第一个参数是NSDocumentDirectory而不是NSDocumentationDirectory
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                       NSUserDomainMask,
                                                                       YES);
    
    //从documentDirectories数组中获取第一个，也是唯一一个文档目录路径
    NSString *documentDirecotry = [documentDirectories firstObject];
    
    return [documentDirecotry
            stringByAppendingPathComponent:@"items.archive"];
}

- (BOOL)saveChanges
{
    NSString *path = [self itemArchivePath];
    
    //如果固化成功就返回YES
    return [NSKeyedArchiver archiveRootObject:self.privateItems toFile:path];
}

@end

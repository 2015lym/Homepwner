//
//  YMImageStore.m
//  Homepwner
//
//  Created by Lym on 2017/1/2.
//  Copyright © 2017年 Lym. All rights reserved.
//

#import "YMImageStore.h"
#import <UIKit/UIKit.h>

@interface YMImageStore ()

@property (strong, nonatomic) NSMutableDictionary *dictionary;

@end

@implementation YMImageStore

+ (instancetype)sharedStore
{
    static YMImageStore *sharedStore = nil;
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
        _dictionary = [[NSMutableDictionary alloc] init];
        
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(clearCaches) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    return self;
}

- (void)setImage:(UIImage *)image forKey:(NSString *)key
{
//    [self.dictionary setObject:image forKey:key];
    
    self.dictionary[key] = image;
    
    //获取保存图片的全路径
    NSString *imagePath = [self imagePathForKey:key];
    
    //从图片提取JPEG格式的数据
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    
    [data writeToFile:imagePath atomically:YES];
}

- (UIImage *)imageForKey:(NSString *)key
{
    //先尝试通过字典对象获取图片
    UIImage *result = self.dictionary[key];
    
    if (result != nil) {
        NSString *imagePath = [self imagePathForKey:key];
        
        //通过文件创建UIImage对象
        result = [UIImage imageWithContentsOfFile:imagePath];
        
        //如果能够通过文件创建图片，就将其放入缓存
        if (result) {
            self.dictionary[key] = result;
        } else {
            NSLog(@"Error: unable to find %@", [self imageForKey:key]);
        }
    }
    
    return result;
}

- (void)deleteImageForKey:(NSString *)key
{
    if (!key) {
        return;
    }
    [self.dictionary removeObjectForKey:key];
    
    NSString *imagePath = [self imagePathForKey:key];
    [[NSFileManager defaultManager] removeItemAtPath:imagePath
                                               error:nil];
}

- (NSString *)imagePathForKey:(NSString *)key
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                       NSUserDomainMask,
                                                                       YES);
    
    NSString *documentDirectory = [documentDirectories firstObject];
    
    return [documentDirectory stringByAppendingPathComponent:key];
}

- (void)clearCache:(NSNotification *)note
{
    NSLog(@"flushing %ld images out of the cache", [self.dictionary count]);
    [self.dictionary removeAllObjects];
}

@end

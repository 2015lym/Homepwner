//
//  YMDetailViewViewController.h
//  Homepwner
//
//  Created by Lym on 2017/1/1.
//  Copyright © 2017年 Lym. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YMItem;

@interface YMDetailViewViewController : UIViewController

- (instancetype)initForNewItem:(BOOL)isNew;

@property (strong, nonatomic) YMItem *item;

@property (copy, nonatomic) void (^dismissBlock)(void);

@end

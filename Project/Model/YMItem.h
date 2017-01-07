//
//  YMItem.h
//  Homepwner
//
//  Created by Lym on 2016/12/11.
//  Copyright © 2016年 Lym. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMItem : NSObject

@property (copy, nonatomic) NSString *itemName;
@property (copy, nonatomic) NSString *serialNumber;
@property (assign, nonatomic) int valueInDollars;
@property (strong, nonatomic, readonly) NSDate *dateCreated;

@property (copy, nonatomic) NSString *itemKey;

+ (instancetype)randomItem;

@end

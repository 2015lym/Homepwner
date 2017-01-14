//
//  YMItemCell.h
//  Homepwner
//
//  Created by Lym on 2017/1/14.
//  Copyright © 2017年 Lym. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *serialNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@property (copy, nonatomic) void (^actionBlock)(void);

@end

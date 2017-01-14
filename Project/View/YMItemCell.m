//
//  YMItemCell.m
//  Homepwner
//
//  Created by Lym on 2017/1/14.
//  Copyright © 2017年 Lym. All rights reserved.
//

#import "YMItemCell.h"

@implementation YMItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)showImage:(id)sender
{
    if (self.actionBlock) {
        self.actionBlock();
    }
}

@end

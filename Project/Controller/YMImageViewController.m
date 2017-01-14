//
//  YMImageViewController.m
//  Homepwner
//
//  Created by Lym on 2017/1/14.
//  Copyright © 2017年 Lym. All rights reserved.
//

#import "YMImageViewController.h"

@interface YMImageViewController ()

@end

@implementation YMImageViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIImageView *imageView = (UIImageView *)self.view;
    imageView.image = self.image;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadView
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.view = imageView;
}

@end

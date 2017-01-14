//
//  YMItemsViewController.m
//  Homepwner
//
//  Created by Lym on 2016/12/11.
//  Copyright © 2016年 Lym. All rights reserved.
//

#import "YMItemsViewController.h"
#import "YMItemStore.h"
#import "YMItem.h"
#import "YMDetailViewViewController.h"
#import "YMItemCell.h"
#import "YMImageStore.h"
#import "YMImageViewController.h"

@interface YMItemsViewController ()<UIPopoverControllerDelegate>

@property (strong, nonatomic) UIPopoverController *imagePopover;

@end

@implementation YMItemsViewController
#pragma mark - ---------- 生命周期 ----------
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //创建UINib对象，该对象代表包含了YMItemCell的NIB文件
    UINib *nib = [UINib nibWithNibName:@"YMItemCell" bundle:nil];
    
    //通过UINib对象注册相应的NIB文件
    [self.tableView registerNib:nib
         forCellReuseIdentifier:@"YMItemCell"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - ---------- 私有方法 ----------
- (instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = @"Homepwner";
        
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc]
                    initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                         target:self
                                         action:@selector(addNewItem:)];
        navItem.rightBarButtonItem = bbi;
        navItem.leftBarButtonItem = self.editButtonItem;
    }
    return self;
}

#pragma mark - ---------- Action ----------
- (IBAction)addNewItem:(id)sender
{
    //创建NSIndexPath对象，代表的位置是：第一个表格段，最后一个表格行
    YMItem *newItem = [[YMItemStore sharedStore] createItem];

    YMDetailViewViewController *detailViewController =
                            [[YMDetailViewViewController alloc] initForNewItem:YES];
    
    detailViewController.item = newItem;
    
    detailViewController.dismissBlock = ^{
        [self.tableView reloadData];
    };
    
    UINavigationController *navController = [[UINavigationController alloc]
                                             initWithRootViewController:detailViewController];
    
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [self presentViewController:navController animated:YES completion:nil];
}

#pragma mark - ---------- delegate ----------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[YMItemStore sharedStore] allItems] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YMItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YMItemCell"
                                                       forIndexPath:indexPath];
    
    NSArray *items = [[YMItemStore sharedStore] allItems];
    YMItem *item = items[indexPath.row];
    
    cell.nameLabel.text = item.itemName;
    cell.serialNumberLabel.text = item.serialNumber;
    cell.valueLabel.text = [NSString stringWithFormat:@"$%d", item.valueInDollars];
    cell.thumbnailView.image = item.thumbnail;
    
    cell.actionBlock = ^{
        NSLog(@"Going to show image for %@", item);
    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
                                            forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray *items = [[YMItemStore sharedStore] allItems];
        YMItem *item = items[indexPath.row];
        [[YMItemStore sharedStore] removeItem:item];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
                                                  toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [[YMItemStore sharedStore] moveItemAtIndex:sourceIndexPath.row toIndex:destinationIndexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YMDetailViewViewController *detailViewController =
                            [[YMDetailViewViewController alloc] initForNewItem:NO];
    
    NSArray *items = [[YMItemStore sharedStore] allItems];
    YMItem *selectedItem = items[indexPath.row];
    detailViewController.item = selectedItem;
    
    [self.navigationController pushViewController:detailViewController
                                         animated:YES];
}

@end

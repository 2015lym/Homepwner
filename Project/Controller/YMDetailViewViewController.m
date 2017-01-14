//
//  YMDetailViewViewController.m
//  Homepwner
//
//  Created by Lym on 2017/1/1.
//  Copyright © 2017年 Lym. All rights reserved.
//

#import "YMDetailViewViewController.h"
#import "YMItem.h"
#import "YMImageStore.h"
#import "YMItemStore.h"

@interface YMDetailViewViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UIPopoverControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *serialNumberField;
@property (weak, nonatomic) IBOutlet UITextField *valueField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cameraButton;

@property (strong, nonatomic) UIPopoverController *imagePickerPopver;

@end

@implementation YMDetailViewViewController

#pragma mark - ---------- 生命周期 ----------
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIInterfaceOrientation io = [[UIApplication sharedApplication] statusBarOrientation];
    [self prepareViewsForOrientation:io];
    
    YMItem *item = self.item;
    
    self.nameField.text = item.itemName;
    self.serialNumberField.text = item.serialNumber;
    self.valueField.text = [NSString stringWithFormat:@"%d", item.valueInDollars];
    
    //创建NSDateFormatter对象，用于将NSDate对象转换成简单的日期字符串
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        dateFormatter.timeStyle = NSDateFormatterNoStyle;
    }
    
    self.dateLabel.text = [dateFormatter stringFromDate:item.dateCreated];
    
    NSString *itemKey = self.item.itemKey;
    
    //根据itemKey，从YMImageStore对象获取照片
    UIImage *imageToDisplay = [[YMImageStore sharedStore] imageForKey:itemKey];
    
    //将得到的照片赋给UIImageView对象
    self.imageView.image = imageToDisplay;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //取消当前的第一响应对象
    [self.view endEditing:YES];
    
    //将修改“保存”至YMItem对象
    YMItem *item = self.item;
    item.itemName = self.nameField.text;
    item.serialNumber = self.serialNumberField.text;
    item.valueInDollars = [self.valueField.text intValue];
}

#pragma mark - ---------- 公有方法 ----------
- (instancetype)initForNewItem:(BOOL)isNew
{
    self = [super initWithNibName:nil bundle:nil];
    
    if (self) {
        if (isNew) {
            UIBarButtonItem *doneItem = [[UIBarButtonItem alloc]
                                         initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                         target:self
                                         action:@selector(save:)];
            self.navigationItem.leftBarButtonItem = doneItem;
            
            UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc]
                                         initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                         target:self
                                         action:@selector(cancel:)];
            self.navigationItem.rightBarButtonItem = cancelItem;
        }
    }
    return self;
}

#pragma mark - ---------- 私有方法 ----------
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    @throw [NSException exceptionWithName:@"Wrong initializer"
                                   reason:@"Use initForNewItem:"
                                 userInfo:nil];
    return nil;
}

- (void)save:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES
                                                      completion:self.dismissBlock];
}

- (void)cancel:(id)sender
{
    //如果用户按下了Cancel按钮，就从YMItemStore对象移除新创建的YMItem对象
    [[YMItemStore sharedStore] removeItem:self.item];
    
    [self.presentingViewController dismissViewControllerAnimated:YES
                                                      completion:self.dismissBlock];
}

- (void)setItem:(YMItem *)item
{
    _item = item;
    self.navigationItem.title = _item.itemName;
}

- (void)prepareViewsForOrientation:(UIInterfaceOrientation)orientation
{
    //如果是iPad,则不执行任何操作
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        return;
    }
    
    //判断设备是否处于横排方向
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        self.imageView.hidden = YES;
        self.cameraButton.enabled = NO;
    } else {
        self.imageView.hidden = NO;
        self.cameraButton.enabled = YES;
    }
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self prepareViewsForOrientation:toInterfaceOrientation];
}

#pragma mark - ---------- Action ----------
- (IBAction)takePicture:(id)sender
{
    if ([self.imagePickerPopver isPopoverVisible]) {
        //如果imagePickerPopver指向的是有效的UIPopoverController对象，
        //并且该对象的视图是可见的，就关闭这个对象，并将其设置为nil
        [self.imagePickerPopver dismissPopoverAnimated:YES];
        self.imagePickerPopver = nil;
        return;
    }
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    //有相机则使用拍照模式，无相机则调用照片库
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    imagePicker.delegate = self;
    
    //允许编辑，可对图片进行裁剪
    imagePicker.allowsEditing = YES;

//    [self presentViewController:imagePicker animated:YES completion:nil];
    
    //创建UIPopoverController对象前先检查当前设备是否是iPad
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        //创建UIPopoverController对象，用于显示UIImagepickerController对象
        self.imagePickerPopver = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
        self.imagePickerPopver.delegate = self;
        
        //显示UIPopoverController对象
        //sender指向的是代表相机按钮的UIBarButtonItem对象
        [self.imagePickerPopver presentPopoverFromBarButtonItem:sender
                                       permittedArrowDirections:UIPopoverArrowDirectionAny
                                                       animated:YES];
    } else {
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

- (IBAction)backgroundTapped:(id)sender
{
    [self.view endEditing:YES];
}

#pragma mark - ---------- delegate ----------
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    [self.item setThumbnail:image];
    
    [[YMImageStore sharedStore] setImage:image forKey:self.item.itemKey];
    
    self.imageView.image = image;
    
    //判断UIPopoverController对象是否存在
    if (self.imagePickerPopver) {
        //关闭UIPopoverController对象
        [self.imagePickerPopver dismissPopoverAnimated:YES];
        self.imagePickerPopver = nil;
    } else {
        //关闭以模态形式显示的UIImagePickerController对象
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    NSLog(@"User dismissed popover");
    self.imagePickerPopver = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end

//
//  MainWaterMarkViewController.m
//  SellerWaterMark
//
//  Created by yuemin3 on 2016/11/28.
//  Copyright © 2016年 hangzhou.cao. All rights reserved.
//

#import "MainWaterMarkViewController.h"
#import "UIViewController+Extension.h"
#import "YBPasterScrollView.h"
#import "YBPasterView.h"
#import "UIImage+AddFunction.h"
#import "YBCustomButton.h"
// 标签
#import "StickerView.h"
//#import "BlocksKit.h"
//#import "BlocksKit+UIKit.h"
#import "YBFilterScrollView.h"
#import "UIViewController+Example.h"
#import "UIViewController+Swizzling.h"
#import "MaterialListViewController.h"
#import "EditLabelViewController.h"
#import "WaterMarkDealTool.h"

#define FULL_SCREEN_H [UIScreen mainScreen].bounds.size.height
#define FULL_SCREEN_W [UIScreen mainScreen].bounds.size.width
/**
 *  "水印"，“标签”，“滤镜”
 */
typedef NS_ENUM(NSInteger, YBImageDecoration) {
    /*** 水印*/
    YBImagePaster = 0,
    /*** 标签*/
    YBImageTag,
    /*** 滤镜*/
    YBImageFilter,
};

/**底部的scrollView的高*/
const CGFloat pasterScrollView_H = 120;
/**空白的距离间隔*/
extern CGFloat inset_space;
/**默认的图片上的贴纸大小*/
static const CGFloat defaultPasterViewW_H = 120;
/**底部按钮的高度*/
static CGFloat bottomButtonH = 55;

@interface MainWaterMarkViewController () <YBPasterScrollViewDelegate, YBFilterScrollViewDelegate, YBPasterViewDelegate, EditLabelViewControllerDelegate, StickerViewDelegate>
{
    NSInteger defaultIndex;
    NSString* _name;
}
/**上部的图片imageView*/
@property (nonatomic, strong) UIImageView *pasterImageView;
/**多个贴纸样式的scrollView*/
@property (nonatomic, strong) YBPasterScrollView *pasterScrollView;
/**装多个滤镜样式的scrollView*/
@property (nonatomic, strong) YBFilterScrollView *filterScrollView;
/**图片数组*/
@property (nonatomic, copy) NSArray *imageArray;
/**可变的装多个贴纸标签的数组*/
@property (nonatomic, copy) NSMutableArray *pasterViewMutArr;
/**贴纸*/
@property (nonatomic, strong) YBPasterView *pasterView;
/**底部的公共的按钮*/
@property (nonatomic, strong) YBCustomButton *bottomButton;
/**底部view*/
@property (nonatomic, strong) UIView *bottomBackView;
/**底部second view*/
@property (nonatomic, strong) UIView *secView;
@property (nonatomic ,strong) NSMutableArray *deals;
// 标签
@property (strong, nonatomic) StickerView *selectedSticker;
@property (strong,nonatomic) UIDynamicAnimator * animator;

@end

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-variable" //消除没有用到的变量产生的警告

@implementation MainWaterMarkViewController


/**
 *  初始化一个对象
 *
 *  @param name 名字
 *
 *  @return 自己
 */
- (instancetype)initWithName:(NSString *)name {
    self = [super init];
    if(!self) return self;
    _name = name;
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (UIImagePNGRepresentation(self.editedImage) == nil) {
        
    } else {
//        YBPasterView *pasterView = [[YBPasterView alloc]initWithFrame:CGRectMake(0, 0, defaultPasterViewW_H, 50)];
        YBPasterView *pasterView = [[YBPasterView alloc]initWithFrame:CGRectMake(0, 0, self.editedImage.size.width, self.editedImage.size.height)];
        pasterView.center = CGPointMake(self.pasterImageView.frame.size.width/2, self.pasterImageView.frame.size.height/2);
        pasterView.pasterImage = self.editedImage;
        pasterView.delegate = self;
        [self.pasterImageView addSubview:pasterView];
        self.pasterView = pasterView;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationController.navigationBar.alpha = 0.0;
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bigShadow.png"] forBarMetrics:UIBarMetricsCompact];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bigShadow.png"] forBarMetrics:UIBarMetricsDefault];
    UIImage *image = [UIImage imageNamed:@"bigShadow.png"];
//    [self.navigationController.navigationBar setShadowImage:image];
    //设置一些通用属性
    [self setGeneralPropetory];
    
    //添加右键
    [self setRightButton];
    
    //设置UI
    [self setupUI];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
//    NSData *JSONData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ren" ofType:@"json"]];
//    
//    NSArray *dataArray = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:nil];
//    
//    NSLog(@"%@",dataArray);
}

/**
 *  设置一些通用属性
 */
- (void)setGeneralPropetory
{
    self.view.backgroundColor = RGB_COLOR(25, 27, 32, 1);
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController setNavigationBarHidden:NO];
//    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

/**
 *  懒加载-装多张贴纸的可变数组
 */
- (NSMutableArray *)pasterViewMutArr
{
    if (!_pasterViewMutArr) {
        _pasterViewMutArr = [NSMutableArray array];
    }
    
    return _pasterViewMutArr;
}

/**
 *  懒加载-图片数组
 */
- (NSArray *)imageArray
{
    if (!_imageArray) {
        NSMutableArray *mutArr = [NSMutableArray arrayWithCapacity:0];
        NSArray *arr = @[@"tab_icon_cancel"];
        for (NSString *imageName in arr) {
            UIImage *image = [UIImage imageNamed:imageName];
            [mutArr addObject:image];
        }
        self.deals =  [NSMutableArray arrayWithArray:[WaterMarkDealTool imageDeals:0]];
        for (EditorLabelModel *model in self.deals) {
            [mutArr addObject:[UIImage imageWithData:model.editImage]];
        }
        NSLog(@"mutArr   %@",mutArr);
        _imageArray = mutArr;
    }
    
    return _imageArray;
}

/**
 *  懒加载-get方法设置自定义贴纸的scrollView
 */
- (YBPasterScrollView *)pasterScrollView
{
    if (!_pasterScrollView) {
        _pasterScrollView = [[YBPasterScrollView alloc]initScrollViewWithPasterImageArray:self.imageArray];
        _pasterScrollView.frame = CGRectMake(0, FULL_SCREEN_H - pasterScrollView_H - bottomButtonH, FULL_SCREEN_W, pasterScrollView_H);
        _pasterScrollView.backgroundColor = RGB_COLOR(25, 27, 32, 1);
        _pasterScrollView.showsHorizontalScrollIndicator = YES;
        _pasterScrollView.bounces = YES;
        _pasterScrollView.contentSize = CGSizeMake(_pasterScrollView.pasterImage_W_H * _pasterScrollView.pasterImageArray.count + inset_space * 6, pasterScrollView_H);
        _pasterScrollView.pasterDelegate = self;
    }
    
    return _pasterScrollView;
}

/**
 *  懒加载-get方法设置自定义滤镜的scrollView
 */
- (YBFilterScrollView *)filterScrollView
{
    if (!_filterScrollView) {
        _filterScrollView = [[YBFilterScrollView alloc]initWithFrame:CGRectMake(0, FULL_SCREEN_H - pasterScrollView_H - bottomButtonH, FULL_SCREEN_W, pasterScrollView_H)];
        _filterScrollView.backgroundColor = RGB_COLOR(25, 27, 32, 1);
        _filterScrollView.showsHorizontalScrollIndicator = YES;
        _filterScrollView.bounces = YES;
        NSArray *titleArray = @[@"原图",@"LOMO",@"黑白",@"复古",@"哥特",@"瑞华",@"淡雅",@"酒红",@"青柠",@"浪漫",@"光晕",@"蓝调",@"梦幻",@"夜色"];
        _filterScrollView.titleArray = titleArray;
        _filterScrollView.filterScrollViewW = pasterScrollView_H;
        _filterScrollView.insert_space = inset_space*2/3;
        _filterScrollView.labelH = 30;
        NSLog(@"self.originalImage: %@",self.originalImage);
        _filterScrollView.originImage = self.originalImage;
        _filterScrollView.perButtonW_H = _filterScrollView.filterScrollViewW - 2*_filterScrollView.insert_space - 30;
        
        _filterScrollView.contentSize = CGSizeMake(_filterScrollView.perButtonW_H * titleArray.count + _filterScrollView.insert_space * (titleArray.count + 1), pasterScrollView_H);
        _filterScrollView.filterDelegate = self;
//        [_filterScrollView loadScrollView];
    }
    return _filterScrollView;
}

/**
 *  设置UI
 */
- (void)setupUI
{
    EditLabelViewController *editVC = [[EditLabelViewController alloc] init];
    editVC.delegate = self;
    //默认选中“滤镜”位置
    defaultIndex = 0;
    
    UIImageView *pasterImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 75, FULL_SCREEN_W, FULL_SCREEN_W)];
    pasterImageView.image = self.originalImage;
    pasterImageView.userInteractionEnabled = YES;
    [self.view addSubview:pasterImageView];
    self.pasterImageView = pasterImageView;
    // 底部三个按钮view
    self.bottomBackView = [[UIView alloc]initWithFrame:CGRectMake(0, FULL_SCREEN_H - bottomButtonH, FULL_SCREEN_W, bottomButtonH)];
    self.bottomBackView.backgroundColor = RGB_COLOR(39, 41, 46, 1);
    [self.view addSubview:self.bottomBackView];
    // 底部标题view
    self.secView = [[UIView alloc]initWithFrame:CGRectMake(0, FULL_SCREEN_H - bottomButtonH, FULL_SCREEN_W, bottomButtonH)];
    self.secView.backgroundColor = RGB_COLOR(39, 41, 46, 1);
    [self.view addSubview:self.secView];
    self.secView.hidden = YES;
    NSArray *array = @[@"水印",@"标签",@"滤镜"];
    NSArray *imageArray = @[@"photo_tab_bar_water_mark",@"photo_tab_bar_label",@"photo_tab_filter"];
    for (int i = 0; i < array.count; i ++)
    {
        CGFloat perButtonW = FULL_SCREEN_W/3;
        YBCustomButton *button = [[YBCustomButton alloc]initWithFrame:CGRectMake(perButtonW * i , 0, perButtonW, bottomButtonH)];
        [button setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",imageArray[i]]] forState:UIControlStateNormal];
        
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:15.0];
        button.tag = 5000 + i;
        if (i == defaultIndex) {
            button.selected = YES;
            self.bottomButton = button;
        }
        [button addTarget:self action:@selector(bottomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomBackView addSubview:button];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
        [button setTitleEdgeInsets:UIEdgeInsetsMake(button.imageView.frame.size.height + 10 ,-button.imageView.frame.size.width, -5,0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
        [button setImageEdgeInsets:UIEdgeInsetsMake(-10, 0.0,0.0, -button.titleLabel.bounds.size.width)];//图片距离右边框距离减少图片的宽度，其它不边
    }
    
//    CGFloat lineViewW = bottomBackView.frame.size.width/6;
//    CGFloat lineViewX = bottomBackView.frame.size.width/6 - lineViewW/2;
//    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(lineViewX, bottomButtonH - 3, lineViewW, 3)];
//    lineView.backgroundColor = [UIColor redColor];
//    [bottomBackView addSubview:lineView];
//    self.lineView = lineView;
    
    //底部“贴纸”的scrollView
    [self.view addSubview:self.pasterScrollView];
    self.pasterScrollView.hidden = YES;
    self.pasterScrollView.alpha = 0.0;
    
    //底部“滤镜”的scrollView
    [self.view addSubview:self.filterScrollView];
    UIView *blackLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    blackLine.backgroundColor = RGB_COLOR(38, 41, 46, 1);
    [self.bottomBackView addSubview:blackLine];
    self.filterScrollView.hidden = YES;
    self.filterScrollView.alpha = .0;
    
    UILabel *cunstLabel = [[UILabel alloc] init];
    cunstLabel.text = @"标签";
    cunstLabel.textColor = [UIColor whiteColor];
    cunstLabel.textAlignment = NSTextAlignmentCenter;
    cunstLabel.frame = CGRectMake(50, 0, self.secView.frame.size.width - 100, self.secView.frame.size.height);
    [self buttonWithLabel];
    [self.secView addSubview:cunstLabel];
}

/**
 *  底部“滤镜”、“标签”、“贴纸”的按钮点击方法
 */
- (void)bottomButtonClick:(YBCustomButton *)sender
{
    self.bottomButton.selected  = NO;
    sender.selected = !sender.selected;
    self.bottomButton = sender;
    
    // 底部的lineView转移位置
    [self lineViewTransform:sender];
    
    // 根据当前的index切换底部的scrollView
    [self changeDecorateImageWithButtonTag:sender];
}

- (void)buttonWithLabel
{
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(SCREEN_WIDTH - self.secView.frame.size.height, 0, self.secView.frame.size.height, self.secView.frame.size.height);
    [saveBtn setImage:[UIImage imageNamed:@"tab_icon_shure"] forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.secView addSubview:saveBtn];
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, 0, self.secView.frame.size.height, self.secView.frame.size.height);
    [cancelBtn setImage:[UIImage imageNamed:@"tab_icon_cancel"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.secView addSubview:cancelBtn];
}

- (void)saveClick:(UIButton *)sender
{
    self.secView.hidden = YES;
    self.bottomBackView.hidden = NO;
    [self doneEdit];
}

- (void)cancelClick:(UIButton *)sender
{
    self.secView.hidden = YES;
    self.bottomBackView.hidden = NO;
    
}

/**
 *  根据当前的index切换底部的scrollView
 */
- (void)changeDecorateImageWithButtonTag:(YBCustomButton *)sender
{
    // 当前位置是水印
    if (sender.tag - 5000 == YBImagePaster) {
        [UIView animateWithDuration:.5 animations:^{
//            self.pasterScrollView.alpha = 1.0;
//            self.pasterScrollView.hidden = NO;
//            
//            if (self.pasterView) {
//                [self.pasterView showBtn];
//            }
        }];
    }else {
        self.pasterScrollView.hidden = YES;
        self.pasterScrollView.alpha = .0;
        
        if (self.pasterView) {
            [self.pasterView hiddenBtn];
        }
    }
    
    // 当前位置是滤镜
    if (sender.tag - 5000 == YBImageFilter) {
        [_filterScrollView loadScrollView];
        [UIView animateWithDuration:.5 animations:^{
            self.filterScrollView.alpha = 1.0;
            self.filterScrollView.hidden = NO;
        }];
    }
    else {
        self.filterScrollView.hidden = YES;
        self.filterScrollView.alpha = .0;
    }
    if (sender.tag - 5000 == YBImageTag) {
        [UIView animateWithDuration:.5 animations:^{
            self.pasterScrollView.alpha = 1.0;
            self.pasterScrollView.hidden = NO;
            
            if (self.pasterView) {
                [self.pasterView showBtn];
            }
            self.bottomBackView.hidden = YES;
            self.secView.hidden = NO;
        }];
    }
}

/**
 *  底部的lineView转移位置
 */
- (void)lineViewTransform:(YBCustomButton *)sender
{
//    CGFloat sendW = sender.frame.size.width;
//    NSInteger currentIndex = sender.tag - 5000;
//    CGFloat lineViewH = self.lineView.frame.size.height;
//    CGFloat lineViewX = sendW * currentIndex + sendW / 2 - self.lineView.frame.size.width/2;
//    
//    CGFloat lineViewY = bottomButtonH - lineViewH;
//    CGFloat lineViewW = sendW/2;
//    [UIView animateWithDuration:.5 animations:^{
//        self.lineView.frame = CGRectMake(lineViewX, lineViewY, lineViewW, lineViewH);
//    }];
}

/**
 *  导航栏的“完成”右键
 */
- (void)setRightButton
{
    [self initRightButtonWithButtonW:50 buttonH:50 title:@"保存" titleColor:RGB_COLOR(220, 50, 92, 1) touchBlock:^(UIButton *rightButton) {
        
    }];
//    [self initBackButtonWithButtonW:50 buttonH:50 title:@"返回" titleColor:[UIColor whiteColor] buttonImage:[UIImage imageNamed:@"photo_navi_back"] negativeSpacer:0 touchBlock:^(UIButton *BackButton) {
//        
//    }];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(14, 0, 70, 50);
    [button setTitle:@"返回" forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"photo_navi_back"] forState:UIControlStateNormal];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0,0.0, 0)];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 7, 0, 0)];
    [button addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    WS(weakSelf);
    YBWeak(MainWaterMarkViewController, weakMy);
    //按钮的点击事件封装的block
    weakSelf.rightBtnBlock = ^(NSString *string){
        
        [weakSelf.pasterView hiddenBtn];
        UIImage *editedImage = [weakSelf doneEdit];
        [self loadImageFinished:editedImage];
        [weakSelf.navigationController popViewControllerAnimated:YES];
//        if (weakSelf.block) {
//            
//            if (weakSelf.pasterView != nil) {
//                UIImage *editedImage = [weakSelf doneEdit];
//                [self loadImageFinished:editedImage];
//                weakSelf.block(editedImage);
//            } else {
//                weakSelf.block(weakSelf.pasterImageView.image);
//            }
//            
//            [weakSelf.pasterImageView removeFromSuperview];
//            [weakSelf.filterScrollView removeFromSuperview];
//            [weakSelf.navigationController popViewControllerAnimated:YES];
//        }
    };
}

- (void)loadImageFinished:(UIImage *)image
{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
}

- (void)backClick:(UIButton *)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

/**
 *  图片合成
 *
 *  @return 返回合成好的图片
 */
- (UIImage *)doneEdit
{
    CGFloat org_width = self.originalImage.size.width ;
    CGFloat org_heigh = self.originalImage.size.height ;
    CGFloat rateOfScreen = org_width / org_heigh ;
    CGFloat inScreenH = self.pasterImageView.frame.size.width / rateOfScreen ;
    
    CGRect rect = CGRectZero ;
    rect.size = CGSizeMake(self.pasterImageView.frame.size.width, inScreenH) ;
    rect.origin = CGPointMake(0, (self.pasterImageView.frame.size.height - inScreenH) / 2) ;
    
    UIImage *imgTemp = [UIImage getImageFromView:self.pasterImageView] ;
    UIImage *imgCut = [UIImage squareImageFromImage:imgTemp scaledToSize:rect.size.width] ;
    
    return imgCut;
}

#pragma mark - 标签添加
- (void)pasterTag:(NSInteger)pasterTag pasterImage:(UIImage *)pasterImage
{
//    if (self.pasterView) {
//        [self.pasterView removeFromSuperview];
//        self.pasterView = nil;
//    }
    /*
    YBPasterView *pasterView = [[YBPasterView alloc]initWithFrame:CGRectMake(0, 0, defaultPasterViewW_H, defaultPasterViewW_H)];
    pasterView.center = CGPointMake(self.pasterImageView.frame.size.width/2, self.pasterImageView.frame.size.height/2);
    pasterView.pasterImage = pasterImage;
    pasterView.delegate = self;
    [self.pasterImageView addSubview:pasterView];
    self.pasterView = pasterView;
    */
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.pasterImageView];
    StickerView *sricker = [[StickerView alloc] initWithContentFrame:CGRectMake(0, 0, 160, 45) contentImage:pasterImage];
    
    sricker.center = CGPointMake(self.pasterImageView.frame.size.width/2, self.pasterImageView.frame.size.height/2);
    sricker.enabledControl = NO;
    sricker.enabledBorder = NO;
    sricker.delegate = self;
    sricker.tag = pasterTag;
    NSLog(@"sricker    %@",sricker);
    [self.pasterImageView addSubview:sricker];
}

- (void)sendTag:(NSInteger)firstTag
{
    MaterialListViewController *material = [[MaterialListViewController alloc] init];
    material.orginalImage = self.originalImage;
    [self.navigationController pushViewController:material animated:YES];
}

#pragma mark EditControllerDelegate
- (void)sendEditedImagge:(UIImage *)image
{
    YBPasterView *pasterView = [[YBPasterView alloc]initWithFrame:CGRectMake(0, 0, defaultPasterViewW_H, defaultPasterViewW_H)];
    pasterView.center = CGPointMake(self.pasterImageView.frame.size.width/2, self.pasterImageView.frame.size.height/2);
    pasterView.pasterImage = image;
    pasterView.delegate = self;
    [self.pasterImageView addSubview:pasterView];
    self.pasterView = pasterView;
}

#pragma mark - YBFilterScrollViewDelegate
- (void)filterImage:(UIImage *)editedImage
{
    self.pasterImageView.image = editedImage;
}
#pragma mark - EditLabelDelegate
- (void)editImageAction
{
//    EditLabelViewController *editView = [[EditLabelViewController alloc] init];
////    editView.editModel = 
//    [self.navigationController pushViewController:editView animated:YES];
    NSLog(@"self.pasterView - %@",self.pasterView.pasterImage);
}

/**
 *  测试有返回值的代理
 */
- (NSString *)deliverStr:(NSString *)originalStr
{
    NSString *string;
    string = originalStr;
    return string;
}

#pragma mark - YBPasterViewDelegate
- (void)deleteThePaster
{
    self.pasterView = nil;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}
#pragma mark - StickerViewDelegate

- (UIImage *)stickerView:(StickerView *)stickerView imageForRightTopControl:(CGSize)recommendedSize {
    return [UIImage imageNamed:@"StickerView.bundle/btn_smile.png"];
}

- (UIImage *)stickerView:(StickerView *)stickerView imageForLeftBottomControl:(CGSize)recommendedSize {
    return [UIImage imageNamed:@"StickerView.bundle/btn_flip.png"];
}

- (void)stickerViewDidTapContentView:(StickerView *)stickerView {
    NSLog(@"Tap[%zd] ContentView", stickerView.tag);
    if (self.selectedSticker) {
        self.selectedSticker.enabledBorder = NO;
        self.selectedSticker.enabledControl = NO;
    }
    self.selectedSticker = stickerView;
    self.selectedSticker.enabledBorder = YES;
    self.selectedSticker.enabledControl = YES;
}

- (void)stickerViewDidTapDeleteControl:(StickerView *)stickerView {
    NSLog(@"Tap[%zd] DeleteControl", stickerView.tag);
    for (UIView *subView in self.view.subviews) {
        if ([subView isKindOfClass:[StickerView class]]) {
            [(StickerView *)subView performTapOperation];
            break;
        }
    }
}

- (void)stickerViewDidTapLeftBottomControl:(StickerView *)stickerView {
    NSLog(@"Tap[%zd] LeftBottomControl", stickerView.tag);
    UIImageOrientation targetOrientation = (stickerView.contentImage.imageOrientation == UIImageOrientationUp ? UIImageOrientationUpMirrored : UIImageOrientationUp);
    UIImage *invertImage =[UIImage imageWithCGImage:stickerView.contentImage.CGImage
                                              scale:1.0
                                        orientation:targetOrientation];
    stickerView.contentImage = invertImage;
}

- (void)stickerViewDidTapRightTopControl:(StickerView *)stickerView {
    NSLog(@"Tap[%zd] RightTopControl", stickerView.tag);
    [_animator removeAllBehaviors];
    UISnapBehavior * snapbehavior = [[UISnapBehavior alloc] initWithItem:stickerView snapToPoint:self.view.center];
    snapbehavior.damping = 0.65;
    [self.animator addBehavior:snapbehavior];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

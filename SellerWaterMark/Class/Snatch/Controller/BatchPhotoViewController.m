//
//  BatchPhotoViewController.m
//  SellerWaterMark
//
//  Created by yuemin3 on 2016/12/27.
//  Copyright © 2016年 hangzhou.cao. All rights reserved.
//

#import "BatchPhotoViewController.h"
#import "BatchView.h"
#import "UIColor+Help.h"

#import "UIViewController+Extension.h"
#import "YBPasterScrollView.h"
#import "YBPasterView.h"
#import "UIImage+AddFunction.h"
#import "YBCustomButton.h"
#import "YBFilterScrollView.h"
#import "UIViewController+Example.h"
#import "UIViewController+Swizzling.h"
#import "MaterialListViewController.h"
#import "EditLabelViewController.h"
#import "WaterMarkDealTool.h"
#import "PasterDealTool.h"
#import "YBWaterMarkScrollView.h"
#import "StickerView.h"

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

/**空白的距离间隔*/
extern CGFloat inset_space;
/**空白的距离间隔*/
extern CGFloat water_space;

@interface BatchPhotoViewController () <YBPasterScrollViewDelegate, YBFilterScrollViewDelegate, YBPasterViewDelegate, EditLabelViewControllerDelegate, StickerViewDelegate, YBWaterMarkScrollViewDelegate>
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
@property (nonatomic, copy) NSArray *imagesArray;
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
@property (nonatomic ,assign) NSInteger imageIndex;
// 水印
@property (nonatomic ,strong) YBWaterMarkScrollView *waterMarkScrollView;
@property (nonatomic ,strong) NSMutableArray *waterImageArray;

@property (nonatomic ,strong) UIScrollView *batchScrollView;

@end

@implementation BatchPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationTitle];
    self.view.backgroundColor = [UIColor blackColor];
    
    [self setBatchScrollView];
    [self setUpSomeThing];
    [nNotification addObserver:self selector:@selector(labelImage:) name:@"labelImage" object:nil];
    [nNotification addObserver:self selector:@selector(waterMarkImage:) name:@"waterMarkImage" object:nil];
}

- (void)waterMarkImage:(NSNotification *)cender
{
    NSData *data = cender.userInfo[@"downloadImage"];
    UIImage *image = [UIImage imageWithData:data];
    NSLog(@"...............%@",image);
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.pasterImageView];
    for (BatchView *view in self.batchScrollView.subviews) {
        if ([view isKindOfClass:[BatchView class]]) {StickerView *sricker = [[StickerView alloc] initWithContentFrame:CGRectMake(0, 0, 110, 110) contentImage:image];
            
            sricker.center = CGPointMake(view.frame.size.width/2, view.frame.size.height/2);
            sricker.enabledControl = NO;
            sricker.enabledBorder = NO;
            sricker.delegate = self;
            sricker.tag = self.imageIndex;
            [view addSubview:sricker];
            NSLog(@"sricker    %f",view.frame.size.height);
        }
    }
    
    self.imageIndex++;
}

- (void)labelImage:(NSNotification *)cender
{
    NSData *data = cender.userInfo[@"downloadImage"];
    UIImage *image = [UIImage imageWithData:data];
    NSLog(@"...............%@",image);
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.pasterImageView];
    
    for (BatchView *view in self.batchScrollView.subviews) {
        if ([view isKindOfClass:[BatchView class]]) {StickerView *sricker = [[StickerView alloc] initWithContentFrame:CGRectMake(0, 0, 160, 45) contentImage:image];
            
            sricker.center = CGPointMake(view.frame.size.width/2, view.frame.size.height/2);
            sricker.enabledControl = NO;
            sricker.enabledBorder = NO;
            sricker.delegate = self;
            sricker.tag = self.imageIndex;
            [view addSubview:sricker];
            NSLog(@"sricker    %f",view.frame.size.height);
        }
    }
    
    self.imageIndex++;
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
- (NSArray *)imagesArray
{
    if (!_imagesArray) {
        NSMutableArray *mutArr = [NSMutableArray arrayWithCapacity:0];
        NSArray *arr = @[@"tab_icon_cancel"];
        for (NSString *imageName in arr) {
            UIImage *image = [UIImage imageNamed:imageName];
            [mutArr addObject:image];
        }
        self.deals =  [NSMutableArray arrayWithArray:[PasterDealTool imageDeals:0]];
        for (EditorLabelModel *model in self.deals) {
            [mutArr addObject:[UIImage imageWithData:model.editImage]];
        }
        NSLog(@"mutArr   %@",mutArr);
        _imagesArray = mutArr;
    }
    
    return _imagesArray;
}

- (NSMutableArray *)waterImageArray
{
    if (!_waterImageArray) {
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
        _waterImageArray = mutArr;
    }
    return _waterImageArray;
}


#pragma mark  懒加载-get方法设置自定义贴纸的scrollView
- (YBPasterScrollView *)pasterScrollView
{
    if (!_pasterScrollView) {
        _pasterScrollView = [[YBPasterScrollView alloc]initScrollViewWithPasterImageArray:self.imagesArray];
        _pasterScrollView.frame = CGRectMake(0, SCREEN_HEIGHT - 120 - 55, SCREEN_WIDTH, 120);
        _pasterScrollView.backgroundColor = RGB_COLOR(25, 27, 32, 1);
        _pasterScrollView.showsHorizontalScrollIndicator = YES;
        _pasterScrollView.bounces = YES;
        _pasterScrollView.contentSize = CGSizeMake(_pasterScrollView.pasterImage_W_H * _pasterScrollView.pasterImageArray.count + inset_space * 6, 120);
        _pasterScrollView.pasterDelegate = self;
    }
    
    return _pasterScrollView;
}
#pragma mark 懒加载-get方法设置水印
- (YBWaterMarkScrollView *)waterMarkScrollView
{
    if (!_waterMarkScrollView) {
        _waterMarkScrollView = [[YBWaterMarkScrollView alloc] initScrollViewWithWaterMarkImageArray:self.waterImageArray];
        _waterMarkScrollView.frame = CGRectMake(0, SCREEN_HEIGHT - 120 - 55, SCREEN_WIDTH, 120);
        _waterMarkScrollView.backgroundColor = RGB_COLOR(25, 27, 32, 1);
        _waterMarkScrollView.showsHorizontalScrollIndicator = YES;
        _waterMarkScrollView.bounces = YES;
        _waterMarkScrollView.contentSize = CGSizeMake(_waterMarkScrollView.waterImage_h_w * _waterMarkScrollView.waterImageArray.count + water_space * 6, 120);
        _waterMarkScrollView.waterDelegate = self;
    }
    return _waterMarkScrollView;
}


#pragma mark 懒加载-get方法设置自定义滤镜的scrollView
- (YBFilterScrollView *)filterScrollView
{
    if (!_filterScrollView) {
        _filterScrollView = [[YBFilterScrollView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 120 - 50, SCREEN_WIDTH, 120)];
        _filterScrollView.backgroundColor = RGB_COLOR(25, 27, 32, 1);
        _filterScrollView.showsHorizontalScrollIndicator = YES;
        _filterScrollView.bounces = YES;
        NSArray *titleArray = @[@"原图",@"LOMO",@"黑白",@"复古",@"哥特",@"瑞华",@"淡雅",@"酒红",@"青柠",@"浪漫",@"光晕",@"蓝调",@"梦幻",@"夜色"];
        _filterScrollView.titleArray = titleArray;
        _filterScrollView.filterScrollViewW = 120;
        _filterScrollView.insert_space = inset_space*2/3;
        _filterScrollView.labelH = 30;
//        NSLog(@"self.originalImage: %@",self.originalImage);
//        _filterScrollView.originImage = self.originalImage;
        _filterScrollView.perButtonW_H = _filterScrollView.filterScrollViewW - 2*_filterScrollView.insert_space - 30;
        
        _filterScrollView.contentSize = CGSizeMake(_filterScrollView.perButtonW_H * titleArray.count + _filterScrollView.insert_space * (titleArray.count + 1), 120);
        _filterScrollView.filterDelegate = self;
        //        [_filterScrollView loadScrollView];
    }
    return _filterScrollView;
}


#pragma mark 导航栏标题 按钮
- (void)setNavigationTitle
{
    UIView *naTitleView = [[UIView alloc] initWithFrame:CGRectMake(50, 0, SCREEN_WIDTH - 180, 20)];
    naTitleView.backgroundColor = [UIColor clearColor];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, naTitleView.frame.size.width, naTitleView.frame.size.height)];
    [title setText:ASLocalizedString(@"批量水印")];
    [title setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:18]];
    [title setTextColor:[UIColor whiteColor]];
    title.textAlignment = NSTextAlignmentCenter;
    [naTitleView addSubview:title];
    self.navigationItem.titleView = naTitleView;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(14, 0, 70, 50);
    [button setTitle:ASLocalizedString(@"返回") forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"photo_navi_back"] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0,0.0, 0)];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 7, 0, 0)];
    [button addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(14, 0, 70, 50);
    [rightBtn setTitle:ASLocalizedString(@"保存") forState:UIControlStateNormal];
    [rightBtn setTitleColor:RGB_COLOR(220, 50, 92, 1) forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(saveBatchClick:) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
}

- (void)backClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveBatchClick:(UIButton *)sender
{
    if (self.selectedSticker) {
        self.selectedSticker.enabledControl = NO;
        self.selectedSticker.enabledBorder = NO;
        self.selectedSticker = nil;
    }
    [self doneEdit];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)setBatchScrollView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIScrollView *batchScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 75, SCREEN_WIDTH, 396)];
    self.batchScrollView = batchScroll;
    batchScroll.backgroundColor = [UIColor whiteColor];
    batchScroll.contentSize = CGSizeMake(SCREEN_WIDTH * self.imageArray.count, batchScroll.frame.size.height);
    batchScroll.showsVerticalScrollIndicator = NO;
    batchScroll.bounces = NO;
    batchScroll.indicatorStyle = UIScrollViewKeyboardDismissModeNone;
    batchScroll.pagingEnabled = YES;
//    batchScroll.alwaysBounceHorizontal = NO;
    batchScroll.alwaysBounceVertical = NO;
    batchScroll.showsHorizontalScrollIndicator = NO;
    batchScroll.showsVerticalScrollIndicator = NO;
    for (int i = 0; i < self.imageArray.count; i++) {
        BatchView *view = [[BatchView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, batchScroll.frame.size.height)];
        UIImage *image = self.imageArray[i];
        view.batchImage = image;
        [batchScroll addSubview:view];
    }
    [self.view addSubview:batchScroll];
}

- (void)setUpSomeThing
{
    EditLabelViewController *editVC = [[EditLabelViewController alloc] init];
    editVC.delegate = self;
    //默认选中“滤镜”位置
    defaultIndex = 0;
    
    // 底部三个按钮view
    self.bottomBackView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 55, SCREEN_WIDTH, 55)];
    self.bottomBackView.backgroundColor = RGB_COLOR(39, 41, 46, 1);
    [self.view addSubview:self.bottomBackView];
    // 底部标题view
    self.secView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 55, SCREEN_WIDTH, 55)];
    self.secView.backgroundColor = RGB_COLOR(39, 41, 46, 1);
    [self.view addSubview:self.secView];
    self.secView.hidden = YES;
    NSArray *array = @[@"水印",@"标签",@"滤镜"];
    NSArray *imageArray = @[@"photo_tab_bar_water_mark",@"photo_tab_bar_label",@"photo_tab_filter"];
    for (int i = 0; i < array.count; i ++)
    {
        CGFloat perButtonW = SCREEN_WIDTH/3;
        YBCustomButton *button = [[YBCustomButton alloc]initWithFrame:CGRectMake(perButtonW * i , 0, perButtonW, 55)];
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
    
    [self.view addSubview:self.waterMarkScrollView];
    self.waterMarkScrollView.hidden = YES;
    self.waterMarkScrollView.alpha = 0.0;

}

#pragma mark 底部“滤镜”、“标签”、“贴纸”的按钮点击方法
- (void)bottomButtonClick:(YBCustomButton *)sender
{
    self.bottomButton.selected  = NO;
    sender.selected = !sender.selected;
    self.bottomButton = sender;
    
//    // 底部的lineView转移位置
//    [self lineViewTransform:sender];
    
    // 根据当前的index切换底部的scrollView
    [self changeDecorateImageWithButtonTag:sender];
}

#pragma mark  标签按钮
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
    self.pasterScrollView.alpha = 0.0;
    self.pasterScrollView.hidden = YES;
}

- (void)cancelClick:(UIButton *)sender
{
    self.secView.hidden = YES;
    self.bottomBackView.hidden = NO;
    self.pasterScrollView.alpha = 0.0;
    self.pasterScrollView.hidden = YES;
    
}

#pragma mark - 标签添加
- (void)pasterTag:(NSInteger)pasterTag pasterImage:(UIImage *)pasterImage
{
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.pasterImageView];
    
    for (BatchView *view in self.batchScrollView.subviews) {
        if ([view isKindOfClass:[BatchView class]]) {StickerView *sricker = [[StickerView alloc] initWithContentFrame:CGRectMake(0, 0, 160, 45) contentImage:pasterImage];
            
            sricker.center = CGPointMake(view.frame.size.width/2, view.frame.size.height/2);
            sricker.enabledControl = NO;
            sricker.enabledBorder = NO;
            sricker.delegate = self;
            sricker.tag = self.imageIndex;
            [view addSubview:sricker];
            NSLog(@"sricker    %f",view.frame.size.height);
        }
    }
}
#pragma mark  水印点击
- (void)firstTag:(NSInteger)first
{
    MaterialListViewController *material = [[MaterialListViewController alloc] init];
//    material.orginalImage = self.originalImage;
    material.isWaterMark = @"waterMark";
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:material];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:YES completion:^{
        
    }];
}

- (void)waterMarkTag:(NSInteger)waterTag waterImage:(UIImage *)waterImage
{
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.pasterImageView];
    for (BatchView *view in self.batchScrollView.subviews) {
        if ([view isKindOfClass:[BatchView class]]) {StickerView *sricker = [[StickerView alloc] initWithContentFrame:CGRectMake(0, 0, 110, 110) contentImage:waterImage];
            
            sricker.center = CGPointMake(view.frame.size.width/2, view.frame.size.height/2);
            sricker.enabledControl = NO;
            sricker.enabledBorder = NO;
            sricker.delegate = self;
            sricker.tag = self.imageIndex;
            [view addSubview:sricker];
            NSLog(@"sricker    %f",view.frame.size.height);
        }
    }
}



- (void)sendTag:(NSInteger)firstTag
{
    MaterialListViewController *material = [[MaterialListViewController alloc] init];
//    material.orginalImage = self.originalImage;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:material];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:YES completion:^{
        
    }];
}

#pragma mark  底部选择
- (void)changeDecorateImageWithButtonTag:(YBCustomButton *)sender
{
    // 当前位置是水印
    if (sender.tag - 5000 == YBImagePaster) {
        [UIView animateWithDuration:.5 animations:^{
            self.waterMarkScrollView.alpha = 1.0;
            self.waterMarkScrollView.hidden = NO;
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
            self.waterMarkScrollView.alpha = 0.0;
            self.waterMarkScrollView.hidden = YES;
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
            self.waterMarkScrollView.alpha = 0.0;
            self.waterMarkScrollView.hidden = YES;
            
            if (self.pasterView) {
                [self.pasterView showBtn];
            }
            self.bottomBackView.hidden = YES;
            self.secView.hidden = NO;
        }];
    }
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
    self.batchScrollView.scrollEnabled = NO;
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.selectedSticker) {
        self.selectedSticker.enabledControl = NO;
        self.selectedSticker.enabledBorder = NO;
        self.selectedSticker = nil;
    }
    self.batchScrollView.scrollEnabled = YES;
}




#pragma mark  保存图片
- (UIImage *)doneEdit
{
    
    NSLog(@"self.batchScrollView.subviews ----   %lu",(unsigned long)self.batchScrollView.subviews.count);
    UIImage *imgCut = nil;
    for (BatchView *view in self.batchScrollView.subviews) {
        if ([view isKindOfClass:[BatchView class]]) {
            CGFloat org_width = SCREEN_WIDTH ;
            CGFloat org_heigh = 396 ;
            CGFloat rateOfScreen = org_width / org_heigh ;
            CGFloat inScreenH = SCREEN_WIDTH / rateOfScreen ;
            
            CGRect rect = CGRectZero ;
            rect.size = CGSizeMake(SCREEN_WIDTH, inScreenH) ;
            rect.origin = CGPointMake(0, (396 - inScreenH) / 2) ;
            UIImage *imgTemp = [UIImage getImageFromView:view] ;
            imgCut = [UIImage squareImageFromImage:imgTemp scaledToSize:rect.size.width] ;
            NSLog(@"imgCut   --------   %@",imgCut);
            [self loadImageFinished:imgCut];
        }
    }
    return imgCut;
}

- (void)loadImageFinished:(UIImage *)image
{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

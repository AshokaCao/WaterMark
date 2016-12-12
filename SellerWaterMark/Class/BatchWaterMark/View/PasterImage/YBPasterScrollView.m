//
//  YBPasterScrollView.m
//  SellerWaterMark
//
//  Created by yuemin3 on 2016/11/28.
//  Copyright © 2016年 hangzhou.cao. All rights reserved.
//

#import "YBPasterScrollView.h"
#import "MaterialListViewController.h"

#define defaultPasterImageW_H pasterScrollView_H - 2 * inset_space
/**底部scrollView的高*/
extern CGFloat pasterScrollView_H;
/**贴纸直接间隔距离*/
const CGFloat inset_space = 15;


@interface YBPasterScrollView ()

@end


@implementation YBPasterScrollView

/**
 *  重新自定义scrollView
 *
 *  @param pasterImageArray 底部贴纸的图片
 *
 *  @return 返回一个scrollView
 */
- (instancetype)initScrollViewWithPasterImageArray:(NSArray *)pasterImageArray
{
    if (self = [super init]) {
        
        self.pasterImageArray = pasterImageArray;
        self.pasterImage_W_H = pasterScrollView_H - inset_space * 2;
        
        [self setupUI];
        
    }
    return self;
}

/**
 *  设置UI
 */
- (void)setupUI
{
    for (int i = 0; i < self.pasterImageArray.count; i ++)
    {
        CGFloat pasterBtnW_H = self.pasterImage_W_H;
        UIButton *pasterBtn = [[UIButton alloc]init];
        pasterBtn.frame = CGRectMake((i+1)*inset_space + pasterBtnW_H*i, inset_space, pasterBtnW_H, pasterBtnW_H);
        if (i == 0) {
            [pasterBtn setBackgroundImage:[UIImage imageNamed:@"tab_all_list"] forState:UIControlStateNormal];
            pasterBtn.tag = 1051;
            [pasterBtn addTarget:self action:@selector(pasterClick:) forControlEvents:UIControlEventTouchUpInside];
        } else {
            [pasterBtn setImage:self.pasterImageArray[i - 1] forState:UIControlStateNormal];
            pasterBtn.layer.borderColor = [UIColor clearColor].CGColor;
            pasterBtn.layer.borderWidth = 0.5;
            pasterBtn.tag = 1000 + i - 1;
            [pasterBtn addTarget:self action:@selector(pasterClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        [self addSubview:pasterBtn];
    }
}

/**
 *  点击选取贴纸
 */
- (void)pasterClick:(UIButton *)sender
{
    if (sender.tag == 1051) {
//        MaterialListViewController *material = [[MaterialListViewController alloc] init];
//        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:material animated:YES completion:nil];
        [_pasterDelegate sendTag:1051];
        DLog(@"这是测试");
    } else {
        if (_pasterDelegate && [_pasterDelegate respondsToSelector:@selector(pasterTag:pasterImage:)]) {
            
            [_pasterDelegate pasterTag:sender.tag - 1000 pasterImage:[self.pasterImageArray objectAtIndex:sender.tag - 1000]];
        }
    }
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
}

@end

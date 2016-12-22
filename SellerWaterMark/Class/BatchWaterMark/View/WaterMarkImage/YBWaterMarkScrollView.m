//
//  YBWaterMarkScrollView.m
//  SellerWaterMark
//
//  Created by yuemin3 on 2016/12/22.
//  Copyright © 2016年 hangzhou.cao. All rights reserved.
//

#import "YBWaterMarkScrollView.h"

/**底部scrollView的高*/
extern CGFloat pasterScrollView_H;
/**贴纸直接间隔距离*/
const CGFloat water_space = 15;

@implementation YBWaterMarkScrollView

- (instancetype)initScrollViewWithWaterMarkImageArray:(NSArray *)waterMarkImageArray
{
    if (self = [super init]) {
        self.waterImageArray = waterMarkImageArray;
        self.waterImage_h_w = pasterScrollView_H - water_space * 2;
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI
{
    for (int i = 0; i < self.waterImageArray.count; i ++)
    {
        CGFloat pasterBtnW_H = self.waterImage_h_w;
        UIButton *pasterBtn = [[UIButton alloc]init];
        pasterBtn.frame = CGRectMake((i+1)*water_space + pasterBtnW_H*i, water_space, pasterBtnW_H, pasterBtnW_H);
        if (i == 0) {
            [pasterBtn setBackgroundImage:[UIImage imageNamed:@"tab_all_list"] forState:UIControlStateNormal];
            pasterBtn.tag = 1052;
            [pasterBtn addTarget:self action:@selector(waterMarkClick:) forControlEvents:UIControlEventTouchUpInside];
        } else {
            [pasterBtn setImage:self.waterImageArray[i - 1] forState:UIControlStateNormal];
            pasterBtn.layer.borderColor = [UIColor clearColor].CGColor;
            pasterBtn.layer.borderWidth = 0.5;
            pasterBtn.tag = 10000 + i - 1;
            [pasterBtn addTarget:self action:@selector(waterMarkClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        [self addSubview:pasterBtn];
    }

}

- (void)waterMarkClick:(UIButton *)sender
{
    if (sender.tag == 1052) {
        //        MaterialListViewController *material = [[MaterialListViewController alloc] init];
        //        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:material animated:YES completion:nil];
        [_waterDelegate firstTag:1052];
        DLog(@"这是测试");
    } else {
        if (_waterDelegate && [_waterDelegate respondsToSelector:@selector(waterMarkTag:waterImage:)]) {
            
            [_waterDelegate waterMarkTag:sender.tag - 10000 waterImage:[self.waterImageArray objectAtIndex:sender.tag - 10000]];
        }
    }
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
}
@end

//
//  BatchView.m
//  SellerWaterMark
//
//  Created by yuemin3 on 2016/12/27.
//  Copyright © 2016年 hangzhou.cao. All rights reserved.
//

#import "BatchView.h"

@interface BatchView ()

@property (nonatomic ,strong) UIImageView *batchImageView;

@end

@implementation BatchView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame]) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI
{
    UIImageView *batchImage = [[UIImageView alloc] initWithFrame:self.bounds];
    self.batchImageView = batchImage;
    [self addSubview:batchImage];
}

- (void)setBatchImage:(UIImage *)batchImage
{
    _batchImage = batchImage;
    if (batchImage) {
        self.batchImageView.image = self.batchImage;
        NSLog(@"    ----   %@",self.batchImage);
        //        [self.editBtn setBackgroundImage:pasterImage forState:UIControlStateNormal];
    }
}

- (void)setBatchImageWith:(UIImage *)image
{
    
}

@end

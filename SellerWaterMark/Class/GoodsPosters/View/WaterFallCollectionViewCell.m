//
//  WaterFallCollectionViewCell.m
//  SellerWaterMark
//
//  Created by AshokaCao on 2016/12/22.
//  Copyright © 2016年 hangzhou.cao. All rights reserved.
//

#import "WaterFallCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"

@implementation WaterFallCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setWaterFallWithModel:(LabelModel *)model
{
    NSString *url = [NSString stringWithFormat:@"%@",model.imgthum];
    [self.waterfallImageVIew setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"bianjitupian_bg"]];
}
- (void)setImageURL:(NSURL *)imageURL {
    _imageURL = imageURL;
}

@end

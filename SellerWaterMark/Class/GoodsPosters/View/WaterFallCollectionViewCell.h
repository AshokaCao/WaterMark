//
//  WaterFallCollectionViewCell.h
//  SellerWaterMark
//
//  Created by AshokaCao on 2016/12/22.
//  Copyright © 2016年 hangzhou.cao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LabelModel.h"

@interface WaterFallCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) NSURL *imageURL;
@property (weak, nonatomic) IBOutlet UIImageView *waterfallImageVIew;
- (void)setWaterFallWithModel:(LabelModel *)model;
@end

//
//  LabelListItemCollectionViewCell.h
//  SellerWaterMark
//
//  Created by yuemin3 on 2016/11/29.
//  Copyright © 2016年 hangzhou.cao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LabelModel.h"

@interface LabelListItemCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *simpleImageView;

- (void)setModelWith:(LabelModel *)model;

@end

//
//  LabelListItemCollectionViewCell.m
//  SellerWaterMark
//
//  Created by yuemin3 on 2016/11/29.
//  Copyright © 2016年 hangzhou.cao. All rights reserved.
//

#import "LabelListItemCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"
//#import "MJExtension.h"
//#import "EditListModel.h"

@implementation LabelListItemCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModelWith:(LabelModel *)model
{
    [self.simpleImageView setImageWithURL:[NSURL URLWithString:model.imgthum] placeholderImage:[UIImage imageNamed:@""]];
    
//    NSMutableArray *array = [EditListModel mj_objectArrayWithKeyValuesArray:model.imginfo];
//    for (EditListModel *mode in array) {
//        DLog(@"-----    %@'",mode.position);
//    }
}

@end

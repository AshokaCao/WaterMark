//
//  MainItemsCollectionViewCell.m
//  SellerWaterMark
//
//  Created by yuemin3 on 2016/11/21.
//  Copyright © 2016年 hangzhou.cao. All rights reserved.
//

#import "MainItemsCollectionViewCell.h"
#import "UIImage+AFNetworking.h"

@implementation MainItemsCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setItemImage:(NSString *)image andTitle:(NSString *)title
{
    [self.itemImage setImage:[UIImage imageNamed:image]];
    self.itemTitle.text = title;
}
@end

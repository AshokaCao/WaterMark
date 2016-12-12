//
//  MainItemsCollectionViewCell.h
//  SellerWaterMark
//
//  Created by yuemin3 on 2016/11/21.
//  Copyright © 2016年 hangzhou.cao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainItemsCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *itemImage;
@property (weak, nonatomic) IBOutlet UILabel *itemTitle;

- (void)setItemImage:(NSString *)image andTitle:(NSString *)title;

@end

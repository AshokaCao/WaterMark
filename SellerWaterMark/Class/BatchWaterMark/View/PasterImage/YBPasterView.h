//
//  YBPasterView.h
//  SellerWaterMark
//
//  Created by yuemin3 on 2016/11/28.
//  Copyright © 2016年 hangzhou.cao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YBPasterViewDelegate <NSObject>
@required;
@optional;
- (void)deleteThePaster;
- (void)editImageAction;
@end

@interface YBPasterView : UIView

/**YBPasterViewDelegate*/
@property (nonatomic,weak) id<YBPasterViewDelegate> delegate;
/**图片，所要加成贴纸的图片*/
@property (nonatomic, strong) UIImage *pasterImage;
/**隐藏“删除”和“缩放”按钮*/
- (void)hiddenBtn;
/**显示“删除”和“缩放”按钮*/
- (void)showBtn;
@end

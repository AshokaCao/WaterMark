//
//  YBWaterMarkScrollView.h
//  SellerWaterMark
//
//  Created by yuemin3 on 2016/12/22.
//  Copyright © 2016年 hangzhou.cao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YBWaterMarkScrollViewDelegate <NSObject>

- (void)waterMarkTag:(NSInteger )waterTag waterImage:(UIImage *)waterImage;
- (void)firstTag:(NSInteger )first;

@end

@interface YBWaterMarkScrollView : UIScrollView

/**贴纸名字数组*/
@property (nonatomic, copy) NSArray *waterNameArray;
/**贴纸图片数组*/
@property (nonatomic, copy) NSArray *waterImageArray;
/**贴纸的高和宽*/
@property (nonatomic, assign) CGFloat waterImage_h_w;

@property (nonatomic ,assign) id<YBWaterMarkScrollViewDelegate> waterDelegate;


- (instancetype)initScrollViewWithWaterMarkImageArray:(NSArray *)waterMarkImageArray;

@end

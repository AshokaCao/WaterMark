//
//  YBPasterScrollView.h
//  SellerWaterMark
//
//  Created by yuemin3 on 2016/11/28.
//  Copyright © 2016年 hangzhou.cao. All rights reserved.
//

#import <UIKit/UIKit.h>


//代理方法
@protocol YBPasterScrollViewDelegate <NSObject>
@required;
- (void)pasterTag:(NSInteger)pasterTag pasterImage:(UIImage *)pasterImage;
- (void)sendTag:(NSInteger )firstTag;
@optional;
@end


@interface YBPasterScrollView : UIScrollView

/**贴纸名字数组*/
@property (nonatomic, copy) NSArray *pasterNameArray;
/**贴纸图片数组*/
@property (nonatomic, copy) NSArray *pasterImageArray;
/**贴纸的高和宽*/
@property (nonatomic, assign) CGFloat pasterImage_W_H;
/**YBPasterScrollViewDelegate*/
@property (nonatomic,weak) id<YBPasterScrollViewDelegate> pasterDelegate;

/**
 *  创建添加贴纸页底部的scrollView
 *
 *  @param pasterImageArray 穿过来的图片名字数组
 *
 *  @return 返回创建的自定义scrollView
 */
- (instancetype)initScrollViewWithPasterImageArray:(NSArray *)pasterImageArray;


@end

//
//  MainWaterMarkViewController.h
//  SellerWaterMark
//
//  Created by yuemin3 on 2016/11/28.
//  Copyright © 2016年 hangzhou.cao. All rights reserved.
//

#import <UIKit/UIKit.h>

/**传给上个页面图片的block*/
typedef void(^PasterBlock)(UIImage *image);

@interface MainWaterMarkViewController : UIViewController

/**传数据的block*/
@property (nonatomic, copy) PasterBlock block;
/**从上页带回来的原始image*/
@property (nonatomic, strong) UIImage *originalImage;

@property (nonatomic ,strong) UIImage *editedImage;

/**
 *  初始化一个对象
 *
 *  @param name 名字
 *
 *  @return 自己
 */
- (instancetype)initWithName:(NSString *)name;
@end

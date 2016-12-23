//
//  ChoosePhotosViewController.h
//  SellerWaterMark
//
//  Created by yuemin3 on 2016/12/7.
//  Copyright © 2016年 hangzhou.cao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LabelModel.h"

@interface ChoosePhotosViewController : UIViewController
@property (nonatomic ,strong) NSString *isPuzzle;
@property (nonatomic ,assign) NSInteger photoCount;
@property (nonatomic ,strong) LabelModel *posterModel;

@end

//
//  LabelModel.h
//  SellerWaterMark
//
//  Created by yuemin3 on 2016/12/5.
//  Copyright © 2016年 hangzhou.cao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LabelModel : NSObject
@property (nonatomic ,strong) NSString *imgbig;
@property (nonatomic ,strong) NSString *imgthum;
@property (nonatomic ,assign) int num;
@property (nonatomic ,strong) NSString *category;
@property (nonatomic ,strong) NSString *fdi;
@property (nonatomic ,strong) NSArray *imginfo;
@property (nonatomic ,strong) NSString *title;
@property (nonatomic ,strong) NSString *thumheight;
@property (nonatomic ,strong) NSString *thumwidth;

@end

//
//  WaterMarkDealTool.h
//  SellerWaterMark
//
//  Created by yuemin3 on 2016/12/5.
//  Copyright © 2016年 hangzhou.cao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EditorLabelModel.h"

@interface WaterMarkDealTool : NSObject

+ (NSArray *)imageDeals:(int)page;

+ (void)addImageDeals:(EditorLabelModel *)deal;

+ (void)removeImageDeals:(EditorLabelModel *)deal;

+ (BOOL)isCollected:(EditorLabelModel *)deal;

@end

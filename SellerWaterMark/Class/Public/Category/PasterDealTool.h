//
//  PasterDealTool.h
//  SellerWaterMark
//
//  Created by yuemin3 on 2016/12/22.
//  Copyright © 2016年 hangzhou.cao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EditorLabelModel.h"

@interface PasterDealTool : NSObject


+ (NSArray *)imageDeals:(int)page;

+ (void)addPasterImageDeals:(EditorLabelModel *)deal;

+ (void)removePasterImageDeals:(EditorLabelModel *)deal;

+ (BOOL)isPasterCollected:(EditorLabelModel *)deal;


@end

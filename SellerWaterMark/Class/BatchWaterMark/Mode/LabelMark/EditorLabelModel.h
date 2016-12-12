//
//  EditorLabelModel.h
//  SellerWaterMark
//
//  Created by yuemin3 on 2016/12/5.
//  Copyright © 2016年 hangzhou.cao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EditorLabelModel : NSObject
@property (nonatomic ,strong) NSData *imageData;
@property (nonatomic ,strong) NSData *editImage;
@property (nonatomic ,strong) NSString *imageText;
@property (nonatomic ,assign) int num;

@end

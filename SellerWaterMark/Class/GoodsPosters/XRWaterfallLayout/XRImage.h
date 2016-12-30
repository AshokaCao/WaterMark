//
//  XRImage.h
//  XRWaterfallLayoutDemo
//
//  Created by ibos on 16/3/29.
//  Copyright © 2016年 XR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LabelModel.h"
@interface XRImage : NSObject
@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, assign) CGFloat imageW;
@property (nonatomic, assign) CGFloat imageH;

+ (instancetype)imageWithImageDic:(LabelModel *)imageDic;
@end

//
//  XRImage.m
//  XRWaterfallLayoutDemo
//
//  Created by ibos on 16/3/29.
//  Copyright © 2016年 XR. All rights reserved.
//

#import "XRImage.h"

@implementation XRImage
+ (instancetype)imageWithImageDic:(LabelModel *)imageDic {
    XRImage *image = [[XRImage alloc] init];
    image.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",imageDic.imgthum]];
    image.imageW = [[NSString stringWithFormat:@"%@",imageDic.thumwidth] floatValue];
    image.imageH = [[NSString stringWithFormat:@"%@",imageDic.thumheight] floatValue];
    return image;
}
@end

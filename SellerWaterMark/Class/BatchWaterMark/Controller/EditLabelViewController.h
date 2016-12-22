//
//  EditLabelViewController.h
//  SellerWaterMark
//
//  Created by yuemin3 on 2016/11/30.
//  Copyright © 2016年 hangzhou.cao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LabelModel.h"

@protocol EditLabelViewControllerDelegate <NSObject>

- (void)sendEditedImagge:(UIImage *)image;

@end

@interface EditLabelViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *backGroupImageView;
@property (weak, nonatomic) IBOutlet UIView *backGroupView;
@property (nonatomic ,strong) LabelModel *editModel;
@property (nonatomic ,strong) UIImage *originalImage;
@property (nonatomic ,strong) NSString *isWaterMark;

@property (nonatomic ,assign) id<EditLabelViewControllerDelegate> delegate;


@end

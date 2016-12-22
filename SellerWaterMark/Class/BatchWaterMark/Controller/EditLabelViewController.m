//
//  EditLabelViewController.m
//  SellerWaterMark
//
//  Created by yuemin3 on 2016/11/30.
//  Copyright © 2016年 hangzhou.cao. All rights reserved.
//

#import "EditLabelViewController.h"
#import "UIView+Extension.h"
#import "MainWaterMarkViewController.h"
#import "EditListModel.h"
#import "MJExtension.h"
#import "WaterMarkDealTool.h"
#import "PasterDealTool.h"
#import "UIImageView+AFNetworking.h"

@interface EditLabelViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *labelTextField;
@property (weak, nonatomic) IBOutlet UILabel *labelLa;
@property (nonatomic ,strong) UILabel *editText;
@property (nonatomic ,strong) UIImageView *compositeImageView;
@property (nonatomic ,strong) EditListModel *listModel;

@end

@implementation EditLabelViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.backGroupImageView.image = self.originalImage;
    NSMutableArray *array = [EditListModel  mj_objectArrayWithKeyValuesArray:self.editModel.imginfo];
    self.listModel = [array firstObject];
    DLog(@"position     %@",_listModel.position);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setNavigationTitle];
    [self setEditImageView];
    [self.labelTextField addTarget:self action:@selector(changeClick:) forControlEvents:UIControlEventEditingChanged];
}
#pragma mark 导航栏标题 按钮
- (void)setNavigationTitle
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    UIView *naTitleView = [[UIView alloc] initWithFrame:CGRectMake(50, 0, SCREEN_WIDTH - 180, 20)];
    naTitleView.backgroundColor = [UIColor clearColor];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, naTitleView.frame.size.width, naTitleView.frame.size.height)];
    if ([self.isWaterMark isEqualToString:@"waterMark"]) {
        [title setText:ASLocalizedString(@"水印编辑")];
    } else {
        [title setText:ASLocalizedString(@"标签编辑")];
    }
    [title setTextColor:[UIColor whiteColor]];
    title.textAlignment = NSTextAlignmentCenter;
    [naTitleView addSubview:title];
    self.navigationItem.titleView = naTitleView;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(14, 0, 70, 50);
    [button setTitle:@"返回" forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"photo_navi_back"] forState:UIControlStateNormal];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0,0.0, 0)];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 7, 0, 0)];
    [button addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(14, 0, 70, 50);
    [rightBtn setTitle:@"生成" forState:UIControlStateNormal];
    [rightBtn setTitleColor:RGB_COLOR(220, 50, 92, 1) forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(saveClick:) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
}

- (void)setEditImageView
{
    // 本地获取image
    NSData *JSONData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ren" ofType:@"json"]];
    NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"marginInset : %@",diction[@"marginInset"]);
    NSString *str = diction[@"marginInset"];
    NSString *nowStr = [str substringWithRange:NSMakeRange(1, str.length - 2)];
    NSArray *imagePoint = [nowStr componentsSeparatedByString:@","];
   
    NSLog(@"images.size.width   %f",self.backGroupView.constraints[1].constant);
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 100 , self.backGroupView.constraints[0].constant / 2 - 50, 200, 50)];
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setImageWithURL:[NSURL URLWithString:self.editModel.imgbig]];
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:diction[@"image"]]];
    
    self.compositeImageView = imageView;
//    imageView.image = [UIImage imageNamed:diction[@"image"]];
    imageView.size = CGSizeMake(237/2, 100/2);
    [self.backGroupView addSubview:imageView];
    imageView.center = CGPointMake(SCREEN_WIDTH / 2, self.backGroupView.constraints[0].constant / 2);
    
    
    UILabel *text = [[UILabel alloc] init];
    text.size = CGSizeMake([imagePoint[2] intValue], [imagePoint[3] intValue]);
    text.centerX = imageView.width / 2;
    text.centerY = imageView.height / 2;
    NSLog(@"SCREEN_WIDTH / 2  %f  self.backGroupView.constraints[0].constant / 2  %f",imageView.width / 2,self.backGroupView.constraints[0].constant / 2);
    text.textColor = [UIColor redColor];
//    text.backgroundColor = [UIColor blueColor];
    text.textAlignment = NSTextAlignmentCenter;
    text.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    text.adjustsFontSizeToFitWidth = YES;
    self.editText = text;
    [imageView addSubview:text];
}

- (void)backClick:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)saveClick:(UIButton *)sender
{
    UIImage *saveImage = [self imageWithUIView:self.compositeImageView];
    self.compositeImageView.image = saveImage;
//    [self.delegate sendEditedImagge:saveImage];
    MainWaterMarkViewController *mainMark = [[MainWaterMarkViewController alloc] init];
    mainMark.editedImage = saveImage;
    DLog(@"self.editText.text - %@",self.editText.text);
//    [self.navigationController pushViewController:mainMark animated:YES];
    mainMark.originalImage = self.originalImage;
    
    NSData *_data = UIImagePNGRepresentation(saveImage);
    //将图片的data转化为字符串
//    NSString *strimage64 = [_data enco];
    
    NSDictionary *imageDic = [NSDictionary dictionaryWithObject:_data forKey:@"downloadImage"];
    if ([self.isWaterMark isEqualToString:@"waterMark"]) {
        [WaterMarkDealTool initialize];
        EditorLabelModel *model = [[EditorLabelModel alloc] init];
        model.editImage =  _data;
        [WaterMarkDealTool addImageDeals:model];
    } else {
        [PasterDealTool initialize];
        EditorLabelModel *model = [[EditorLabelModel alloc] init];
        model.editImage =  _data;
        [PasterDealTool addPasterImageDeals:model];
    }
    [nNotification postNotificationName:@"downloadImage" object:nil userInfo:imageDic];
    [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage*) imageWithUIView:(UIView*) view
{
    UIGraphicsBeginImageContext(view.bounds.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:ctx];
    UIImage* tImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return tImage;
}

//- (void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    self.editText.text = self.labelTextField.text;
//}
//
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
//{
//    self.editText.text = self.labelTextField.text;
//    return YES;
//}

- (void)changeClick:(UITextField *)center
{
    self.editText.text = self.labelTextField.text;
    NSLog(@"%@",center.text);
}

//- (BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    NSLog(@"%@",textField.text);
//    self.editText.text = self.labelTextField.text;
//    return YES;
//}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  PuzzleViewController.m
//  SellerWaterMark
//
//  Created by yuemin3 on 2016/12/8.
//  Copyright © 2016年 hangzhou.cao. All rights reserved.
//

#import "PuzzleViewController.h"
#import "UIColor+Help.h"

@interface PuzzleViewController ()
@property (weak, nonatomic) IBOutlet UIView *backGroupView;
@property (weak, nonatomic) IBOutlet UIButton *photoTypeBtn;
@property (weak, nonatomic) IBOutlet UIButton *photoBackColorBtn;
@property (weak, nonatomic) IBOutlet UIButton *photoBorderBtn;
@property (weak, nonatomic) IBOutlet UIImageView *typeLine;
@property (weak, nonatomic) IBOutlet UIImageView *colorLint;
@property (weak, nonatomic) IBOutlet UIImageView *borderLine;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end

@implementation PuzzleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#181b20"];
    [self setNavigationTitle];
    [self setUpBotton];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark 导航栏标题 按钮
- (void)setNavigationTitle
{
    UIView *naTitleView = [[UIView alloc] initWithFrame:CGRectMake(50, 0, SCREEN_WIDTH - 180, 20)];
    naTitleView.backgroundColor = [UIColor clearColor];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, naTitleView.frame.size.width, naTitleView.frame.size.height)];
    [title setText:ASLocalizedString(@"简洁拼图")];
    [title setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:18]];
    [title setTextColor:[UIColor whiteColor]];
    title.textAlignment = NSTextAlignmentCenter;
    [naTitleView addSubview:title];
    self.navigationItem.titleView = naTitleView;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(14, 0, 70, 50);
    [button setTitle:ASLocalizedString(@"返回") forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"photo_navi_back"] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0,0.0, 0)];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 7, 0, 0)];
    [button addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(14, 0, 70, 50);
    [rightBtn setTitle:@"保存" forState:UIControlStateNormal];
    [rightBtn setTitleColor:RGB_COLOR(220, 50, 92, 1) forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(saveClick:) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
}

- (void)backClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveClick:(UIButton *)sender
{
    
}

- (IBAction)photoTypeAction:(UIButton *)sender {
    self.photoTypeBtn.selected = YES;
    self.photoBorderBtn.selected = self.photoBackColorBtn.selected = NO;
    [self bottomLineIsHidden];
}

- (IBAction)photoBackColorAction:(UIButton *)sender {
    self.photoBackColorBtn.selected = YES;
    self.photoBorderBtn.selected = self.photoTypeBtn.selected = NO;
    [self bottomLineIsHidden];
}

- (IBAction)photoBorderAction:(UIButton *)sender {
    self.photoBorderBtn.selected = YES;
    self.photoTypeBtn.selected = self.photoBackColorBtn.selected = NO;
    [self bottomLineIsHidden];
}

- (void)bottomLineIsHidden
{
    if ([self.photoTypeBtn isSelected]) {
        self.typeLine.hidden = NO;
        self.borderLine.hidden = self.colorLint.hidden = YES;
    }
    if ([self.photoBackColorBtn isSelected]) {
        self.colorLint.hidden = NO;
        self.borderLine.hidden = self.typeLine.hidden = YES;
    }
    if ([self.photoBorderBtn isSelected]) {
        self.borderLine.hidden = NO;
        self.typeLine.hidden = self.colorLint.hidden = YES;
    }
}





- (void)setUpBotton
{
    [self.photoTypeBtn setTitle:ASLocalizedString(@"样式") forState:UIControlStateNormal];
    [self.photoBackColorBtn setTitle:ASLocalizedString(@"背景") forState:UIControlStateNormal];
    [self.photoBorderBtn setTitle:ASLocalizedString(@"边框") forState:UIControlStateNormal];
}

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

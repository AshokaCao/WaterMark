//
//  GoodsPosterViewController.m
//  SellerWaterMark
//
//  Created by yuemin3 on 2016/12/22.
//  Copyright © 2016年 hangzhou.cao. All rights reserved.
//

#import "GoodsPosterViewController.h"
#import "UIColor+Help.h"
#import "UIImageView+AFNetworking.h"
#import "GoodsPosterModel.h"

@interface GoodsPosterViewController ()
@property (weak, nonatomic) IBOutlet UIView *imageBackgroudView;
@property (weak, nonatomic) IBOutlet UIButton *templateBtn;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIImageView *templateLine;
@property (weak, nonatomic) IBOutlet UIImageView *backLine;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;
@property (nonatomic ,strong) NSMutableArray *imageLocation;
@property (nonatomic ,strong) NSMutableArray *textLocation;

@end

@implementation GoodsPosterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationTitle];
    [self setUpUI];
    // Do any additional setup after loading the view from its nib.
}


#pragma mark 导航栏标题 按钮
- (void)setNavigationTitle
{
    self.navigationController.navigationBarHidden = NO;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#181b20"];
    UIView *naTitleView = [[UIView alloc] initWithFrame:CGRectMake(50, 0, SCREEN_WIDTH - 180, 20)];
    naTitleView.backgroundColor = [UIColor clearColor];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, naTitleView.frame.size.width, naTitleView.frame.size.height)];
    [title setText:ASLocalizedString(@"产品海报")];
    [title setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:18]];
    [title setTextColor:[UIColor colorWithHexString:@"#ffffff"]];
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
    [rightBtn setTitle:ASLocalizedString(@"保存") forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor colorWithHexString:@"#f00659"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(photoClick:) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
}

- (void)setUpUI
{
    self.imageLocation = [NSMutableArray array];
    self.textLocation = [NSMutableArray array];
    self.imageBackgroudView.backgroundColor = [UIColor whiteColor];
    [self.posterImageView setImageWithURL:[NSURL URLWithString:self.posterModel.imgbig]];
    // 本地获取image
    NSData *JSONData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"patterns_1" ofType:@"json"]];
    NSArray *diction = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:nil];
    
    for (NSDictionary *dic in diction) {
//        NSLog(@"diction : %@",dic);
        GoodsPosterModel *model = [[GoodsPosterModel alloc] init];
        [model setValuesForKeysWithDictionary:dic[@"info"]];
        NSLog(@"model.isImage   %d",model.isImage);
        if (model.isImage) {
            [self.imageLocation addObject:model];
        } else {
            [self.textLocation addObject:model];
        }
    }
//    NSLog(@"marginInset : %@",self.imageLocation);
//    NSString *str = diction[@"marginInset"];
//    NSString *nowStr = [str substringWithRange:NSMakeRange(1, str.length - 2)];
//    NSArray *imagePoint = [nowStr componentsSeparatedByString:@","];
}

- (void)backClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)photoClick:(UIButton *)sender
{
    
}

- (IBAction)templateAction:(UIButton *)sender {
}

- (IBAction)backGrouAction:(UIButton *)sender {
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

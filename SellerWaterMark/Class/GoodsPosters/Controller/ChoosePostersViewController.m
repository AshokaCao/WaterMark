//
//  ChoosePostersViewController.m
//  SellerWaterMark
//
//  Created by yuemin3 on 2016/12/22.
//  Copyright © 2016年 hangzhou.cao. All rights reserved.
//

#import "ChoosePostersViewController.h"
#import "UIColor+Help.h"
#import "XRWaterfallLayout.h"
#import "XRImage.h"
#import "WaterFallCollectionViewCell.h"
#import "AFNetworking.h"
#import "LabelModel.h"
#import "GoodsPosterViewController.h"
#import "ChoosePhotosViewController.h"

@interface ChoosePostersViewController () <XRWaterfallLayoutDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) NSMutableArray<XRImage *> *imageArray;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *waterCollecationView;
@property (nonatomic, strong) NSMutableArray *waterListArray;
@end

@implementation ChoosePostersViewController

- (NSMutableArray *)imageArray {
    //从plist文件中取出字典数组，并封装成对象模型，存入模型数组中
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"1.plist" ofType:nil];
        NSArray *imageDics = [NSArray arrayWithContentsOfFile:path];
        for (NSDictionary *imageDic in imageDics) {
            XRImage *image = [XRImage imageWithImageDic:imageDic];
            [_imageArray addObject:image];
        }
    }
    return _imageArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationTitle];
    [self waterfallList];
    [self waterfall];
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
    [title setText:ASLocalizedString(@"选择海报")];
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
}

- (void)waterfall
{
    XRWaterfallLayout *fallLayout = [XRWaterfallLayout waterFallLayoutWithColumnCount:3];
    [fallLayout setColumnSpacing:10 rowSpacing:10 sectionInset:UIEdgeInsetsMake(10, 10, 10, 10)];
    
    //设置代理，实现代理方法
    fallLayout.delegate = self;
    
    //创建collectionView
//    [self.waterCollecationView setCollectionViewLayout:fallLayout];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 32, SCREEN_WIDTH, SCREEN_HEIGHT - 64) collectionViewLayout:fallLayout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerNib:[UINib nibWithNibName:@"WaterFallCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"waterFall"];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.view addSubview:self.collectionView];
}

//根据item的宽度与indexPath计算每一个item的高度
- (CGFloat)waterfallLayout:(XRWaterfallLayout *)waterfallLayout itemHeightForWidth:(CGFloat)itemWidth atIndexPath:(NSIndexPath *)indexPath {
    //根据图片的原始尺寸，及显示宽度，等比例缩放来计算显示高度
    XRImage *image = self.imageArray[indexPath.item];
    return image.imageH / image.imageW * itemWidth;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.waterListArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WaterFallCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"waterFall" forIndexPath:indexPath];
    LabelModel *model = self.waterListArray[indexPath.row];
    [cell setWaterFallWithModel:model];
//    cell.imageURL = self.imageArray[indexPath.item].imageURL;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    GoodsPosterViewController *view = [[GoodsPosterViewController alloc] init];
//    [self.navigationController pushViewController:view animated:YES];
    
    LabelModel *model = self.waterListArray[indexPath.row];
    NSInteger photoCount = model.imginfo.count;
    ChoosePhotosViewController *chooseView = [[ChoosePhotosViewController alloc] init];
    chooseView.posterModel = model;
    chooseView.photoCount = photoCount;
    [self.navigationController pushViewController:chooseView animated:YES];
}

- (void)backClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark 列表
- (void)waterfallList
{
    self.waterListArray = [NSMutableArray array];
    NSString *waterUrl = [NSString stringWithFormat:@"http://%@/Camera/list.ashx?fdi=1005",tLocalUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:waterUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *waterArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"waterArray   %@",waterArray);
        for (NSDictionary *diction in waterArray) {
            LabelModel *model = [[LabelModel alloc] init];
            [model setValuesForKeysWithDictionary:diction];
            [self.waterListArray addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
        NSLog(@"waterListArray   %@",self.waterListArray);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
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

//
//  MaterialListViewController.m
//  SellerWaterMark
//
//  Created by yuemin3 on 2016/11/29.
//  Copyright © 2016年 hangzhou.cao. All rights reserved.
//

#import "MaterialListViewController.h"
#import "LabelListItemCollectionViewCell.h"
#import "EditLabelViewController.h"
#import "AFNetworking.h"
#import "LabelModel.h"

@interface MaterialListViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *labelCollectionView;
@property (nonatomic ,strong) NSMutableArray *listArray;


@end

@implementation MaterialListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor blackColor];
    
    // Do any additional setup after loading the view from its nib.
    [self setNavigationTitle];
    [self.labelCollectionView registerNib:[UINib nibWithNibName:@"LabelListItemCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cellItem"];
    [self setLabelCollection];
    [self setListForLabel];
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
    [title setText:@"添加标签"];
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
}
#pragma mark collection
- (void)setLabelCollection
{
    [self.labelCollectionView registerNib:[UINib nibWithNibName:@"LabelListItemCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"labelItem"];
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    DLog(@"%f",SCREEN_WIDTH);
    flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH - 32) / 3,(SCREEN_WIDTH - 32) / 3);
    flowLayout.minimumInteritemSpacing = 8;
    flowLayout.minimumLineSpacing = 8;
    
    self.labelCollectionView.collectionViewLayout = flowLayout;
//    [self.labelCollectionView setBackgroundColor:[UIColor whiteColor]];
    self.labelCollectionView.alwaysBounceVertical = YES;
    self.labelCollectionView.showsVerticalScrollIndicator = NO;
    self.labelCollectionView.showsHorizontalScrollIndicator = NO;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.listArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LabelListItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"labelItem" forIndexPath:indexPath];
    LabelModel *model = self.listArray[indexPath.row];
    [cell setModelWith:model];
    
    return cell;
}
//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (SCREEN_WIDTH > 320) {
        return UIEdgeInsetsMake(8, 8, 8, 8);
    } else {
        return UIEdgeInsetsMake(8, 8, 8, 8);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    EditLabelViewController *editV = [[EditLabelViewController alloc] init];
    editV.editModel = self.listArray[indexPath.row];
    editV.originalImage = self.orginalImage;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:editV];
//    [[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:NO completion:^{
//        
//    }];
    [self presentViewController:nav animated:YES completion:^{
        
    }];
}

- (void)backClick:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark 网络请求
- (void)setListForLabel
{
    self.listArray = [NSMutableArray array];
    NSString *labelUrl = [NSString stringWithFormat:@"http://%@/Camera/list.ashx?fdi=1003",tLocalUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:labelUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *labelArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        if (labelArray.count < 1) {
            
        } else {
            for (NSDictionary *dict in labelArray) {
                LabelModel *model = [[LabelModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [self.listArray addObject:model];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.labelCollectionView reloadData];
            });
        }
        
        DLog(@"labelArray : %@",labelArray);
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

//
//  MainViewViewController.m
//  SellerWaterMark
//
//  Created by yuemin3 on 2016/11/21.
//  Copyright © 2016年 hangzhou.cao. All rights reserved.
//

#import "MainViewViewController.h"
#import "MainItemsCollectionViewCell.h"
#import "SDCycleScrollView.h"
#import "LogingViewController.h"
#import "MainWaterMarkViewController.h"
//#import "TestViewController.h"
#import "ChoosePhotosViewController.h"
#import "ChoosePostersViewController.h"

@interface MainViewViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, SDCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *mainCollectionView;

@end

@implementation MainViewViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES] ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    self.view.backgroundColor = [UIColor orangeColor];
    // Do any additional setup after loading the view from its nib.
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    DLog(@"%f",SCREEN_WIDTH);
    flowLayout.itemSize = CGSizeMake(120,160);
    if (SCREEN_WIDTH > 375) {
        flowLayout.minimumInteritemSpacing = 42;
        flowLayout.minimumLineSpacing = 42;
    } else {
        flowLayout.itemSize = CGSizeMake(105,160);
        flowLayout.minimumInteritemSpacing = 21;
        flowLayout.minimumLineSpacing = 21;
    }
    //    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
//    self.mai = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 154) collectionViewLayout:flowLayout];
//    _hotCollocation.dataSource = self;
//    _hotCollocation.delegate = self;
    self.mainCollectionView.collectionViewLayout = flowLayout;
    [self.mainCollectionView setBackgroundColor:[UIColor whiteColor]];
    self.mainCollectionView.alwaysBounceVertical = YES;
    self.mainCollectionView.showsVerticalScrollIndicator = NO;
    self.mainCollectionView.showsHorizontalScrollIndicator = NO;
//    self.mainCollectionView.tr
    [_mainCollectionView registerNib:[UINib nibWithNibName:@"MainItemsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"mainCell"];
    [self setSDCycleScrollView];
    [self setUserAction];
}

#pragma mark userAction
- (void)setUserAction
{
    UIButton *butto = [UIButton buttonWithType:UIButtonTypeCustom];
    butto.frame = CGRectMake(SCREEN_WIDTH - 42, 29, 28, 28);
//    butto.backgroundColor = [UIColor redColor];
    [butto setImage:[UIImage imageNamed:@"user_set_icon"] forState:UIControlStateNormal];
    [self.view addSubview:butto];
    [butto addTarget:self action:@selector(logingClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)logingClick:(UIButton *)sender
{
    LogingViewController *logView = [LogingViewController new];
    [self presentViewController:logView animated:YES completion:nil];
}

#pragma mark 轮播图
- (void)setSDCycleScrollView
{
    SDCycleScrollView *cycleScrollView3 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 221) delegate:self placeholderImage:[UIImage imageNamed:@"home_banner"]];
    cycleScrollView3.backgroundColor = [UIColor clearColor];
    cycleScrollView3.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    cycleScrollView3.currentPageDotImage = [UIImage imageNamed:@"point_selected"];
    cycleScrollView3.pageDotImage = [UIImage imageNamed:@"point_default"];
//    cycleScrollView3.imageURLStringsGroup = imageArray;
    NSArray *array = @[@"home_banner",@"home_banner",@"home_banner"];
    cycleScrollView3.localizationImageNamesGroup = array;
    
    [self.view addSubview:cycleScrollView3];
}
#pragma mark SDCycleScrollViewDelegate
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"==5");
}

//#pragma mark --UICollectionViewDelegateFlowLayout
////定义每个UICollectionView 的大小
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CGSizeMake((self.view.frame.size.width)/2, (self.view.frame.size.height - 221) / 2);
//}

//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (SCREEN_WIDTH > 320) {
        return UIEdgeInsetsMake(68, 55, 10, 55);
    } else {
        return UIEdgeInsetsMake(30, 27, 10, 27);
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MainItemsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"mainCell" forIndexPath:indexPath];
    NSArray *itemImage = @[@"camera_photo_icon",@"batch_water_icon",@"easy_puzzle_icon",@"goods_posters_icon"];
    NSArray *itemTitle = @[ASLocalizedString(@"拍照水印"),ASLocalizedString(@"批量水印"),ASLocalizedString(@"简洁拼图"),ASLocalizedString(@"商品海报")];
    [cell setItemImage:itemImage[indexPath.row] andTitle:itemTitle[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)indexPath.row);
    switch (indexPath.row) {
        case 0: {
            UIImagePickerControllerSourceType type = UIImagePickerControllerSourceTypePhotoLibrary;
            if([UIImagePickerController isSourceTypeAvailable:type]){
                if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
                    type = UIImagePickerControllerSourceTypeCamera;
                }
                
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.allowsEditing = YES;
                picker.delegate   = self;
                picker.sourceType = type;
                
                [self presentViewController:picker animated:YES completion:nil];
//                [self.navigationController popToViewController:picker animated:YES];
            }
        }
            break;
            
        case 1: {
            
            MainWaterMarkViewController *waterMark = [MainWaterMarkViewController new];
            waterMark.originalImage = [UIImage imageNamed:@"bianjitupian_bg"];
            [self.navigationController pushViewController:waterMark animated:YES];
        }
            break;
            
        case 2: {
            ChoosePhotosViewController *chooseView = [[ChoosePhotosViewController alloc] init];
            chooseView.isPuzzle = @"puzzle";
            [self.navigationController pushViewController:chooseView animated:YES];
        }
            break;
            
        case 3: {
            ChoosePostersViewController *chooseView = [[ChoosePostersViewController alloc] init];
            [self.navigationController pushViewController:chooseView animated:YES];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark- ImagePicker delegate

//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//{
//    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
//    
////    CLImageEditor *editor = [[CLImageEditor alloc] initWithImage:image];
////    editor.delegate = self;
////    
////    [picker pushViewController:editor animated:YES];
//    NSLog(@"%@",image);
//    MainWaterMarkViewController *waterMark = [MainWaterMarkViewController new];
//    waterMark.originalImage = image;
//    
//    waterMark.block = ^(UIImage *editedImage){
////        self.imageView.image = editedImage;
//    };
//    [picker pushViewController:waterMark animated:YES];
////    TestViewController *test = [TestViewController new];
////    test.image = image;
////    [picker pushViewController:test animated:YES];
//}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    NSLog(@"选择完毕----image:%@-----info:%@",image,editingInfo);
    
    [self dismissViewControllerAnimated:NO completion:^{
        MainWaterMarkViewController *waterMark = [MainWaterMarkViewController new];
        waterMark.originalImage = image;
        [self.navigationController pushViewController:waterMark animated:YES];
    }];
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

#pragma mark 

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

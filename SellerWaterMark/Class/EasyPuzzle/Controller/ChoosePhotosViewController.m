//
//  ChoosePhotosViewController.m
//  SellerWaterMark
//
//  Created by yuemin3 on 2016/12/7.
//  Copyright © 2016年 hangzhou.cao. All rights reserved.
//

#import "ChoosePhotosViewController.h"
#import "ChoosePictureCollectionViewCell.h"
#import "PhotosCollectionViewCell.h"
#import "PuzzleViewController.h"
#import "GoodsPosterViewController.h"
#import "BatchPhotoViewController.h"
#import "UIColor+Help.h"
#import "UIButton+Help.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

@interface ChoosePhotosViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *choosePictureCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *photoCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *chooseCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *beginBtn;

@property (nonatomic ,strong) NSMutableArray *pictureArray;
@property (nonatomic ,strong) NSMutableArray *photoArray;
@property (nonatomic ,strong) NSMutableArray *indexArray;
@property (nonatomic ,strong) NSMutableArray *originalPhoto;

@end

@implementation ChoosePhotosViewController

- (NSMutableArray *)pictureArray
{
    if (!_pictureArray) {
        _pictureArray = [NSMutableArray array];
    }
    return _pictureArray;
}

- (NSMutableArray *)originalPhoto
{
    if (!_originalPhoto) {
        _originalPhoto = [NSMutableArray array];
    }
    return _originalPhoto;
}

//- (NSMutableArray *)photoArray
//{
//    if (!_photoArray) {
//        _photoArray = [NSMutableArray array];
//    }
//    return _photoArray;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = ASLocalizedString(@"简洁拼图");
    self.navigationController.navigationBarHidden = NO;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavigationTitle];
    [self initChoosePictureCollectionView];
    [self initPhotoCollectionView];
    self.photoArray = [NSMutableArray array];
    self.indexArray = [NSMutableArray array];
    [self takePictureFromAlbum];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark 导航栏标题 按钮
- (void)setNavigationTitle
{
    UIView *naTitleView = [[UIView alloc] initWithFrame:CGRectMake(50, 0, SCREEN_WIDTH - 180, 20)];
    naTitleView.backgroundColor = [UIColor clearColor];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, naTitleView.frame.size.width, naTitleView.frame.size.height)];
    if ([self.isPuzzle isEqualToString:@"puzzle"]) {
        [title setText:ASLocalizedString(@"简洁拼图")];
    } else if ([self.isPuzzle isEqualToString:@"batch"]) {
        [title setText:ASLocalizedString(@"选择图片")];
    } else {
        [title setText:ASLocalizedString(@"选择图片")];
    }
    [title setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:18]];
    [title setTextColor:[UIColor colorWithHexString:@"#333333"]];
    title.textAlignment = NSTextAlignmentCenter;
    [naTitleView addSubview:title];
    self.navigationItem.titleView = naTitleView;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(7, 0, 70, 50);
    [button setTitle:ASLocalizedString(@"返回") forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"data_navi_back"] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0,0.0, 0)];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 7, 0, 0)];
    [button addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItems = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    UIBarButtonItem *nagetiveSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    nagetiveSpacer.width = -14;//这个值可以根据自己需要自己调整
    self.navigationItem.leftBarButtonItems = @[nagetiveSpacer, leftBarButtonItems];
    
    
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(7, 0, 70, 50);
    [rightBtn setImage:[UIImage imageNamed:@"puzzle_navi_photo"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(photoClick:) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
}

- (void)backClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)photoClick:(UIButton *)sender
{
    
}

- (IBAction)beginAction:(UIButton *)sender {
    if ([self.isPuzzle isEqualToString:@"puzzle"]) {
        PuzzleViewController *puzzle = [[PuzzleViewController alloc] init];
        NSMutableArray *imageArray = [NSMutableArray array];
        for (NSIndexPath *index in self.indexArray) {
            [imageArray addObject:self.originalPhoto[index.row]];
        }
        puzzle.imageArray = imageArray;
//        NSLog(@"imageArray - %@",imageArray);
        [self.navigationController pushViewController:puzzle animated:YES];
    } else if ([self.isPuzzle isEqualToString:@"batch"]) {
        NSLog(@"lksjflksj");
        BatchPhotoViewController *batch = [[BatchPhotoViewController alloc] init];NSMutableArray *imageArray = [NSMutableArray array];
        for (NSIndexPath *index in self.indexArray) {
            [imageArray addObject:self.originalPhoto[index.row]];
        }
        batch.imageArray = imageArray;
        [self.navigationController pushViewController:batch animated:YES];
    } else {
        GoodsPosterViewController *poster = [[GoodsPosterViewController alloc] init];
        NSMutableArray *imageArray = [NSMutableArray array];
        for (NSIndexPath *index in self.indexArray) {
            [imageArray addObject:self.originalPhoto[index.row]];
        }
        poster.posterModel = self.posterModel;
        poster.imageArray = imageArray;
        [self.navigationController pushViewController:poster animated:YES];
    }
}

#pragma mark 获取相册图片
- (void)takePictureFromAlbum
{
    [self getThumbnailImages];
    [self getOriginalImages];
    [self.choosePictureCollectionView reloadData];
}

- (void)getOriginalImages
{
    // 获得所有的自定义相簿
    PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    // 遍历所有的自定义相簿
    for (PHAssetCollection *assetCollection in assetCollections) {
        [self enumerateAssetsInAssetCollection:assetCollection original:YES];
    }
    
    // 获得相机胶卷
    PHAssetCollection *cameraRoll = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil].lastObject;
    // 遍历相机胶卷,获取大图
    self.originalPhoto = [self enumerateAssetsInAssetCollection:cameraRoll original:YES];
}

- (void)getThumbnailImages
{
    // 获得所有的自定义相簿
    PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    // 遍历所有的自定义相簿
    for (PHAssetCollection *assetCollection in assetCollections) {
        [self enumerateAssetsInAssetCollection:assetCollection original:NO];
    }
    // 获得相机胶卷
    PHAssetCollection *cameraRoll = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil].lastObject;
//    [self enumerateAssetsInAssetCollection:cameraRoll original:NO];
    self.pictureArray = [self enumerateAssetsInAssetCollection:cameraRoll original:NO];
}

/**
 *  遍历相簿中的所有图片
 *  @param assetCollection 相簿
 *  @param original        是否要原图
 */
- (NSMutableArray *)enumerateAssetsInAssetCollection:(PHAssetCollection *)assetCollection original:(BOOL)original
{
    //    self.imageArray = [NSMutableArray array];
    NSLog(@"相簿名:%@", assetCollection.localizedTitle);
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    // 同步获得图片, 只会返回1张图片
    options.synchronous = YES;
    
    // 获得某个相簿中的所有PHAsset对象
    PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    NSMutableArray *array = [NSMutableArray array];
    for (PHAsset *asset in assets) {
        // 是否要原图
        CGSize size = original ? CGSizeMake(asset.pixelWidth, asset.pixelHeight) : CGSizeZero;
        
        // 从asset中获得图片
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
//            NSLog(@"%@", result);
            [array addObject:result];
        }];
    }
    return array;
}


#pragma mark CollectionView
- (void)initChoosePictureCollectionView
{
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    DLog(@"%f",SCREEN_WIDTH);
    flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH - 12) / 3,(SCREEN_WIDTH - 12) / 3);
    flowLayout.minimumInteritemSpacing = 6;
    flowLayout.minimumLineSpacing = 6;
    self.choosePictureCollectionView.collectionViewLayout = flowLayout;
    [self.choosePictureCollectionView setBackgroundColor:[UIColor whiteColor]];
    self.choosePictureCollectionView.alwaysBounceVertical = YES;
    self.choosePictureCollectionView.showsVerticalScrollIndicator = NO;
    self.choosePictureCollectionView.showsHorizontalScrollIndicator = NO;
    //    self.mainCollectionView.tr
    [_choosePictureCollectionView registerNib:[UINib nibWithNibName:@"ChoosePictureCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"pictureCell"];
}

- (void)initPhotoCollectionView
{
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    DLog(@"%f",SCREEN_WIDTH);
    flowLayout.itemSize = CGSizeMake(83,83);
    flowLayout.minimumInteritemSpacing = 15;
    flowLayout.minimumLineSpacing = 15;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.photoCollectionView.collectionViewLayout = flowLayout;
    [self.photoCollectionView setBackgroundColor:[UIColor clearColor]];
    self.photoCollectionView.alwaysBounceVertical = YES;
    self.photoCollectionView.showsVerticalScrollIndicator = NO;
    self.photoCollectionView.showsHorizontalScrollIndicator = NO;
    //    self.mainCollectionView.tr
    [_photoCollectionView registerNib:[UINib nibWithNibName:@"PhotosCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"photoCell"];
}
#pragma mark collectionDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([collectionView isEqual:self.choosePictureCollectionView]) {
        return self.pictureArray.count;
    } else if ([collectionView isEqual:self.photoCollectionView]) {
        return self.photoArray.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([collectionView isEqual:self.choosePictureCollectionView]) {
        ChoosePictureCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"pictureCell" forIndexPath:indexPath];
        UIImage *image = self.pictureArray[indexPath.row];
        cell.pictureImageView.image = image;
        return cell;
    } else if ([collectionView isEqual:self.photoCollectionView]) {
        PhotosCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];
        cell.photoImageView.image = self.photoArray[indexPath.row];
        return cell;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.isPuzzle isEqualToString:@"puzzle"]) {
        if ([collectionView isEqual:self.choosePictureCollectionView]) {
            ChoosePictureCollectionViewCell *cell = (ChoosePictureCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
            cell.selectBtn.selected = !cell.selectBtn.selected;
            if (cell.selectBtn.selected) {
                [self.photoArray addObject:cell.pictureImageView.image];
                [self.indexArray addObject:indexPath];
                [self.photoCollectionView reloadData];
            } else {
                [self.photoArray removeObject:cell.pictureImageView.image];
                [self.indexArray removeObject:indexPath];
                [self.photoCollectionView reloadData];
            }
            
//            NSLog(@"self.photoArray- %@'",self.indexArray);
            
            //        DLog(@"ChoosePictureCollectionViewCell *  %@",cell);
        } else if ([collectionView isEqual:self.photoCollectionView]) {
            
        }
    } else if ([self.isPuzzle isEqualToString:@"batch"]) {
        if ([collectionView isEqual:self.choosePictureCollectionView]) {
            ChoosePictureCollectionViewCell *cell = (ChoosePictureCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
            cell.selectBtn.selected = !cell.selectBtn.selected;
            if (cell.selectBtn.selected) {
                [self.photoArray addObject:cell.pictureImageView.image];
                [self.indexArray addObject:indexPath];
                [self.photoCollectionView reloadData];
            } else {
                [self.photoArray removeObject:cell.pictureImageView.image];
                [self.indexArray removeObject:indexPath];
                [self.photoCollectionView reloadData];
            }
            
//            NSLog(@"self.photoArray- %@'",self.indexArray);
            
            //        DLog(@"ChoosePictureCollectionViewCell *  %@",cell);
        } else if ([collectionView isEqual:self.photoCollectionView]) {
            
        }
    } else {
        
        if ([collectionView isEqual:self.choosePictureCollectionView]) {
            ChoosePictureCollectionViewCell *cell = (ChoosePictureCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
            if (self.photoArray.count < self.photoCount) {
                cell.selectBtn.selected = !cell.selectBtn.selected;
                if (cell.selectBtn.selected) {
                    [self.photoArray addObject:cell.pictureImageView.image];
                    [self.indexArray addObject:indexPath];
                    [self.photoCollectionView reloadData];
                } else {
                    [self.photoArray removeObject:cell.pictureImageView.image];
                    [self.indexArray removeObject:indexPath];
                    [self.photoCollectionView reloadData];
                }
            } else {
                if (cell.selectBtn.selected) {
                    cell.selectBtn.selected = !cell.selectBtn.selected;
                    [self.photoArray removeObject:cell.pictureImageView.image];
                    [self.indexArray removeObject:indexPath];
                    [self.photoCollectionView reloadData];
                }
            }
            
//            NSLog(@"self.photoArray- %@'",self.indexArray);
            
            //        DLog(@"ChoosePictureCollectionViewCell *  %@",cell);
        } else if ([collectionView isEqual:self.photoCollectionView]) {
            
        }
    }
}
//定义每个UICollectionView 的间距
//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
////    if (SCREEN_WIDTH > 320) {
////        return UIEdgeInsetsMake(68, 55, 10, 55);
////    } else {
////        return UIEdgeInsetsMake(30, 27, 10, 27);
////    }
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

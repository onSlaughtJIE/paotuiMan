//
//  CameraViewController.m
//  UUPaoTuiMan
//
//  Created by qianyuan on 2017/7/28.
//  Copyright © 2017年 qianyuan. All rights reserved.
//

#import "CameraViewController.h"
#import "CameraCollectionViewCell.h"
#import <Photos/Photos.h>

@interface CameraViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UINavigationControllerDelegate,UIImagePickerControllerDelegate>
    {
        UIImage *selectImage;
    }

@property(nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic,strong)NSMutableArray *photoArray;
@property(nonatomic,strong)UIImagePickerController *imagePicker;

@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavView];
    [self.view addSubview:self.collectionView];
    [self getPhotoData];
}

- (void)setNavView{
    self.controllTitleLabel.text = @"实名认证";
    self.view.backgroundColor = WHITE_COLOR;
    [self.popButton addTarget:self action:@selector(dismissVC) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sureButton.frame = CGRectMake(SCREEN_WIDTH - 80, self.popButton.top, 60, 30);
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [sureButton setBackgroundColor:GRAY_COLOR];
    [sureButton setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(sureSelectPhoto:) forControlEvents:UIControlEventTouchUpInside];
    sureButton.tag = 8510;
    sureButton.layer.cornerRadius = 3;
    sureButton.clipsToBounds = YES;
    [self.naviView addSubview:sureButton];
}
    
- (void)sureSelectPhoto:(UIButton *)button{
    if (selectImage == nil) {
        return;
    }
    if (_selectPhotoImage) {
        _selectPhotoImage(selectImage);
        [self dismissVC];
    }
}
- (void)getPhotoData{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusDenied || status == PHAuthorizationStatusRestricted) {
        //设置访问权限
    }
    NSMutableArray <PHAsset*> *assets = [self getAllAssetInPhotoAblumWithAscending:YES];
    for (PHAsset *set in assets ) {
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
        [[PHImageManager defaultManager] requestImageForAsset:set targetSize:SCREEN_SIZE contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            [self.photoArray addObject:result];
            [_collectionView reloadData];
        }];
    }
}

#pragma mark - 获取相册内所有照片资源
- (NSMutableArray<PHAsset *> *)getAllAssetInPhotoAblumWithAscending:(BOOL)ascending
{
    NSMutableArray<PHAsset *> *assets = [NSMutableArray array];
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:ascending]];
    PHFetchResult *result = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:option];
    [result enumerateObjectsUsingBlock:^(PHAsset *asset, NSUInteger idx, BOOL * _Nonnull stop) {
        [assets addObject:asset];
    }];
    return assets;
}


#pragma mark ----------------- UICollectionViewDelegate
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CameraCollectionViewCell *cameraCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cameraCell" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cameraCell.photoImageView.image = [UIImage imageNamed:@"camera_back"];
        cameraCell.selectBtn.hidden = YES;
    }else{
        cameraCell.photoImageView.image = self.photoArray[indexPath.row - 1];
        cameraCell.selectBtn.hidden = NO;
    }
    return cameraCell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.photoArray.count + 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        //调用相机
        [self presentViewController: self.imagePicker animated:YES completion:nil];
    }else{
        CameraCollectionViewCell *cell = (CameraCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.selectBtn.selected = YES;
        selectImage = self.photoArray[indexPath.row - 1];
        cell.backView.backgroundColor = [BLACK_COLOR colorWithAlphaComponent:0.3];
        UIButton *button = (UIButton *)[self.view viewWithTag:8510];
        [button setBackgroundColor:XLColorFromRGB(42, 200, 51, 1)];
        
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row > 0) {
        CameraCollectionViewCell *cell = (CameraCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.selectBtn.selected = NO;
        cell.backView.backgroundColor = CLEAR_COLOR;
    }
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH / 4, SCREEN_WIDTH / 4);
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.top = 64;
        _collectionView.height = SCREEN_HEIGHT - 64;
        _collectionView.backgroundColor = CLEAR_COLOR;
        [_collectionView registerNib:[UINib nibWithNibName:@"CameraCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cameraCell"];
    }
    return _collectionView;
}

- (NSMutableArray *)photoArray{
    if (!_photoArray) {
        _photoArray = [NSMutableArray new];
    }
    return _photoArray;
}

-(UIImagePickerController *)imagePicker{
    if (_imagePicker == nil) {
        _imagePicker = [[UIImagePickerController alloc]init];
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            _imagePicker .sourceType = UIImagePickerControllerSourceTypeCamera;
            _imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
            _imagePicker.allowsEditing = YES;
            _imagePicker.delegate = self;
        }
    }
    return _imagePicker;
}
    
#pragma mark-- imagePicker的代理
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //获取到图片
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    //保存照片到相册
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo
    {
    if (error) {
        NSLog(@"%@ 保存失败",[error localizedDescription]);
    }else
    {
        //保存成功
        NSLog(@"保存成功");
        [_photoArray addObject:image];
        [_collectionView reloadData];
    }
}

- (void)dismissVC{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

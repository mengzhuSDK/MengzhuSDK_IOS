//
//  MZImagePickerViewController.m
//  MengZhu
//
//  Created by vhall on 16/11/29.
//  Copyright © 2016年 www.mengzhu.com. All rights reserved.
//

#import "MZImagePickerViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "VPImageCropperViewController.h"
@interface MZImagePickerViewController ()<UIImagePickerControllerDelegate,VPImageCropperDelegate,UINavigationControllerDelegate>

@end

@implementation MZImagePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
    [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
    self.mediaTypes = mediaTypes;
    self.delegate = self;
    NSDictionary *textAttributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:21],
                                     NSForegroundColorAttributeName:[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1],};
    [ self.navigationBar setTitleTextAttributes:textAttributes];
//     self.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    self.navigationBar.translucent = NO;
    self.navigationBar.backIndicatorImage = [[UIImage alloc] init];
    self.navigationBar.backIndicatorTransitionMaskImage = [[UIImage alloc] init];
    self.navigationBar.barStyle = UIBarStyleBlack;
    [ self.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBarBackImg"] forBarMetrics:UIBarMetricsDefault ];
    self.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

    // Do any additional setup after loading the view.
}



- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *portraitImg = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (portraitImg.size.width/(portraitImg.size.height*1.0) != 1) {
        portraitImg = [MZBaseGlobalTools imageByScalingToMaxSize:portraitImg size:CGSizeMake(1920, 1920)];//缩小
        portraitImg = [MZBaseGlobalTools imageByScalingToMinSize:portraitImg size:CGSizeMake(360, 360)];//放大
    }
    if(self.ratio <= 0){
        self.ratio = 1;
    }
    VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(self.view.width/2.0-MZ_SW/2.0, self.view.height/2.0- (MZ_SW/self.ratio)/2.0, MZ_SW, MZ_SW/self.ratio) limitScaleRatio:3.0];
    imgEditorVC.delegate = self;
    self.navigationBarHidden = YES;
    [self pushViewController:imgEditorVC animated:YES];
}

-(void)setRatio:(CGFloat)ratio
{
    _ratio = ratio;
}


#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {

    if (editedImage !=nil)
//        self.imageBlock([MZBaseGlobalTools scaleToSize:editedImage size:CGSizeMake(120, 120)]);
        self.imageBlock(editedImage);
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^(){}];
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

//
//  MZCoreSDKLibrary.h
//  MZCoreSDKLibrary
//
//  Created by 李风 on 2020/7/1.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - category
#import "UIView+MZExtend.h"
#import "UIView+MZHud.h"
#import "UIDevice+MZDevice.h"

#pragma mark - user
#import "MZUser.h"
#import "MZPersistenceManager.h"

#pragma mark - config
#import "MZActivityConfig.h"
#import "MZConstantConfig.h"
#import "MZEventConfig.h"
#import "MZLogConfig.h"
#import "MZVarKeyOrValue.h"
#import "codeObfuscation.h"

#import "MZBaseModel.h"
#import "MZBaseNetModel.h"

//#import "MZGoodsListModel.h"
//#import "MZGoodsListOuterModel.h"
//#import "HDAutoADModel.h"
//#import "HDCustomTextADModel.h"
//#import "MZActMsg.h"
//#import "MZGlobalContentModel.h"
//#import "MZLongPollDataModel.h"
//#import "MZRightContenModel.h"
//#import "MZRightModel.h"
//#import "MZSingleContentModel.h"

#pragma mark - utils
#import "MZTimer.h"

#pragma mark - network
#import "MZApiClient.h"
#import "MZCoreSDKNetWork.h"
#import "MZStatisticsStystem.h"
#import "NetworkPathsCommon.h"

#import "MZImageUpload.h"
#import "MZURL.h"

#pragma mark - MZLottie Json动画库
#import "MZLottie.h"
#import "MZKeypath.h"
#import "MZValueCallback.h"
#import "MZBlockCallback.h"
#import "MZAnimationView.h"
#import "MZAnimationTransitionController.h"
#import "MZAnimationCache.h"
#import "MZAnimatedControl.h"
#import "MZAnimationView_Compat.h"
#import "MZAnimatedSwitch.h"
#import "MZComposition.h"
#import "MZInterpolatorCallback.h"
#import "MZCacheProvider.h"
#import "MZValueDelegate.h"

#pragma mark - MZWebView 通用WKWebview
#import "MZWebView.h"

#pragma mark - MZ
#import "MZBaseUserServer.h"
#import "MZBaseGlobalTools.h"
#import "MZBaseStatisticsStystem.h"
#import "MZPredictManageCreatRecommendView.h"
#import "MZBaseLayout.h"
#import "MZBaseLayoutProtocol.h"
#import "MZBasePresenter.h"
#import "MZBasePresenterProtocol.h"
#import "MZAPPApiClient.h"
#import "MZCommenComment.h"
#import "MZNetSeverUrlManager.h"
#import "MZNetSeverUrlModel.h"
#import "MZStystemSetting.h"
#import "NSObject+MZCurrentVC.h"
#import "MZSupportComment.h"
#import "MZParameterCommon.h"
#import "MZActivityComment.h"
#import "MZDismissVew.h"
#import "UIButton+MZChangeHitRect.h"
#import "MZCreatPredictTipsModel.h"
#import "MZBadgeButton.h"
#import "MZMessageTextView.h"
#import "MZSDKMessageTextView.h"
#import "UIImage+BoxBlur.h"
#import "MZBaseImageTools.h"
#import "MZActionSheetView.h"
#import "UIViewExt.h"
#import "MZDownLoadManager.h"
#import "MZCoreNetOperate.h"

#pragma mark - 兼容低版本
#import "CompatibleLowVersionDefine.h"
#import "NSObject+MZKeyValue.h"
/// MZRefresh
#import "MZRefresh.h"
#import "MZRefreshAutoFooter.h"
#import "MZRefreshComponent.h"
#import "MZRefreshHeader.h"
#import "MZRefreshFooter.h"
#import "MZRefreshBackFooter.h"
#import "MZRefreshConst.h"
#import "MZRefreshConfig.h"
#import "MZRefreshStateHeader.h"
#import "MZRefreshGifHeader.h"
#import "MZRefreshNormalHeader.h"
#import "MZRefreshAutoGifFooter.h"
#import "MZRefreshAutoNormalFooter.h"
#import "MZRefreshAutoStateFooter.h"
#import "MZRefreshBackStateFooter.h"
#import "MZRefreshBackNormalFooter.h"
#import "MZRefreshBackGifFooter.h"
#import "UIView+MZExtension.h"
#import "UIScrollView+MZRefresh.h"
#import "UIScrollView+MZExtension.h"
#import "NSBundle+MZRefresh.h"
#import "MZCoreNetWork.h"

#pragma mark - B New Add
// category
#import "NSObject+MZTimer.h"
#import "NSString+MZCommon.h"

// utils
#import "MZUserDefaults.h"
#import "MZAudioTool.h"
#import "MZCreatUI.h"
#import "MZAlertControl.h"
#import "MZTimeManager.h"
#import "MZFileManager.h"
#import "MZImagePickerController.h"

// base
#import "MZCoreNavigationController.h"//navigationController基类
#import "MZCoreViewController.h"//viewcontroller基类
#import "MZBaseNormalViewController.h"//盟主普通用户端的viewcontroller基类



//! Project version number for MZCoreSDKLibrary.
FOUNDATION_EXPORT double MZCoreSDKLibraryVersionNumber;

//! Project version string for MZCoreSDKLibrary.
FOUNDATION_EXPORT const unsigned char MZCoreSDKLibraryVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <MZCoreSDKLibrary/PublicHeader.h>



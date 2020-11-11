//
//  MZEventConfig.h
//  MZPlayKitSDK
//
//  Created by sunxianhao on 2020/6/28.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#ifndef MZEventConfig_h
#define MZEventConfig_h
#define MZEVENT_TAG_BASE                    1000

//多媒体系统弹窗tag
#define MZEVENT_TAG_SET_CAMERA_AUTH         (MZEVENT_TAG_BASE+1)//相机权限—系统“设置”
#define MZEVENT_TAG_SET_MIRCO_AUTH          (MZEVENT_TAG_BASE+2)//麦克风权限—系统“设置”
#define MZEVENT_TAG_SET_PHOTOLIBRIARY_AUTH  (MZEVENT_TAG_BASE+3)//图片库权限—系统“设置”
#define MZEVENT_TAG_SET_ADDRESSBOOK_AUTH    (MZEVENT_TAG_BASE+4)//通讯录—系统“设置”
#define MZEVENT_TAG_SET_CHANNEL_MANAGER     (MZEVENT_TAG_BASE+5)//频道管理弹窗
//分享和登录
#define MZEVENT_TAG_UM_SHAREWEIBO           (MZEVENT_TAG_BASE+6)//微博分享
#define MZEVENT_TAG_UM_SHAREWX              (MZEVENT_TAG_BASE+7)//微信好友分享
#define MZEVENT_TAG_UM_SHAREWXPYQ           (MZEVENT_TAG_BASE+8)//微信朋友圈分享
#define MZEVENT_TAG_UM_SHAREQQ              (MZEVENT_TAG_BASE+9)//QQ分享

#endif /* MZEventConfig_h */

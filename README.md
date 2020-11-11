#  SDK简介 
盟主直播SDK是一款辅助于盟主直播的推流及拉流工具，此工具仅限用于盟主直播业务，需在盟主开放平台进行认证授权方可使用。盟主直播SDK主要实现功能有视频直播推流、视频直播、点播拉流、视频下载及聊天等业务功能，其推流功能采用摄像头数据抓取并进行编码后推送至盟主服务器，播放功能实现对盟主直播及点播视频的编解码播放。盟主直播SDK接入方式简洁、方便，其功能实现效果稳定、高效。

#  盟主直播IOS SDK架构设计 
盟主直播IOS SDK架构以FFM设计模式进行搭建，framework为核心框架层面技术，内部实现了网络请求和播放器核心框架等功能，function功能层处理了播放器推流器的封装和实现功能等工作，manager层为用户对接层，此层面封装了所有面向接入端所需要的业务接口及管理器。

#  运行环境
- 支持IOS 9.0及以上系统  
- 支持所有装有IOS系统硬件设备  

# pod集成
```
use_frameworks!#这行必须加

pod 'MZCoreSDKLibrary','2.6.1' #盟主SDK的核心依赖库
pod 'MZMediaSDK','2.6.1' #盟主业务组件
pod 'MZPlayerSDK','2.6.1' #盟主播放器组件，如需播放器功能，请添加此行代码
pod 'MZPushFlowSDK','2.6.1' #盟主推流组件，如需直播功能，请添加此行代码
pod 'MZDownLoaderSDK','2.6.1' #盟主下载器的组件，如需下载功能，请添加此行代码
pod 'MZChatSDK','2.6.6'#盟主聊天消息组件
pod 'MZUploadVideoSDK','2.6.1'#盟主视频上传组件，如需上传功能，请添加此行代码
```

# Wiki开发文档
* [1. 开发文档首页](https://github.com/mengzhuSDK/MengzhuSDK_IOS/wiki)
* [2. 快速集成](https://github.com/mengzhuSDK/MengzhuSDK_IOS/wiki/2.快速集成)
* [3. 用户唯一标示](https://github.com/mengzhuSDK/MengzhuSDK_IOS/wiki/3.用户唯一标示)
* [4. SDK初始化](https://github.com/mengzhuSDK/MengzhuSDK_IOS/wiki/4.SDK初始化)
* [5. 推流](https://github.com/mengzhuSDK/MengzhuSDK_IOS/wiki/5.推流)
* [6. 播放器(竖屏/二分屏/自定义)](https://github.com/mengzhuSDK/MengzhuSDK_IOS/wiki/6.播放器(竖屏-二分屏-自定义))
* [7. 功能(投屏 弹幕 小窗口 倍速 防录屏)](https://github.com/mengzhuSDK/MengzhuSDK_IOS/wiki/7.功能(投屏-弹幕-小窗口-倍速-防录屏))
* [8. 互动(签到 投票 文档 抽奖 广告 观看权限)](https://github.com/mengzhuSDK/MengzhuSDK_IOS/wiki/8.互动(签到-投票-文档-抽奖-广告-观看权限))
* [9. 聊天和消息](https://github.com/mengzhuSDK/MengzhuSDK_IOS/wiki/9.聊天和消息)
* [10. 问答和礼物](https://github.com/mengzhuSDK/MengzhuSDK_IOS/wiki/10.问答和礼物)
* [11. 下载器](https://github.com/mengzhuSDK/MengzhuSDK_IOS/wiki/11.下载器)
* [12. 上传视频](https://github.com/mengzhuSDK/MengzhuSDK_IOS/wiki/12.上传视频)
* [13. 版本更新](https://github.com/mengzhuSDK/MengzhuSDK_IOS/wiki/13.版本更新)
* [14. API文档](https://github.com/mengzhuSDK/MengzhuSDK_IOS/wiki/14.API文档)

# 注意
本项目是一个包含盟主SDK所有功能使用的demo，旨在帮助开发者快速集成盟主SDK。

demo里实现了多种适用于盟主SDK的UI，后续会继续改动，所以建议开发者基于盟主SDK进行开发，这样更灵活。

如若在本demo上进行开发，demo里的源码UI则需自己维护，这种更适用于UI改动较少或者着急出功能的开发者。


# 支持功能
- 直播 

默认推流UI、普通视频直播、纯语音直播、横屏直播、竖屏直播、直播时静音、美颜动态调节、分辨率动态调节、镜像、闪光灯、前后置摄像头动态切换、直播开始倒计时、实时展示帧率、直播时长、设置直播所属分类、设置直播间禁言、设置直播的观看方式

- 播放 

默认播放UI、竖屏播放、二分屏播放、横屏播放、投屏、倍速、防录屏、小窗口播放、弹幕组件、
视屏封面、开屏广告、片头视频广告、滚动广告、F码观看、白名单观看、自定义播放控制栏、活动配置实时更改

- 聊天 

文字聊天、表情聊天(可自定义表情)、用户信息获取、聊天历史记录是否显示、在线观众列表、禁言用户、踢出用户、聊天公告设置、只显示主播聊天信息

-  互动 

文档功能、问答功能、礼物功能、签到功能、投票功能、抽奖功能

-  商品 

商品列表、循环播放推荐商品、

-  下载 

视频多线程下载、实时展示进度、支持后台下载、直播下载完成后播放

- 上传

视频多线程上传、多任务上传，支持后台上传

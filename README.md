# 1. SDK简介
盟主直播SDK是一款辅助于盟主直播的推流及拉流工具，此工具仅限用于盟主直播业务，需在盟主开放平台进行认证授权方可使用。盟主直播SDK主要实现功能有视频直播推流、视频直播、点播拉流及聊天等业务功能，其推流功能采用摄像头数据抓取并进行编码后推送至盟主服务器，播放功能实现对盟主直播及点播视频的编解码播放。盟主直播SDK接入方式简洁、方便，其功能实现效果稳定、高效。
# 2. 盟主直播IOS SDK架构设计
盟主直播IOS SDK架构以FFM设计模式进行搭建，framework为核心框架层面技术，内部实现了网络请求和播放器核心框架等功能，function功能层处理了播放器推流器的封装和实现功能等工作，manager层为用户对接层，此层面封装了所有面向接入端所需要的业务接口及管理器。具体结构请看下图。
# 3. SDK功能及支持
###  3.1.  设备和系统要求
> 支持IOS 8.2及以上系统  
支持所有装有IOS系统硬件设备  
###  3.2 功能特性
> 支持推流到主流 RTMP 服务器  
支持 H.264 和 AAC 编码  
支持MP4录制  
支持音视频采集，编码，打包，传输  
资源占用率低，库文件小  
画质清晰，延时低  
支持闪光灯开启操作  
支持摄像头缩放操作  
支持前后置摄像头动态切换  
支持分辨率动态切换  
支持自动对焦  
支持摄像头焦距调节  
支持视频镜像操作  
支持视频截图  
支持多款滤镜  
支持磨皮  
支持直播过程中帧率调节  
支持直播过程中码率调节  
提供固定ui  
支持直播间聊天  
支持历史消息获取  
支持商品列表  
支持直播间信息获取  
支持在线观众展示  
支持主播信息获取  
支持竖屏直播  
支持横屏直播  
支持直播时长展示  
支持直播码率实时展示  
支持直播间全体禁言/解禁言  
支持直播过程中静音功能  
支持禁言/解禁单个用户  
支持竖屏播放  
支持横屏播放  
支持二分屏播放  
支持小窗口播放  
支持倍速播放  
支持投屏到其他设备播放  
支持防录屏功能  
支持发送弹幕功能  
支持在线开启/关闭弹幕  
支持自定义菜单和页面功能  
支持自定义开播倒计时  
支持自定义视频封面  
支持回放视频下载功能  
支持多任务下载  
支持后台下载  
支持纯语音直播  
支持纯语音回放  
支持签到功能  
支持投票功能  
支持直播/回放文档功能  
支持后台配置公告  
支持历史记录是否显示

# **4. SDK配置及介绍**
本文是根据附加demo来介绍SDK集成，可在已下载的SDK文件路径下引入demo项目。通过查看demo可了解更多详细功能。
## **4. 1 cocoapods集成**
### **- 本项目支持cocoapods安装，只需要将如下代码添加到Podfile中:** 
    pod 'MZCoreSDKLibrary','~>2.2.0' #盟主SDK的核心依赖库，使用其他组件时，会自动下载该组件
    pod 'MZMediaSDK','~>2.2.1' #盟主业务组件，如需使用业务请求功能，请添加此行代码
    pod 'MZPlayerSDK','~>2.2.0' #盟主播放器组件，如需播放器功能，请添加此行代码
    pod 'MZPushFlowSDK','~>2.2.0' #盟主推流组件，如需直播功能，请添加此行代码
    pod 'MZDownLoaderSDK','~>2.2.2' #盟主下载器的SDK，如需下载功能，请添加此行代码
执行pod install或pod update，如若找不到库，请执行pod repo update，进行本地库更新。

# **5.固定UI版快速集成 **
- 如文档与demo有未同步情况，请先参考demo并运行测试确认是否正确。
- 集成过程中如遇到未知错误请联系盟主客服
### **- 使用前请在ViewController里配置appId和appSecretKey**
      #warning 分配的appID和secretKey
      #define MZSDK_AppID @""
      #define MZSDK_SecretKey @""
      
### **- 推流UI集成**    
    [MZSDKBusinessManager setDebug:YES];
    
    [self serUserInfoSuccess:^(BOOL result, NSString *errorString) {
        if (result) {
            MZReadyLiveViewController *vc = [[MZReadyLiveViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [self.view show:errorString];
        }
    }];

### **- 二分屏/横屏播放器UI集成**
    [MZSDKBusinessManager setDebug:NO];
    
    [self serUserInfoSuccess:^(BOOL result, NSString *errorString) {
        if (result) {
            MZSuperPlayerViewController *superPlayerVC = [[MZSuperPlayerViewController alloc] init];
            superPlayerVC.ticket_id = self.ticket_IDTextView.text;
            [self.navigationController pushViewController:superPlayerVC animated:YES];
        } else {
            [self.view show:errorString];
        }
    }];

### **- 竖屏播放器UI集成**
    [MZSDKBusinessManager setDebug:YES];
    
    [self serUserInfoSuccess:^(BOOL result, NSString *errorString) {
        if (result) {
            MZVerticalPlayerViewController *liveVC = [[MZVerticalPlayerViewController alloc]init];
            liveVC.ticket_id = self.ticket_IDTextView.text;
            [self.navigationController pushViewController:liveVC  animated:YES];
        } else {
            [self.view show:errorString];
        }
    }];

### **- 配置用户信息**
```
-(void)serUserInfoSuccess:(void(^)(BOOL result, NSString *errorString))success {
    if (self.ticket_IDTextView.text.length <= 0) {
        success(NO, @"活动ID不能为空");
        return;
    }
    
    if (self.uniqueIDTextView.text.length <= 0) {
        success(NO, @"用户ID不能为空");
        return;
    }
    
    MZUser *user = [[MZUser alloc] init];
    
#warning - 用户自己传过来的唯一ID
    user.uniqueID = self.uniqueIDTextView.text;
    user.nickName = self.nameTextView.text;
    user.avatar = self.avatarTextView.text;
        
#warning - 请输入分配给你们的appID和secretKey
    user.appID = MZSDK_AppID;//线上模拟环境(这里需要自己填一下)
    user.secretKey = MZSDK_SecretKey;
    
    if (user.appID.length <= 0 || user.secretKey.length <= 0) {
        success(NO, @"请配置appId或secretKey");
        return;
    }
    
    [MZUserServer updateCurrentUser:user];
    
    success(YES, @"");
}
```
### **- 下载器UI集成**
    MZM3U8DownLoadViewController *downloadVC = [[MZM3U8DownLoadViewController alloc] init];
    downloadVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.navigationController pushViewController:downloadVC animated:YES];

# **6.非固定UI版功能集成 **
- 不使用自带UI的具体实现方式请查看wiki文档



# ** 版本更新 **

- 2.2版本更新内容
1. 新增发起/观看语音直播。
2. 新增文档功能。
3. 新增签到功能。
4. 新增投票功能。
5. 新增自定义公告功能。

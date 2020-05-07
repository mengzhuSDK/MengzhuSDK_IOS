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

# **4. SDK配置及介绍**
本文是根据附加demo来介绍SDK集成，可在已下载的SDK文件路径下引入demo项目。通过查看demo可了解更多详细功能。
## **4. 1 cocoapods集成**
### **- 本项目支持cocoapods安装，只需要将如下代码添加到Podfile中:** 
    pod 'MZMediaSDK'#推流和播放器的SDK，最新版本1.0.3
    pod 'MZDownLoaderSDK'#下载器的SDK，最新版本1.0.7（如需下载功能，添加此行代码）

执行pod install或pod update。

## **4. 2 手动集成**
### **- SDK工具包及导入介绍**
    MZMediaSDK.framework
a 将工具包MZMediaSDK.framework复制到项目目录下，进入`project` 设置界面选择`Linked Frameworks andLibraries`点击`+`选择项目内的framework工具包点完成。
b 展开`Embedded Binaries`点击`+`选择`MediaSDK.framework`加入完成。
### **- SDK所需要的系统代码库引用**
a 展开`Linked Frameworks andLibraries`点击`+`搜索`Foundation.framework`，`AVFoundation.framework`，`QuartzCore.framework`，`OpenGLES.framework`，`CoreVideo.framework`，`CoreMedia.framework``AssetsLibrary.framework`，`UIKit.framework`进行引入。
b 引用tdb`Linked Frameworks andLibraries`点击`+`搜索`libbz2.tbd`，`libbz2.1.0.tbd`，`libz.1.2.5.tbd`，`libstdc++.6.0.9.tbd`进行引入。注：如Xcode版本在10及以上会搜索不到上述部分tbd文件，如搜索不到需要在网上下载或在Xcode9以下版本内复制粘贴至Xcode对应路径下。
![](https://wmz.zmengzhu.com/uploads/201811/5bdd1d9d6bce7_5bdd1d9d.png)
### **- 资源文件导入**
将`MZMediaSDK.bundle`复制至项目目录下，`project`选择`Build Phases`展开`Copy Bundle Resources`点击`+`选择`MZMediaSDK.bundle`进行引入。
### - 项目配置
进入`project`选择`Build Settings` `all` `Combined` 搜索`ENABLE_BITCODE`设为`NO`

![](https://wmz.zmengzhu.com/uploads/201811/5bdd1d33a59a9_5bdd1d33.png)
## **4.3 权限设置**
具体权限配置请查看demo info
![](https://wmz.zmengzhu.com/uploads/201811/5bdd3e32a1c7b_5bdd3e32.png)

# **5.固定UI版快速集成 **
- 如文档与demo有未同步情况，请先参考demo并运行测试确认是否正确。
- 集成过程中如遇到未知错误请联系盟主客服
### **- ViewController内实现代码**
      self.playerControlView = [[MZPlayerControlView alloc] initWithFrame:self.view.bounds];//初始化带UI的播放器View
      self.playerControlView.playerDelegate = MZPlayerControlViewProtocol;//设置代理接收回调
      [self.playerControlView playVideoWithLiveIDString:self.ticket_id];//选择播放的ID
      MZUser *user=[[MZUser alloc]init];//用户信息对象
      user.userId=uid;//用户id
      user.appID=appid;//APPID
      user.avatar= avatar;//用户头像
      user.nickName=name;//用户昵称
      [MZUserServer updateCurrentUser:user];//更新用户信息
  ### **- MZPlayerControlViewProtocol代理描述**
      - (void)closeButtonDidClick:(id)playInfo//关闭按钮回调
      -(void)avatarDidClick:(id)playInfo//头像点击
      -(void)reportButtonDidClick:(id)playInfo//举报点击
      -(void)shareButtonDidClick:(id)playInfo//分享点击
      -(void)likeButtonDidClick:(id)playInfo//点赞点击
      -(void)onlineListButtonDidClick:(id)playInfo//在线人数
      -(void)shoppingBagDidClick:(id)playInfo//购物点击
      -(void)attentionButtonDidClick:(id)playInfo//关注点击
      -(void)chatUserDidClick:(id)playInfo//聊天用户点击
# **6.非固定UI版功能集成 **
- 不使用自带UI的具体实现方式请查看wiki文档

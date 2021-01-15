# MZMeeting - 会议组件
## 集成步骤
- 1. 将MobileRTC.framework，MobileRTCResources.bundle，MZMeetingSDK.framework, MZMeetingSDK.bundle，copy到工程里。

- 2. MobileRTC.framework, MZMeetingSDK.framework的Embed改成Embed & Sign.

- 3. build Settings里的bitcode关闭。

- 4. info.plist里添加 相机、麦克风、蓝牙的使用权限，请务必详细填写。例如
```
“盟主”需要访问您的麦克风以便您正常使用视频直播、语音直播、视频会议的采集音频功能，是否允许
“盟主”需要访问您的相机以便您正常使用拍摄照片、视频直播等功能，是否允许
“盟主”需要您的同意才能使用蓝牙功能扫描附近的蓝牙设备，是否允许
```
- 5. 该功能依赖于盟主核心库 - MZCoreSDKLibrary
```
// 请在Podfile里添加该代码
use_frameworks!

pod 'MZCoreSDKLibrary','2.6.2'

end
```

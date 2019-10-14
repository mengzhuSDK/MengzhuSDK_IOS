//
//  VHTools.h
//  vhallIphone
//
//  Created by yangyang on 14-7-23.
//  Copyright (c) 2014年 zhangxingming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sys/utsname.h>
@class VHVideoInfo;
@class VHVideoInfoItem;
@class YWConversationViewController;
@class YWConversation;


@interface MZGlobalTools : NSObject
+ (BOOL) IsEnableWIFI ;
+ (BOOL) IsEnable3G ;
//检测网络是否正常
+ (BOOL) IsEnableNet;
// 判断设备是否安装sim卡
+ (BOOL)isSIMInstalled;
+ (NSString*) MD5:(NSString *)str;
+ (NSString*) MD5WithNet:(NSString *)netOperate;
+ (NSString*) MD5WithParam:(NSDictionary *)Param;
+ (NSString*) MD5WithUrl:(NSString*)url Param:(NSDictionary *)param;
+ (NSString*) atomSting:(NSDictionary *)param;
+ (NSString*) dicToJsonStr:(NSDictionary*)dic;
+ (NSString *)arrayToJsonStr:(NSMutableArray *)array;//数组转json字符串
+ (NSString*) emptyForNil:(NSString *)str;
+ (NSString*) delSpaceCharacter:(NSString *)str;
+ (void) testValue:(id)value key:(NSString*)key op:(NSString*)op;
//yyyy-MM-dd HH:mm:ss
+ (NSDate *)dateFromString:(NSString *)dateString Formatter:(NSString*)formatter;
//MM-dd HH:mm
+ (NSString *)stringFromDate:(NSDate *)date Formatter:(NSString*)formatter;
//秒数转时间
+ (NSString *)stringInterval:(NSString *)interval Formatter:(NSString*)formatter;
//秒转天、小时
+(NSString *)getDDHHFromSS:(NSInteger)totalTime;
//将时间戳转化为dateFormat形式的例如@“YYYY-MM-dd HH:mm:ss”
+(NSString *)timeDateBackWithDateFormat:(NSString *)dateFormat timestamp:(NSString *)timestamp;
//将时间戳转化为YYYY-MM-dd HH:mm:ss
+(NSString *)timeDateBackYMDHMS:(NSString *)timestamp;
//将时间戳转化为YYYY-MM-dd HH:mm
+(NSString *)timeDateBackYMDHM:(NSString *)timestamp;
/*
 **将某个时间转化成 时间戳
 */
+(NSInteger)timeSwitchTimestamp:(NSString *)formatTime andFormatter:(NSString *)format;
+(BOOL)isFloat:(NSString *)floatstr;
+(BOOL)isValidateEmail:(NSString *)email;
//身份证号
+ (BOOL)isValidateIdentityCard: (NSString *)identityCard;
+ (BOOL)isPhoneNumber:(NSString *)mobileNum;
+ (BOOL)isIntNumber:(NSString *)number;
+ (BOOL)isCheckCode:(NSString *)checkCode;
//密码(是不是符合规范)
+(BOOL)isRightCode:(NSString *)code;
+ (NSString*)isWebinar:(NSString *)url;
//纯色图片
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

//图像尺寸修改
+(UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;
//图像尺寸裁切
+ (UIImage*)clipImageWithImage:(UIImage*)image inRect:(CGRect)rect;
+ (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage size:(CGSize)size;//等比缩小 边最大 为size
+ (UIImage *)imageByScalingToMinSize:(UIImage *)sourceImage size:(CGSize)size;//等比放大 边最小 为size
+ (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize;
//图片旋转
+ (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation;
#pragma mark camera utility
+ (BOOL) isCameraAvailable;
+ (BOOL) isRearCameraAvailable;
+ (BOOL) isFrontCameraAvailable;
+ (BOOL) doesCameraSupportTakingPhotos;
+ (BOOL) isPhotoLibraryAvailable;
+ (BOOL) canUserPickVideosFromPhotoLibrary;
+ (BOOL) canUserPickPhotosFromPhotoLibrary;
+ (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceTyp;

//检测相机 麦克风、图片库授权状态（提示-跳转系统设置）
+ (BOOL)checkMediaDevice:(NSString * const)AVMediaTypeStr;
//检测相机 麦克风授权(未确定或未提示)状态
+ (BOOL)checkMediaAuthorizationStatus:(NSString *)AVMediaTypeStr;
//判断通讯录是否授权
+ (BOOL)addressBookIsAuthor;
//通讯录授权弹窗
+ (void)showAddressBookAlertView;
//获取手机通讯录数据
+ (NSMutableArray *)getAddressBookData;
//进行NSUTF8String encoding 进行编码
//stringByReplacingPercentEscapesUsingEncoding: 解码
+ (NSString*)urlEncodeUTF8String:(NSString *)string;
+ (NSString*)urlDecodeChineseString:(NSString *)string;
//检测网络是否正常
+(BOOL) isConnectionAvailable;
//检查状态栏是否为正常：正常高度为20
+ (BOOL)statusBarHeighrIsNormal;
//圆角值跟随屏幕适配变化
+ (CGFloat)cornerRadiusAutoLay:(CGFloat)number;

//字号变化
+ (CGFloat)fontChange:(CGFloat)font;

//数字转 k w 等
//+ (NSString*)numToString:(NSInteger)num;
//数字转 千 万 亿
+ (NSString*)numToStringWithChinese:(NSInteger)num;

//数字转万
+(NSString *)getShowCountStringWitchCount:(long long)count;

//只显示K
//+(NSString*)numToStringWithK:(NSInteger)num;
//只显示w
//+(NSString*)numToStringWithW:(NSInteger)num;
//整型转字符串
+(NSString*)numShowAll:(NSInteger)num;
/**
 *  将数字字符串，转换成1，000，000.00格式的字符串(已解决负数问题)
 */
+(NSString *)numStrToNumStrWithSign:(NSString *)numStr;
/**
 *  将数字字符串，转换成1,000
 */
+(NSString *)numDialGaugeWithStr:(NSString *)num;
//获取app版本号
+(NSString*)getAppVersion;

//字符串中是否包含表情符号
+ (BOOL)isHaveEmoji:(NSString *)text;
//字符串中是否有表情符号
+ (BOOL)stringContainsEmoji:(NSString *)string;
//去掉字符串中的表情符号
+ (NSString *)disableEmoji:(NSString *)text;

//计算字符串所占区域大小
+(CGSize)calStrSize:(NSString*)str width:(CGFloat)width font:(UIFont*)font;//CGSizeMake(width, MAXFLOAT)

//根据宽度求高度  content 计算的内容  width 计算的宽度 font字体大小
+ (CGFloat)getLabelHeightWithText:(NSString *)text width:(CGFloat)width fontObjcet: (UIFont *)font;
+ (CGFloat)getLabelHeightWithText:(NSString *)text width:(CGFloat)width font: (CGFloat)font;
//根据高度求宽度
+ (CGFloat)getWidthWithText:(NSString *)text height:(CGFloat)height Font:(UIFont *)font;
/*
 *计算字符串所占区域大小(带有行间距的情况)
 */
+(CGSize)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width lineSpace:(CGFloat)lineSpace;

//判断空字符串
+ (BOOL)isBlankString:(NSString *)string;

//判断中英混合的的字符串长度
+ (int)convertToInt:(NSString*)strtemp;

+ (BOOL)isHeadsetPluggedIn;

//图像数据转成base64
+ (NSString *)imageChangeToBase64:(UIImage *)image;

//去掉字符串首尾空格
+ (NSString *)deleteWhiteSpaceWithString:(NSString *)string;

//字符串是否没超出规定字节数
+ (BOOL)isLealString:(NSString *)string limitStringSizeOf:(int)limitNumber;

//限制字数+省略号
+ (NSString *)cutStringWithString:(NSString *)string SizeOf:(int)limitNumber;

//限制字数
+(NSString *)limitString:(NSString *)string sizeOf:(int)limitNumber;

//判断是否超过2周时间，登录成功后提醒打开通讯录授权(授权关闭情况下)
+ (BOOL)timeOverDays;

//记录首次拒绝通讯录授权时间
+ (void)recoreAdressBookAuthorRejectTime;

//观看人数
+ (NSString *)personNumToString:(NSString * )num;
//人数(超过变万)
+ (NSString *)circlePersonNumberToString:(NSString * )num;

//钱数(超过变万)
+ (NSString *)moneyToString:(NSString *)money;

//钱数（带逗号格式）
+(NSString *)countNumAndChangeformat:(NSString *)num;



////商城图片添加默认前缀
//+(NSString *)shoppingCenterAddDefaultImageUrlPrefix:(NSString *)imageUrl;

//截取某一部分视图
+(UIImage *)captureView:(UIView * )view frame:(CGRect)frame;

//截取全屏
+(UIImage *)captureScreenView:(UIView * )view;

//生成二维码
+(UIImage *)creatQRImageWithUrl:(NSURL *)url;
+ (NSString *)getCacheSizeWithFilePath:(NSString *)path;

//是否为合法手机号
+(BOOL)isMobileNumberAvalible:(NSString *)phone;

//发送验证码一次调用一次,返回值为是否达到单位时间内上限值
+(BOOL)sendValidateCode;

//图片设置透明度
+(UIImage *)imageByApplyingAlpha:(CGFloat)alpha image:(UIImage*)image;

+(id)parseJSONStringToNSDictionary:(NSString *)JSONString;

+(NSString *)fullHTMLStringWithBodyString:(NSString *)bodyString width:(float)width;

//是否为纯数字
+(BOOL)isOrdenaryNumber:(NSString *)number;



+ (UIViewController *)getCurrentVC;//获取当前屏幕显示的viewcontroller

//将数据存储到plist文件中（昵称和头像,盟主号），key为uid
+(void)saveUserInfoToPlistWithUid:(NSString *)uid nickName:(NSString *)nickName avater:(NSString *)avater mengzhuNum:(NSString *)mengzhuNum;
//读取plist中的文件内容
+(NSDictionary *)readfromPlistWithUid:(NSString *)uid;
//活动弹窗是否需要弹出
+(BOOL)readActivityInfofromPlist;
//判断当前手机型号
+(NSString *)iphoneType;

//获取url中的参数并以字典形式返回
+(NSMutableDictionary *)getURLParameters:(NSString *)urlStr;
//移除字典中value值为null的情况
+(NSDictionary *)deleteNullValueWithDic:(NSDictionary *)dic;

//按钮渐变色
+(void)setRadualChangeWithView:(UIView *)view startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint startColor:(UIColor *)startColor endColor:(UIColor *)endColor;

/**
 *  截取URL中的参数
 *
 *  @return NSMutableDictionary parameters
 */
- (NSMutableDictionary *)getURLParameters:(NSString *)urlStr;

//将秒换成分秒
+ (NSString *)getMMSSFromSS:(NSString *)totalTime;
//将秒换成时分秒
+ (NSString *)getHHMMSSFromSS:(NSString *)totalTime;
//将秒换成天时分秒
+ (NSString *)getDDHHMMSSFromSecond:(NSString *)totalTime;
//将时分秒换成秒
+ (NSString *)getSSFromHHMMSS:(NSString *)totalTime;
//将时间转换为几天前
+ (NSString *)ConvertStrToTime:(NSString *)timeStr;
//将今天时间转换为今天
+ (NSString *)ConvertTimeToToday:(NSString *)timeStr;
//时长转化成时分秒类型的
+(NSString *)totalTimeReturnToHMsWithTotalTime:(NSString *)totalTimeStr;
//时长转化成时分秒数字数组
+(NSArray *)totalTimeReturnHMSArrWithTotalTime:(NSString *)totalTimeStr;
//计算时间差
+ (NSString *)insertStarTime1:(NSString *)time1 andInsertEndTime:(NSString *)time2;
//将图片image转成http的图片
+(NSString *)imageChangeToHttpStrWithUrl:(NSString *)url;

//将图片相对路径转成http绝对路径的图片
+(NSString *)imageChangeToAbsoluteUrl:(NSString *)url;
//颜色生成image
+(UIImage*) createImageWithColor:(UIColor*) color;
/// 添加四边阴影效果
+ (void)addShadowToView:(UIView *)theView withColor:(UIColor *)theColor;
/// 添加单边阴影效果
+ (void)addShadowToView:(UIView *)theView withColor:(UIColor *)theColor Offset:(CGFloat)offset;
//设置圆角（内存消耗少）
+ (void)addCornerToView:(UIView *)theView withRect:(CGRect)rect andCornerRadius:(CGSize)size;
//绘制渐变色颜色的方法
+ (CAGradientLayer *)setGradualChangingColor:(UIView *)view fromColor:(NSString *)fromHexColorStr toColor:(NSString *)toHexColorStr;
//添加虚线边框
+ (void)addDottedLineToView:(UIView *)theView withStrokeColor:(UIColor *)strokeColor andFillColor:(UIColor *)fillColor;
//身份证校验码
+ (BOOL)validateIDCardNumber:(NSString *)value;
//URL验证
+ (BOOL) validateUrl:(NSString *)url;
//给某个view设置圆角效果
+(void)bezierPathWithRoundedRect:(CGRect)rect radius:(CGFloat)radius view:(UIView *)view byRoundingCorners:(UIRectCorner)corners;

// iPhoneX、iPhoneXR、iPhoneXs、iPhoneXs Max等
// 判断刘海屏，返回YES表示是刘海屏
// UIView中的safeAreaInsets如果是刘海屏就会发生变化，普通屏幕safeAreaInsets恒等于UIEdgeInsetsZero
+ (BOOL)isNotchScreen:(UIViewController*)controller;

+(long)currentdateInterval;
@end

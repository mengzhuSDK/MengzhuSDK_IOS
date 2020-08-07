






//正式环境
#define MZ_URL_Prefix_online       @"https://cloud.zmengzhu.com"

//测试环境

#define MZ_URL_Prefix_test       @"http://cloud.t.zmengzhu.com"

//开发环境
#define MZ_URL_Prefix_dev       @"http://cloud.dev.zmengzhu.com"

//常量数据
#define MZNET_CODE_OK       @"200"  //获取数据成功

//请求地址前后缀合成
#define MZ_NET_Url(prefixUrl,suffixUrl) [NSString stringWithFormat:@"%@%@?",prefixUrl,suffixUrl]

//__________________________________业务接口地址________________________________________________________
#define MZ_SDK_INIT             @"/api/user/check"
#define MZNET_UserCheck                MZ_NET_Url(MZ_URL_Prefix_online,MZ_SDK_INIT)


#define MZNET_VERSION            [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"]

#define MZNET_FINAL_VERSION     [[MZNET_VERSION componentsSeparatedByString:@"."] count] > 2 ? MZNET_VERSION : [MZNET_VERSION stringByAppendingString:@".0"]

#define MZNET_Atom_CV       [NSString stringWithFormat:@"MZZB_%@.00_I_CN",MZNET_FINAL_VERSION]


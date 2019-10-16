//
//  FoundtionConst.h
//  laoyuegou
//
//  Created by SmallJun on 2019/7/11.
//  Copyright © 2019年 HaiNanLexin. All rights reserved.
//

#ifndef FoundtionConst_h
#define FoundtionConst_h

#define mAvailableString(string) string ? [string idStringValueForDefaultEmtptyString]:@""
#define mNumberString(string) [NSString stringWithFormat:@"%d",[string intValue]]
#define mFloatString(string) [NSString stringWithFormat:@"￥%.2f",[string doubleValue]]

#define SAFE_STRING(a) mAvailableString(a)

#define LY_CHECK_ARRAY(a) (a && ([a isKindOfClass:[NSArray class]] || [a isKindOfClass:[NSMutableArray class]]) && ((NSArray *)a).count > 0)
#define LY_CHECK_DICTIONARY(a) (a && ([a isKindOfClass:[NSDictionary class]] || [a isKindOfClass:[NSMutableDictionary class]]))
#define LY_CHECK_STRING(a) (a && [a isKindOfClass:[NSString class]] && a.length > 0)

#define USER_SET(o,k)    {NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults]; [defaults setObject:o forKey:k]; [defaults synchronize];}
#define USER_SET_B(o,k)  {NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults]; [defaults  setBool:o forKey:k];  [defaults synchronize];}
#define USER_REMOVE(k)   {NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults]; [defaults removeObjectForKey:k]; [defaults synchronize];}

#define USER_GET(k)     [[NSUserDefaults standardUserDefaults] objectForKey:k];
#define USER_GET_B(k)   [[NSUserDefaults standardUserDefaults] boolForKey:k];

//查找响应链中相应的类
#define NEXT_RESPONDER(class) ({\
UIResponder * responder = self.nextResponder;\
while (responder && ![responder isKindOfClass:class]) {\
responder = responder.nextResponder;\
}\
responder;})\

//查找view响应链中相应的类
#define NEXT_RESPONDER_OF(class,view) ({\
UIResponder * responder = view.nextResponder;\
while (responder && ![responder isKindOfClass:class]) {\
responder = responder.nextResponder;\
}\
responder;})\

//image shortcut
#define IMAGENAMED(_pointer) [UIImage imageNamed:_pointer]

//weak self
#define WeakSelf(weakSelf)  __weak __typeof(&*self)weakSelf = self;

//获取当前屏幕的高度
#define mScreenHeight ([UIScreen mainScreen].bounds.size.height)

//获取当前屏幕的宽度
#define mScreenWidth  ([UIScreen mainScreen].bounds.size.width)

//相关于320屏幕宽度的比例
#define GetScaleBy320 (mScreenWidth/320.0)
//相关于375屏幕宽度的比例
#define GetScaleBy375 (mScreenWidth/375.0)

//相关于375屏幕宽度的比例
#define GetScaleHBy667 (mScreenHeight/667.0)
//实际像素相关于320屏幕转换后的大小
#define GetWidthBy320(value) (value)*GetScaleBy320
//实际像素相关于375屏幕转换后的大小
#define GetWidthBy375(value) (value)*GetScaleBy375
//layouttool

#define AdapterValue(value) (value)*GetScaleBy375

//设备机型判断
#define iPhone6Plus CGSizeEqualToSize(CGSizeMake(414,736), [UIScreen mainScreen].bounds.size)

#define iPhone5 CGSizeEqualToSize(CGSizeMake(320,568), [UIScreen mainScreen].bounds.size)

#define iPhone6 CGSizeEqualToSize(CGSizeMake(375,667), [UIScreen mainScreen].bounds.size)

#define iPhone4S CGSizeEqualToSize(CGSizeMake(320,480), [UIScreen mainScreen].bounds.size)

//#define iPhoneX CGSizeEqualToSize(CGSizeMake(375,812), [UIScreen mainScreen].bounds.size)
//#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhoneX (((int)((mScreenHeight/mScreenWidth)*100) == 216)?YES:NO)

/*
 非iPhone X ：
 StatusBar 高20px，NavigationBar 高44px，底部TabBar高49px
 iPhone X：
 StatusBar 高44px，NavigationBar 高44px，底部TabBar高83px
 */
#define LY_IPHONE_STATUS_HEIGHT (iPhoneX ? 44:20) // iPhone 状态栏高度
#define LY_IPHONE_BOTTOM_HEIGHT (iPhoneX ? 34:0)  // iPhone 距底部 Home indicator 边距
#define LY_IPHONE_TABBAR_HEIGHT (iPhoneX ? 83:49) // iPhone Tabbar 高度
#define LY_IPHONE_NAVBAR_HEIGHT (iPhoneX ? 88:64) // iPhone NavigationBar 高度
#define LY_IPHONE_NAVBAR_REAL_HEIGHT 44     // iPhone NavigationBar 真实高度
#define LY_IPHONEX_NAVBARHIDE_HEIGHT (iPhoneX ? 44:0) // iPhone NavigationBar 隐藏

//系统版本比较
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define ColorWithHex(rgbValue)  [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:1.0]

//color shortcut
#define RGBA(r,g,b,a)  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define RGB(r,g,b)  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0f]

#define HEXACOLOR(hexColor,a)  [UIColor colorWithRed:((float)((hexColor & 0xFF0000) >> 16))/255.0f green:((float)((hexColor & 0xFF00) >> 8))/255.0f blue:((float)(hexColor & 0xFF))/255.0f alpha:a]

#define HEXCOLOR(hexColor) HEXACOLOR(hexColor,1.0f)

//字体
#define FONTRegular(f)      [UIFont systemFontOfSize:(f) weight:UIFontWeightRegular]
#define FONTMedium(f)       [UIFont systemFontOfSize:(f) weight:UIFontWeightMedium]
#define FONTSemibold(f)     [UIFont systemFontOfSize:(f) weight:UIFontWeightSemibold]


#endif /* FoundtionConst_h */

**项目框架更改为ARC模式，非ARC模式下请为相关文件添加 -fobjc-arc 标签。

**注意inmobi原生每次只能请求一条。京东原生需要手动去AdNativeAdapterJDAdview.m文件里设置图标尺寸，并且图片为正方形以及没有大图。

**使用广点通原生，必须实现聚合原生的代理方法viewControllerForPresentingModalView，否则会崩溃。

**使用同种类多个广告时，注意某些平台因为是单例模式，有可能出现同时请求同个单例而导致代理失效。

**因广告有一定的生存周期，请不要间隔太久才去调用(showAdInstlView:)方法，以免广告失效造成损失。

**AdViewSDK开发包附带了所有支持的广告平台,但是安沃6.9版本和万普(Waps)3.0版本有重名文件,因此您将不得不舍弃其中一个广告平台。

**力美、触控、易积分、米迪和万普平台均为墙和条一体的sdk库，因为墙的问题可能存在审核不通过的风险。

**多盟开屏和视频内部文件重复，使用其中一个须将另一个的.a以及adapter文件删除。

**欧朋和易积分内部文件重复，使用其中一个须将另一个的.a以及adapter文件删除。

**iOS9更改为默认使用https，所以需在info.plist文件中添加以下配置信任所有http服务:
1.在Info.plist中添加NSAppTransportSecurity类型Dictionary。
2.在NSAppTransportSecurity下添加 NSAllowsArbitraryLoads类型Boolean,值设为YES。

**集成Appnext平台时，须在BuildSetting的Header Search Path里添加路径名称，例如$(PROJECT_DIR)/AdViewSDK-3.4.2/AdNetworks/Appnext/lib/include

========================================
平台名称		中文名称		版本号
Adwo		安沃		7.0
adChina		易传媒		3.2.4
AdFracta			4.0
Baidu		百度		v4.5
chartboost			6.4.4
DianRu		点入		4.6
Domob		多盟		3.5.2
GDTMob		广点通		4.5.6
AdMob				7.18.0
GuoHe		智游汇（果合）	2.1.7
Guomob		果盟		4.2.7
InMobi				6.1.2
Lmmob		力美		2.9.0
Miidi		米迪		2.0
MillennialMedia			6.3.1
MobiSage	艾德思齐		7.0.6
Chance	 	畅思（触控）	6.4.3
SmartMad	亿动智道		3.0.6
Tanx		阿里妈妈		5.6.1
Vpon				4.6.3
Waps		万普		3.0
WQMobile	帷千		3.3.3
YiJiFen		易积分		v4.0
YouMi		有米		2.1.3
XingYun		行云		v2.3
Mopan		磨盘		v1.0.1
AdPro		光音		v2.0.0
JDAdview	京东		v1.3
AdSmar		纷熙移动		v2.1.2
MobFox				3.1.6
STMob		舜飞		2.0.4
Unity				2.0
Opera		欧朋		1.0
AdColony			3.1.0
Appnext             1.8.1

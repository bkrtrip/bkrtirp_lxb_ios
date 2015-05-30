//
//  ToolMacro.h
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/5/30.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#ifndef LXBtrip_ToolMacro_h
#define LXBtrip_ToolMacro_h

//程序根window
#define APP_WINDOW [[UIApplication sharedApplication].windows objectAtIndex:0]

//获取设备屏幕尺寸
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)//应用尺寸
#define APP_WIDTH [[UIScreen mainScreen]applicationFrame].size.width
#define APP_HEIGHT [[UIScreen mainScreen]applicationFrame].size.height

// 封装一个导航控制器
#define NavC(vc) [[UINavigationController alloc] initWithRootViewController:vc]

//定义UIImage对象
#define ImageNamed(_pointer) [UIImage imageNamed:_pointer]

#endif

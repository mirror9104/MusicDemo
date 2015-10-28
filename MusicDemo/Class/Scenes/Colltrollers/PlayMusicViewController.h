//
//  PlayMusicViewController.h
//  MusicDemo
//
//  Created by lanou3g on 15/9/22.
//  Copyright © 2015年 Mr.yao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayMusicViewController : UIViewController
@property( nonatomic ,assign)NSInteger index;//接受下标
//单利方法
+(PlayMusicViewController *)sharePlayMusicViewController;




@end

//
//  AudioPlayerManager.h
//  MusicDemo
//
//  Created by lanou3g on 15/9/23.
//  Copyright © 2015年 Mr.yao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MusicModel.h"
#import <UIKit/UIKit.h>

@protocol AudioPlayerManagerDelegate  <NSObject>

- ( void)getCurrentTime:(NSString *)currentTime totalTime:( NSString *)totalTime progress:( CGFloat )progress;
//播放结束
- (void)audioPlayToEnd;

@end



@interface AudioPlayerManager : NSObject

@property( nonatomic ,strong)MusicModel *music;//属性 通过属性中的实例  传入播放的歌曲网址 主要是要网址
@property( nonatomic ,assign)BOOL isPlaying;
@property( nonatomic, weak)id<AudioPlayerManagerDelegate>delegate; //代理方法


+(AudioPlayerManager *)shareAudioPlayManager;


//给外界开辟一个播放的方法 播放
-( void)playMusic;

//准备播放
-( void)prepareMusic;

//暂停
- ( void)pauseMusic;

//按照滑动 播放 自定义播放
- (void)seekToTime:( CGFloat )time;
//获取歌词 通过Model 返回一个歌词的数组
-( NSArray *)getLyricArr;

//通过当前播放时间 放回对应下标 .
-( NSInteger)getIndexWithCurrentTime:( NSString *)time;


@end

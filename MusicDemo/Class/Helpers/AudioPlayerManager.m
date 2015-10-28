//
//  AudioPlayerManager.m
//  MusicDemo
//
//  Created by lanou3g on 15/9/23.
//  Copyright © 2015年 Mr.yao. All rights reserved.
//

#import "AudioPlayerManager.h"
#import "LyricModel.h"
#import <AVFoundation/AVFoundation.h>//引入AVFoundation/AVFoundation.h 框架 要用他的播放功能
//@import AVFoundation; 作用一样

@interface AudioPlayerManager  ()

//延展中 私有 外界拿不到  ....
@property( nonatomic ,strong)AVPlayer *player;
@property(nonatomic,strong)NSTimer *timer;
@property( nonatomic ,strong)NSMutableArray *lyricArray;
@end

static AudioPlayerManager *audioPlayManager = nil;
@implementation AudioPlayerManager


+(AudioPlayerManager *)shareAudioPlayManager{
    @synchronized(self) {
        if (audioPlayManager ==nil) {
            audioPlayManager = [[ AudioPlayerManager alloc]init];
        }
    }
    return audioPlayManager;
}

//初始化AVPlayer  使用init 方法 给上面属性中的player 初始化init
-(instancetype)init{
    //self = [ super init];
    if (self) {
        self.player = [ AVPlayer new];
    //通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playMusicEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];

    }
    return self;
}

-( void )playMusicEnd{
    if (_delegate && [ _delegate respondsToSelector:@selector(audioPlayToEnd)]) {
        [ _delegate audioPlayToEnd];
    }
    
}




//准备播放 
-( void)prepareMusic{
    
    //判断当前的item 是否有观察者 要是有 就移除 一个属性同时不能用两个观察者
    //如果有已经有了观察者去观察这个item  , 需要移除 
    if (self.player.currentItem ) {
        [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    }
    
    
    
    //初始化AVPlayerItem 的一个对象 添加观察者
    AVPlayerItem *item= [[ AVPlayerItem alloc]initWithURL:[ NSURL URLWithString: self.music.mp3Url]];
    
    //观察属性 判断是否播放 status是AVPlayerItem 中的属性
    [ item addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) context:nil];
    //把 play 替换为当前的我们初始化item
    [ self.player replaceCurrentItemWithPlayerItem:item];//替换 将当前的item 替换位我们初始化的item 
    
}

/*
 typedef NS_ENUM(NSInteger, AVPlayerItemStatus) {
	AVPlayerItemStatusUnknown,
	AVPlayerItemStatusReadyToPlay,
	AVPlayerItemStatusFailed
 };
 */


//实现观察者的方法
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    NSLog(@"--------%@",keyPath);
    NSLog(@"+++++%@",change);
    if ([keyPath isEqualToString:@"status"]) {
        
        //接受返回的枚举值  因为AVPlayerItemStatus 中定义的这个status 是一个枚举值 就是常量数  后面的方法获取的是字典中的数据 需要转化一下
        //通过key 拿到对象 用status接收
        AVPlayerItemStatus status = [[change valueForKey:@"new"] integerValue];//  获取change字典中的new   枚举转化 枚举时数字 1 2 3 之类的常量

        //判断播放条件
        switch (status) {
            case 0:
            { NSLog(@"未知");
                break;
            }
            case 1:{
                [ self playMusic];
                break;
            }
                
            case 2:{
                NSLog(@"播放失败");
                break;
            }
            default:
                break;
        }
    }
}

//暂停
- ( void)pauseMusic{
    //暂停的时候 让time 置为nil
    [ self.timer invalidate];
    self.timer = nil;
    
    
    
    self.isPlaying =NO;
    [self.player pause];
}


//给外界开辟一个播放的方法  实现播放方法
-( void)playMusic{

    self.isPlaying=YES;
    
    if (self.timer) {
            return;
        }
    
    [self.player play];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timeAction) userInfo:nil repeats:YES];
}
//NSTimer的方法 主要用来调用代理的方法
-( void)timeAction
{
    //安全判断
    if (_delegate && [ _delegate respondsToSelector:(@selector(getCurrentTime:totalTime:progress:))]) {
        
        [ _delegate getCurrentTime:[ self transfromWith:[ self currentTimeValue]] totalTime:[ self transfromWith:[ self totalTimeValue]] progress:[ self propress]];
    }
}

//当前时间
-( NSInteger )currentTimeValue{
    return  self.player.currentTime.value/self.player.currentTime.timescale;
}
//总时间
-( NSInteger)totalTimeValue{
    //总时长
    CMTime time = [self.player.currentItem duration];
    if (time.timescale == 0) {
        return 1 ;
    }else {
        return  time .value / time.timescale;
    }
}

//进度
-( CGFloat)propress{
    return (CGFloat)[ self currentTimeValue ]/(CGFloat)[ self totalTimeValue];
}

//转化字符串
-(NSString *)transfromWith:( NSInteger)time{
    return [ NSString stringWithFormat:@"%.2ld:%.2ld",time/60 ,time%60];//分和秒
}

//按照滑动 播放 自定义播放
- (void)seekToTime:( CGFloat )time{
    //点击滑动时 暂停
    [ self pauseMusic];
    
    // 比例
    [ self.player seekToTime:(CMTimeMake(time * [ self totalTimeValue], 1)) completionHandler:^(BOOL finished) {
        if (finished) {
            [self playMusic];
        }
    }];
}


//获取歌词 通过Model 返回一个歌词的数组
-( NSArray *)getLyricArr{
    self.lyricArray  = [ NSMutableArray array];
    for (NSString *str in self.music.timelyric ) {
        
//        if ([str isEqualToString:@""]) {
//            break;
//        }
        
        NSArray *lyricArr = [ str componentsSeparatedByString:@"]"];
        
        if ([lyricArr.firstObject length] < 1) {
            continue;
        }
        
        
        NSString *timeStr = [lyricArr.firstObject substringWithRange:NSMakeRange(1, 5)];//这是截取的时间
        
        LyricModel *lyricModel = [[ LyricModel alloc]initWithLyricTime:timeStr LyricStr: lyricArr.lastObject];
        //添加
        [self.lyricArray addObject:lyricModel];
    }
    return self.lyricArray;
}
//通过当前播放时间 返回回对应下标 .
-( NSInteger)getIndexWithCurrentTime:( NSString *)time{
    
    NSInteger index = -1 ;
    
    for (int i = 0; i < self.lyricArray.count; i++) {
        if ([[self.lyricArray[i] lyricTime] isEqualToString:time ]) {
            index = i;
        }
    }
    return index;
}

@end

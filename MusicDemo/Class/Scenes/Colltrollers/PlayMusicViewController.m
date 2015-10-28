//
//  PlayMusicViewController.m
//  MusicDemo
//
//  Created by lanou3g on 15/9/22.
//  Copyright © 2015年 Mr.yao. All rights reserved.
//

#import "PlayMusicViewController.h"
#import "AudioPlayerManager.h"
#import "GetDataManager.h"
#import "UIImageView+WebCache.h"
#import "LyricModel.h"
@interface PlayMusicViewController ()<AudioPlayerManagerDelegate>

@property( nonatomic,assign)NSInteger temp;//存储同一首歌
@property (weak, nonatomic) IBOutlet UIImageView *musicImageView;
@property (weak, nonatomic) IBOutlet UILabel *currentTime;
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
@property (weak, nonatomic) IBOutlet UILabel *totalTime;
@property (weak, nonatomic) IBOutlet UITableView *playMusicTableView;

@end
static PlayMusicViewController *playMusicViewController = nil;
@implementation PlayMusicViewController

+(PlayMusicViewController *)sharePlayMusicViewController{
    @synchronized(self) {
        if (playMusicViewController == nil) {
                 playMusicViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"playMusic"];
        }
    }
    return playMusicViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //透明度关了
//    self.navigationController.navigationBar.translucent = NO;
    
    //关闭scorllView 的偏移量
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //个temp 一个初始值 因为下标是0 的传不过来的
    self.temp = -1;
    
    //设置代理
    [AudioPlayerManager shareAudioPlayManager] .delegate = self;
    
    
//    //通过下标找歌曲 给AudioPlayerManager 中的music 赋值
//    [AudioPlayerManager shareAudioPlayManager ].music = [[ GetDataManager shareGetDataManager]getModelWithIndexPath:self.index];
//    //准备播放
//    [[ AudioPlayerManager shareAudioPlayManager]prepareMusic];
    
    //强制走storyBoard 加载视图
    [self.musicImageView layoutIfNeeded];
    //切圆
    self.musicImageView.layer.masksToBounds = YES;
    self.musicImageView.layer.cornerRadius = self.musicImageView.frame.size.height / 2;
 
}


-(void)viewWillAppear:(BOOL)animated{
    [ super viewWillAppear:animated];
    if (self.temp == self.index) {
        return;
    }else {
        [ self play];
    }

}

//播放 给AudioPlayerManager 的model赋值 并且调用准备播放的方法
-( void)play{
    //记录当前歌曲 为了让temp 记录index的值 用来做判断 ( 是否需要切歌 )
    self.temp = self.index;
    
    //通过下标找歌曲 给AudioPlayerManager 中的music(model) 赋值
    [AudioPlayerManager shareAudioPlayManager ].music = [[ GetDataManager shareGetDataManager]getModelWithIndexPath:self.index];
    //准备播放
    [[ AudioPlayerManager shareAudioPlayManager]prepareMusic];
    
    //加载图片
    [ self .musicImageView sd_setImageWithURL:[ NSURL URLWithString:[ AudioPlayerManager shareAudioPlayManager].music.picUrl] placeholderImage:nil];
    [ self.playMusicTableView reloadData];

    
}

//方法
//上一首
- (IBAction)LastSong:(id)sender {
    if (self.index >0) {
        self.index--;
    }else{
        self.index = [ GetDataManager shareGetDataManager].count - 1 ;
    }
    [ self play];
}

//暂停
- (IBAction)pauseOrPlay:(id)sender {
    //如果是YES  就表示正在播放  所以将其结束
    if ([ AudioPlayerManager shareAudioPlayManager].isPlaying) {
        [[ AudioPlayerManager shareAudioPlayManager]pauseMusic];
    }else{
        //表示已经结束 就是在暂停状态 点击就是继续播放
        [[ AudioPlayerManager shareAudioPlayManager]playMusic];
    }
    
    
}

//下一首
- (IBAction)nextSong:(id)sender {
    
    if (self.index  < [ GetDataManager shareGetDataManager].count -1) {
        self.index ++;
    }else {
        self.index = 0 ;
    }
    [ self play];
}

//UISlider 滑动方法
- (IBAction)progressSlider:(UISlider *)sender {
    [[ AudioPlayerManager shareAudioPlayManager]seekToTime:sender.value];//传一个UISlider 的值
    
}

#pragma mark - 代理方法
//实现代理的方法
-(void)getCurrentTime:(NSString *)currentTime totalTime:(NSString *)totalTime progress:(CGFloat)progress{
    self.currentTime.text = currentTime;
    self.totalTime .text = totalTime;
    self.progressSlider.value = progress;
    NSLog(@"%@",currentTime);
    NSLog(@"哈哈");

    
    //按照计时器的方法 旋转  每隔0.1 秒旋转
    //改变musicImageView的 transform
    self.musicImageView.transform = CGAffineTransformRotate(self.musicImageView.transform, M_PI/180);
    
//接受对应的下标
   NSInteger index = [[ AudioPlayerManager shareAudioPlayManager]getIndexWithCurrentTime:currentTime];
    if (index == -1) {
        return;
        
    }
    
    [self.playMusicTableView selectRowAtIndexPath:[ NSIndexPath indexPathForRow:index inSection:0] animated:YES scrollPosition:(UITableViewScrollPositionMiddle)];
    
}

-(void)audioPlayToEnd{
    //播放结束 直接掉下一首
    [ self pauseOrPlay:nil ];//先暂停一下 在播放
    [ self nextSong:nil];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-( NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[ AudioPlayerManager shareAudioPlayManager ]getLyricArr].count;

   
}
-( UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [ tableView dequeueReusableCellWithIdentifier:@"playMusicCell_id" forIndexPath:indexPath];
    
    //歌词赋值
    LyricModel *lyricModel = [[AudioPlayerManager shareAudioPlayManager]getLyricArr][ indexPath.row];
    
    cell.textLabel.text = lyricModel.lyricStr;
    
    cell.textLabel.textAlignment = 1;
    //定义一个view 贴到cell上  选中当前cell  使其背景颜色变化  语法糖
    cell.selectedBackgroundView= ({
        UIView *view = [ UIView new];
        view.backgroundColor = [ UIColor redColor];
        view;
    }); 
    return cell;
 
}


@end

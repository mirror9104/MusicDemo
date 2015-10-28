//
//  MusicModel.h
//  MusicDemo
//
//  Created by lanou3g on 15/9/22.
//  Copyright © 2015年 Mr.yao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicModel : NSObject

@property( nonatomic ,strong)NSString *mp3Url;//音乐地址
@property( nonatomic ,strong)NSString *ID;//id
@property( nonatomic,strong)NSString *name;//歌名
@property( nonatomic ,strong)NSString *picUrl;//图片地址
@property( nonatomic ,strong)NSString *blurPicUrl;//模糊图片地址
@property( nonatomic ,strong)NSString *album;//专辑
@property( nonatomic ,strong)NSString *singer;//歌手
@property( nonatomic ,strong)NSString *duration;//时长
@property( nonatomic ,strong)NSString *artists_name;//作曲
@property( nonatomic ,strong)NSArray *timelyric;//歌词


@end

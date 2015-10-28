//
//  LyricModel.h
//  MusicDemo
//
//  Created by lanou3g on 15/9/24.
//  Copyright © 2015年 Mr.yao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LyricModel : NSObject

@property( nonatomic ,strong)NSString * lyricTime;//歌词的时间
@property( nonatomic ,strong)NSString * lyricStr;//歌词

-(instancetype)initWithLyricTime:( NSString *)lyricTime
                        LyricStr:( NSString *)lyricStr;


@end

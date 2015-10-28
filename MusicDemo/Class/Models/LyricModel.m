//
//  LyricModel.m
//  MusicDemo
//
//  Created by lanou3g on 15/9/24.
//  Copyright © 2015年 Mr.yao. All rights reserved.
//

#import "LyricModel.h"

@implementation LyricModel

- (instancetype)initWithLyricTime:(NSString *)lyricTime LyricStr:(NSString *)lyricStr
{
    self = [super init];
    if (self) {
        _lyricTime = lyricTime;
        _lyricStr = lyricStr;
    }
    return self;
}

@end

//
//  MusicModel.m
//  MusicDemo
//
//  Created by lanou3g on 15/9/22.
//  Copyright © 2015年 Mr.yao. All rights reserved.
//

#import "MusicModel.h"

@implementation MusicModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
    if ([key isEqualToString:@"lyric"]) {
        //歌词 + 时间
        self.timelyric = [value componentsSeparatedByString:@"\n"];
    }
    
}
@end

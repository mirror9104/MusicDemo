//
//  MusicListCell.m
//  MusicDemo
//
//  Created by lanou3g on 15/9/22.
//  Copyright © 2015年 Mr.yao. All rights reserved.
//

#import "MusicListCell.h"
#import "MusicModel.h"
#import"UIImageView+WebCache.h"
@implementation MusicListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

//通过Model的set方法赋值 重写Model的set 方法 给控件赋值
-(void)setModel:(MusicModel *)model{
    self.musicName.text= model.name;
    self.singer .text = model.singer;
    [ self.musicImageView sd_setImageWithURL:[ NSURL URLWithString:model.picUrl] placeholderImage:nil];
}

@end

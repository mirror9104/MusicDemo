//
//  MusicListCell.h
//  MusicDemo
//
//  Created by lanou3g on 15/9/22.
//  Copyright © 2015年 Mr.yao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MusicModel ;
@interface MusicListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *musicImageView;

@property (weak, nonatomic) IBOutlet UILabel *musicName;

@property (weak, nonatomic) IBOutlet UILabel *singer;

@property( nonatomic ,strong)MusicModel *model;//给控件赋值


@end

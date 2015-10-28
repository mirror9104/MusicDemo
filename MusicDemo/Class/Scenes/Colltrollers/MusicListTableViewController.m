//
//  MusicListTableViewController.m
//  MusicDemo
//
//  Created by lanou3g on 15/9/22.
//  Copyright © 2015年 Mr.yao. All rights reserved.
//

#import "MusicListTableViewController.h"
#import "MusicListCell.h"
#import "GetDataManager.h"
#import "PlayMusicViewController.h"
#define kMusicListURL @"http://project.lanou3g.com/teacher/UIAPI/MusicInfoList.plist"


@interface MusicListTableViewController ()

@end

@implementation MusicListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //注册
    [ self.tableView registerNib:[ UINib nibWithNibName:@"MusicListCell" bundle:[ NSBundle mainBundle]] forCellReuseIdentifier:@"MusicList_id"];
    //请求数据 
    [[ GetDataManager shareGetDataManager]getDataWithUrl:kMusicListURL Block:^{
        //block 回调 刷新界面 才会给空间赋值 通过block 回调 刷新数据
        //2 .内部的block 执行完毕 然后执行这个语句
        [self.tableView reloadData];
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [ GetDataManager shareGetDataManager].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MusicListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MusicList_id" forIndexPath:indexPath];
    
    //通过从新写cell.model 的的set方法 赋值
   cell.model =  [[ GetDataManager shareGetDataManager]getModelWithIndexPath:indexPath.row];
    return cell;
}

-( CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 145;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //通过桥的id 去跳转页面 PS : show 默认是push 如果有navigation 那么show 就是模态 showDetail就是模态
    //[self performSegueWithIdentifier:@"playMusic_id" sender:nil];
 
//    // 通过MainStoryBoard 获取
//    PlayMusicViewController *playVC = [[ UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"playMusic"];
//   //push 过去
//    [self showViewController:playVC sender:nil];
    
    
    PlayMusicViewController *playVC= [ PlayMusicViewController sharePlayMusicViewController];
     //传值 直接串一个小标 直接串一个下标 在后面
    playVC.index  = indexPath.row;
    [ self showViewController:playVC sender:nil];
    
   
}




@end

//
//  GetDataManager.m
//  MusicDemo
//
//  Created by lanou3g on 15/9/22.
//  Copyright © 2015年 Mr.yao. All rights reserved.
//

#import "GetDataManager.h"
#import "MusicModel.h"

@interface GetDataManager()

@property( nonatomic ,strong)NSMutableArray *musicListArray;//延展 用来存放model的数组 

@end


static GetDataManager *getDataManager = nil;

@implementation GetDataManager

+( GetDataManager *)shareGetDataManager{
    @synchronized(self) {
        if (getDataManager ==nil) {
            getDataManager = [[ GetDataManager alloc]init];
            }
    }
    return getDataManager;
}


//请求数据的方法
-(void)getDataWithUrl:(NSString *)url Block:(myBlok)block{
    
    //开辟线程 请求数据 让一个线程区请求数据  但是之前提过  数据请求玩 赋值什么的要在主线程 所以后面那个block 语法块给他加了一个约数 这个条件就是让在子线程请求完成的数据  回到了主线程区赋值
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //子线程执行耗时操作m
        NSArray *array= [ NSArray arrayWithContentsOfURL:[ NSURL URLWithString:url]];
        
        //NSLog(@"%@",array);
        for (NSDictionary *dic in array) {
 
            MusicModel *musicModel = [ MusicModel new];
            [ musicModel setValuesForKeysWithDictionary:dic];
            [self.musicListArray addObject:musicModel];
        }
         //当子线程完毕数据请求结束 ( 也就是当数据加载完成  回到主线程 调用block ) 回到主线程 区赋值 执行这个语法块
       dispatch_async(dispatch_get_main_queue(), ^{//回到主线程 执行赋值刷新 主要功能 
           //这个是前面调用block方法 时 这个例子中 是刷新数据
           block();
           // 1 . 相对于外界调用block 首相执行的是这一步  然后才会出去
       });
        
    }); 
}

//通过数组下标 获取每一元素为歌曲的Model类 
-(MusicModel *)getModelWithIndexPath:(NSInteger)index{
    return  self.musicListArray[ index];
}


//数组的懒加载( 懒加载 当这个数组在需要的时候才会区创建数组 使用  用到的时候才会去初始化 开辟 在这个里面是在数组中添加元素的时候 [self.musicListArray addObject:musicModel] 才会创建) 就是get方法  取值
-(NSMutableArray *)musicListArray{
    if (!_musicListArray) {//为空
        _musicListArray = [ NSMutableArray array];
    }
    return _musicListArray;
}
//重写get 方法 数组个数
-(NSInteger )count{
    return self.musicListArray.count;
}

@end

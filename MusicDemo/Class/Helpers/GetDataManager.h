//
//  GetDataManager.h
//  MusicDemo
//
//  Created by lanou3g on 15/9/22.
//  Copyright © 2015年 Mr.yao. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MusicModel;//防止循环导入

typedef void(^myBlok)();
@interface GetDataManager : NSObject
@property( nonatomic ,assign)NSInteger count;//记录数组的个数 给外界返回cell 的row行数使用


//单列方法
+(GetDataManager *)shareGetDataManager;
//请求数据的方法
- (void)getDataWithUrl:( NSString *)url Block:( myBlok)block;

//获取music的Model 数组中的元素是music 的Model  通过下标 返回Model 
-(MusicModel *)getModelWithIndexPath:(NSInteger)index;
@end

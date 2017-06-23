//
//  FinanceInfo.h
//  FinancialStatistics
//
//  Created by LOLITA on 17/6/15.
//  Copyright © 2017年 LOLITA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FinanceInfo : NSObject
@end


@interface Item : NSObject
@property(copy,nonatomic)NSString *key;
@property(copy,nonatomic)NSString *value;
@end



/*---------------------------------------------分析模块数据模型---------------------------------------------*/

@interface AnalysisInfo : NSObject
/**
 标题
 */
@property(copy,nonatomic)NSString *title;
/**
 数据数组
 */
@property(strong,nonatomic)NSArray <Item * > *subDatas;
@end





/*---------------------------------------------业绩模块数据模型---------------------------------------------*/

@interface PerformanceInfo : NSObject
/**
 图例标题数组
 */
@property(strong,nonatomic)NSArray *legendTitles;
/**
 图例Legend
 */
@property(strong,nonatomic)NSArray <Item *>*legendItems;
/**
 X轴标题数组
 */
@property(strong,nonatomic)NSArray *XAxisTitles;
/**
 Y轴标题数组
 */
@property(strong,nonatomic)NSArray *YAxisTitles;
/**
 X轴数据数组
 */
@property(strong,nonatomic)NSArray *XAxisDatas;
/**
 Y轴数据数组
 */
@property(strong,nonatomic)NSArray *YAxisDatas;

/**
 柱状图颜色数组
 */
@property(strong,nonatomic)NSArray <UIColor *> *colors;

@end
























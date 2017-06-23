//
//  FinanceChartView.h
//  FinancialStatistics
//
//  Created by LOLITA on 17/6/15.
//  Copyright © 2017年 LOLITA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FinanceInfo.h"

typedef enum : NSUInteger {
    FinanceIndex,               //主要指标
    FinanceQuarterlyProfit,     //净利润
    FinanceEPS,                 //每股收益
} FinanceType;

@interface FinanceChartView : UIView

/**
 图例类型
 */
@property(assign,nonatomic)FinanceType financeType;

/**
 数据数组
 */
@property(strong,nonatomic)PerformanceInfo *pi;


-(instancetype)initWithFrame:(CGRect)frame withType:(FinanceType)type;

@end











/**
 图例视图
 */
@interface LegendView : UIView

/**
 图例图片
 */
@property(strong,nonatomic)UIImageView *iconImageView;

/**
 图例标题
 */
@property(strong,nonatomic)UILabel *legendLabel;

@end

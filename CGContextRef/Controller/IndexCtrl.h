//
//  IndexCtrl.h
//  CGContextRef
//
//  Created by LOLITA on 17/6/23.
//  Copyright © 2017年 LOLITA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FinanceInfo.h"

#import "TitleView.h"
#import "FinanceChartView.h"

@interface IndexCtrl : UIViewController

@property(strong,nonatomic)UIScrollView *PerformanceScrollView;     //业绩
@property(strong,nonatomic)TitleView *indexTitleView;               //主要指标
@property(strong,nonatomic)TitleView *quarterlyProfitView;          //季度利润
@property(strong,nonatomic)TitleView *EPSView;                      //每股收益


@property(strong,nonatomic)FinanceChartView *indexChartView;            //主要指标chartView
@property(strong,nonatomic)FinanceChartView *quarterlyProfitChartView;  //季度利润chartView
@property(strong,nonatomic)FinanceChartView *EPSChartView;              //每股收益ChartView


@end

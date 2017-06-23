//
//  IndexCtrl.m
//  CGContextRef
//
//  Created by LOLITA on 17/6/23.
//  Copyright © 2017年 LOLITA. All rights reserved.
//

#import "IndexCtrl.h"
NSString * const AnalysisTableCellId = @"AnalysisTableCellId";

#define kTitleViewHeight 70
#define kChartViewHeight 200


@interface IndexCtrl ()

@property(strong,nonatomic)NSArray *datas,*perFormanceDatas;

@end

@implementation IndexCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self initUI];
    
    [self initData];
    
}

#pragma mark 初始化UI
/**
 初始化UI
 */
-(void)initUI{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (self.PerformanceScrollView==nil) {
        self.PerformanceScrollView = [[UIScrollView alloc] initWithFrame:kScreenBounds];
        self.PerformanceScrollView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:self.PerformanceScrollView];
        self.PerformanceScrollView.contentSize = CGSizeMake(0, (kTitleViewHeight+kChartViewHeight)*3);
    }
    //初始化标题View
    [self initTitleViews];
    //初始化ChartView
    [self initChartViews];
}



/**
 初始化标题View
 */
-(void)initTitleViews{
    if (self.indexTitleView==nil) {
        self.indexTitleView = [[TitleView alloc] initWithFrame:CGRectMake(0, 0, self.PerformanceScrollView.viewWidth, kTitleViewHeight)];
        self.indexTitleView.titleLabel.text = @"";
        self.indexTitleView.subTitleLabel.text = @"";
        [self.PerformanceScrollView addSubview:self.indexTitleView];
    }
    if (self.quarterlyProfitView==nil) {
        self.quarterlyProfitView = [[TitleView alloc] initWithFrame:CGRectMake(0, (kTitleViewHeight+kChartViewHeight)*1, self.PerformanceScrollView.viewWidth, kTitleViewHeight)];
        self.quarterlyProfitView.titleLabel.text = @"";
        self.quarterlyProfitView.subTitleLabel.text = @"";
        [self.PerformanceScrollView addSubview:self.quarterlyProfitView];
    }
    if (self.EPSView==nil) {
        self.EPSView = [[TitleView alloc] initWithFrame:CGRectMake(0, (kTitleViewHeight+kChartViewHeight)*2, self.PerformanceScrollView.viewWidth, kTitleViewHeight)];
        self.EPSView.titleLabel.text = @"";
        self.EPSView.subTitleLabel.text = @"";
        [self.PerformanceScrollView addSubview:self.EPSView];
    }
}

/**
 初始化chartView
 */
-(void)initChartViews{
    if (self.indexChartView==nil) {
        self.indexChartView = [[FinanceChartView alloc] initWithFrame:CGRectMake(self.indexTitleView.x, self.indexTitleView.bottom, self.indexTitleView.viewWidth, kChartViewHeight) withType:FinanceIndex];
        self.indexChartView.backgroundColor = [UIColor whiteColor];
        [self.PerformanceScrollView addSubview:self.indexChartView];
    }
    if (self.quarterlyProfitChartView==nil) {
        self.quarterlyProfitChartView = [[FinanceChartView alloc] initWithFrame:CGRectMake(self.quarterlyProfitView.x, self.quarterlyProfitView.bottom, self.quarterlyProfitView.viewWidth, kChartViewHeight) withType:FinanceQuarterlyProfit];
        self.quarterlyProfitChartView.backgroundColor = [UIColor whiteColor];
        [self.PerformanceScrollView addSubview:self.quarterlyProfitChartView];
    }
    if (self.EPSChartView==nil) {
        self.EPSChartView = [[FinanceChartView alloc] initWithFrame:CGRectMake(self.EPSView.x, self.EPSView.bottom, self.EPSView.viewWidth, kChartViewHeight) withType:FinanceEPS];
        self.EPSChartView.backgroundColor = [UIColor whiteColor];
        [self.PerformanceScrollView addSubview:self.EPSChartView];
    }
}




#pragma mark 获取数据
/**
 获取数据
 */
-(void)initData{
    
    //业绩
    NSMutableArray *perFormanceDatasTmp = [NSMutableArray array];
    PerformanceInfo *pi0 = [PerformanceInfo new];
    PerformanceInfo *pi1 = [PerformanceInfo new];
    PerformanceInfo *pi2 = [PerformanceInfo new];
    
    
    pi0.legendTitles = @[@"主要指标"];
    NSMutableArray *tmp = [NSMutableArray array];
    for (int i=0; i<3; i++) {
        Item *item = [Item new];
        if (i==0)
        {
            item.key = @"index";
            item.value = @"营业收入(亿元)";
        }
        else if (i==1)
        {
            item.key = @"index";
            item.value = @"1-4季度";
        }
        else if (i==2)
        {
            item.key = @"EPS";
            item.value = @"同比增长(%)";
        }
        [tmp addObject:item];
    }
    pi0.legendItems = [tmp copy];
    pi0.XAxisTitles = @[@"2013",@"2014",@"2015",@"2016",@"2017"];
    pi0.XAxisDatas = @[@[@"1234",@"1234",@"1555",@"1666"],@[@"1234",@"900",@"2777",@"1256"],@[@"1234",@"900",@"988",@"890"],@[@"2000",@"1500",@"300",@"1222"],@[@"1000"]];
    pi0.YAxisTitles = @[@"6",@"-35",@"-90"];
    pi0.YAxisDatas = @[@"-18",@"2",@"-20",@"0",@"-80"];
    
    
    
    
    tmp = [NSMutableArray array];
    for (int i=0; i<2; i++) {
        Item *item = [Item new];
        if (i==0)
        {
            item.key = @"index";
            item.value = @"净利润(万元)";
        }
        else if (i==1)
        {
            item.key = @"EPS";
            item.value = @"同比增长(%)";
        }
        [tmp addObject:item];
    }
    pi1.legendTitles = @[@"利润"];
    pi1.legendItems = [tmp copy];
    pi1.XAxisTitles = @[@"2013",@"2014",@"2015",@"2016",@"2017"];
    pi1.XAxisDatas = @[@"3585.3",@"-3105.3",@"3585.3",@"4584.1",@"1585.5"];
    pi1.YAxisTitles = @[@"300",@"105",@"-75"];
    pi1.YAxisDatas = @[@"240",@"0",@"120",@"250",@"-50"];
    
    
    
    Item *item = [Item new];
    item.key = @"EPS";
    item.value = @"同比增长(%)";
    pi2.legendTitles = @[@"每股利润"];
    pi2.legendItems = @[item];
    pi2.XAxisTitles = @[@"2013",@"2014",@"2015",@"2016",@"2017"];
    pi2.XAxisDatas = @[];
    pi2.YAxisTitles = @[@"1.58",@"0.81",@"0.6"];
    pi2.YAxisDatas = @[@"1.38",@"1.48",@"0.94",@"1.36",@"0.76"];
    
    
    [perFormanceDatasTmp addObject:pi0];
    [perFormanceDatasTmp addObject:pi1];
    [perFormanceDatasTmp addObject:pi2];
    self.perFormanceDatas = [perFormanceDatasTmp copy];
    
    //刷新数据
    [self reloadUI];
}



/**
 刷新数据
 */
-(void)reloadUI{
    
    self.indexTitleView.titleLabel.text = @"主要指标";
    self.indexTitleView.subTitleLabel.text = @"2017年一季度营收1.30亿元，同比增长－67.33%";
    self.quarterlyProfitView.titleLabel.text = @"季度利润";
    self.quarterlyProfitView.subTitleLabel.text = @"2017年一季度净利润435.2万元，同比增长-81.3%";
    self.EPSView.titleLabel.text = @"每股收益";
    self.EPSView.subTitleLabel.text = @"2017年一季度每股收益(EPS)0.04元";
    
    self.indexChartView.pi = self.perFormanceDatas[FinanceIndex];
    self.quarterlyProfitChartView.pi = self.perFormanceDatas[FinanceQuarterlyProfit];
    self.EPSChartView.pi = self.perFormanceDatas[FinanceEPS];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

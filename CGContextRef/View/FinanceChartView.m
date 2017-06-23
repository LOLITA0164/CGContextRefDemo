//
//  FinanceChartView.m
//  FinancialStatistics
//
//  Created by LOLITA on 17/6/15.
//  Copyright © 2017年 LOLITA. All rights reserved.
//

#import "FinanceChartView.h"
#import <QuartzCore/QuartzCore.h>
#define XAxisTitleHeight 20
#define legendTopHeight 10
#define legendpHeight 14
#define XAxisDataHeight 15

@implementation FinanceChartView
{
    CGFloat space;
    CGFloat xLabelWidth;
    CGFloat yLabelWidth;
    CGFloat legendTotalHeight;
    CGFloat chartBottomHeight;
    CGFloat chartHeight;
}

-(instancetype)initWithFrame:(CGRect)frame withType:(FinanceType)type{
    if (self = [super initWithFrame: frame]) {
        self.financeType = type;
    }
    return self;
}

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    space = 10;
    xLabelWidth = 0 ;

    yLabelWidth = (self.bounds.size.width - space*2) / (self.pi.XAxisTitles.count + 3);
    NSUInteger xLabelCount = self.pi.XAxisTitles.count;
    xLabelWidth = (self.bounds.size.width - yLabelWidth - space*2) / xLabelCount;

    legendTotalHeight = legendTopHeight*2+legendpHeight;
    chartBottomHeight = XAxisTitleHeight*1.5;
    chartHeight = self.bounds.size.height-legendTotalHeight-chartBottomHeight;
    
    switch (self.financeType) {
        case FinanceIndex:
            [self drawIndexChartView];
            break;
        case FinanceQuarterlyProfit:
            [self drawQuarterlyProfitChartView];
            break;
        case FinanceEPS:
            [self drawEPSChartView];
            break;
        default:
            break;
    }
}


#pragma mark - 指标
-(void)drawIndexChartView{
    CGFloat space2 = 1; //小模块间隔
    NSArray *colors = @[ColorWithRGB(203, 8, 20),ColorWithRGB(218, 77, 80),ColorWithRGB(233, 154, 154),ColorWithRGB(250, 228, 230)]; //颜色数组
    
    if (self.pi.XAxisDatas.count) {
        CGFloat total = 0.0;
        for (NSArray * items in self.pi.XAxisDatas) {
            CGFloat itemTotal = 0.0;
            for (NSString * valueString in items) {
                itemTotal += valueString.floatValue;
            }
            total = itemTotal > total ? itemTotal : total;
        }
        DLog(@"最高总收入为：%f亿元",total);
        [self.pi.XAxisDatas enumerateObjectsUsingBlock:^(NSArray <NSString *>* _Nonnull datas, NSUInteger idx, BOOL * _Nonnull stop) {
            CGFloat chartViewHeightInUse = chartHeight - space2 * datas.count;
            //圆柱形的宽
            CGFloat cylinderWidth = self.viewWidth / (self.pi.XAxisDatas.count + 4);
            CGFloat originX = space+idx*(xLabelWidth)+xLabelWidth/2.0 - cylinderWidth/2.0;
            __block CGFloat originY = self.bounds.size.height-chartBottomHeight;
            [datas enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                CGFloat value = obj.floatValue;
                CGFloat ratio = value / total;
                CGFloat itemHeight = ratio * chartViewHeightInUse;
                // 绘 X 轴
                CGContextRef context = UIGraphicsGetCurrentContext();
                CGContextSetFillColorWithColor(context, ((UIColor*)colors[idx]).CGColor);//填充颜色
                CGContextFillRect(context,CGRectMake(originX, originY - itemHeight, cylinderWidth, itemHeight));//填充框
                CGContextDrawPath(context, kCGPathFill);//绘画路径
                //重新设置起始y
                originY = originY - itemHeight - space2;
            }];
        }];
    }
    //绘制坐标轴
    [self drawXYAxisWithFinanceType:FinanceIndex];;
    
}


#pragma mark - 利润
-(void)drawQuarterlyProfitChartView{
    CGFloat positiveValue = 0.0;//盈利
    CGFloat negativeValue = 0.0;//亏损
    //取出最大和最小
    if (self.pi.XAxisDatas.count) {
        for (NSString *value in self.pi.XAxisDatas) {
            if (value.floatValue>positiveValue) {
                positiveValue = value.floatValue;
            }
            if (value.floatValue<negativeValue) {
                negativeValue = value.floatValue;
            }
        }
    }
    DLog(@"最高盈利：%f,最高亏损：%f",positiveValue,negativeValue);
    //算出比例
     CGFloat per = chartHeight/(positiveValue-negativeValue);
    //x轴位置 height
    CGFloat xAxisOriginHeight = positiveValue * per + legendTotalHeight;
    // 绘 X 轴
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.5);
    CGContextSetStrokeColorWithColor(context, [UIColor groupTableViewBackgroundColor].CGColor); //设置线的颜色为白色
    CGContextMoveToPoint(context, space, xAxisOriginHeight); //设置线的起始点
    CGContextAddLineToPoint(context, self.pi.XAxisTitles.count*xLabelWidth+space, xAxisOriginHeight+0.5); //设置线中间的一个点
    CGContextStrokePath(context);//直接把所有的点连起来
    NSArray *colors = @[ColorWithRGB(203, 8, 20),ColorWithRGB(50, 205, 50)];
    [self.pi.XAxisDatas enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //圆柱形的宽
        CGFloat cylinderWidth = self.viewWidth / (self.pi.XAxisDatas.count + 4);
        CGFloat originX = space+idx*(xLabelWidth)+xLabelWidth/2.0 - cylinderWidth/2.0;
        CGFloat value = obj.floatValue;
        CGFloat itemHeight = per * value;
        // 绘 X 轴
        CGContextRef context = UIGraphicsGetCurrentContext();
        UIColor *color ;
        if (obj.floatValue<0) { //   跌
            color = colors.lastObject;
        }
        else{
            color = colors.firstObject;
        }
        CGContextSetFillColorWithColor(context, color.CGColor);//填充颜色
        CGContextFillRect(context,CGRectMake(originX, xAxisOriginHeight - itemHeight, cylinderWidth, itemHeight));//填充框
        CGContextDrawPath(context, kCGPathFill);//绘画路径
        
//        [color set];
//        CGContextAddRect(context, CGRectMake(originX, xAxisOriginHeight - itemHeight, cylinderWidth, itemHeight));
//        CGContextFillPath(context);

    }];
    //绘制坐标轴
    [self drawXYAxisWithFinanceType:FinanceQuarterlyProfit];
    [self.pi.XAxisDatas enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat value = obj.floatValue;
        CGFloat itemHeight = per * value;
        UIColor *color ;
        if (obj.floatValue<0)//   跌
            color = colors.lastObject;
        else
            color = colors.firstObject;
        
        if (itemHeight<0)
            itemHeight = 0 ;
        
        //数据显示
        UIFont *font = [UIFont systemFontOfSize:AdaptedFontSizeValue(tinySize)];
        CGRect rect = CGRectMake(space+idx*(xLabelWidth), xAxisOriginHeight - itemHeight - XAxisDataHeight, xLabelWidth, XAxisDataHeight);
        NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        style.lineBreakMode = NSLineBreakByWordWrapping;
        style.alignment = NSTextAlignmentCenter;
        [obj drawWithRect:rect options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName:style, NSForegroundColorAttributeName:color} context:nil];
    }];
    
}






#pragma mark - EPS
-(void)drawEPSChartView{
    //绘制坐标轴
    [self drawXYAxisWithFinanceType:FinanceEPS];
    //绘制圆
    {
        //绘制折线数据
        if (self.pi.YAxisDatas.count) {
            UIFont *font = [UIFont systemFontOfSize:AdaptedFontSizeValue(tinySize)];
            CGFloat maxValue = ((NSString *)self.pi.YAxisTitles.firstObject).floatValue;
            CGFloat minValue = ((NSString *)self.pi.YAxisTitles.firstObject).floatValue;
            for (NSString *value in self.pi.YAxisTitles) {
                if (value.floatValue > maxValue) {
                    maxValue = value.floatValue;
                }
                if (value.floatValue < minValue) {
                    minValue = value.floatValue;
                }
            }
            [self.pi.YAxisDatas enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                CGFloat per = chartHeight/(maxValue-minValue);
                CGFloat dataHeight = per * (obj.floatValue - minValue);
                CGFloat x = space+idx*(xLabelWidth);
                CGFloat y = self.bounds.size.height - dataHeight - chartBottomHeight;
                //数据显示
                CGRect rect = CGRectMake(x, y-XAxisTitleHeight, xLabelWidth, XAxisDataHeight);
                NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
                style.lineBreakMode = NSLineBreakByWordWrapping;
                style.alignment = NSTextAlignmentCenter;
                [obj drawWithRect:rect options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName:style, NSForegroundColorAttributeName:[UIColor darkTextColor]} context:nil];
                
            }];

        }
        
    }
    
}



/**
 绘制x、y轴、图例、以及折线
 */
-(void)drawXYAxisWithFinanceType:(FinanceType)type{
    //x轴和数据
    {
        // 绘 X 轴数据
        if (self.pi.XAxisTitles.count) {
            UIFont *font = [UIFont systemFontOfSize:AdaptedFontSizeValue(tinySize)];
            [self.pi.XAxisTitles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                CGRect rect = CGRectMake(space+idx*(xLabelWidth), self.bounds.size.height-XAxisTitleHeight, xLabelWidth, XAxisTitleHeight);
                NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
                style.lineBreakMode = NSLineBreakByWordWrapping;
                style.alignment = NSTextAlignmentCenter;
                [obj drawWithRect:rect options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName:style, NSForegroundColorAttributeName:[UIColor grayColor]} context:nil];
                
            }];
        }
        if (type != FinanceQuarterlyProfit){
            // 绘 X 轴
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextSetLineWidth(context, 0.5);
            CGContextSetStrokeColorWithColor(context, [UIColor groupTableViewBackgroundColor].CGColor); //设置线的颜色为白色
            CGContextMoveToPoint(context, space, self.bounds.size.height-XAxisTitleHeight*1.5); //设置线的起始点
            CGContextAddLineToPoint(context, self.pi.XAxisTitles.count*xLabelWidth+space, self.bounds.size.height-XAxisTitleHeight*1.5+0.5); //设置线中间的一个点
            CGContextStrokePath(context);//直接把所有的点连起来
        }
    }

    // Y 轴数据
    {
        // 绘 Y 轴数据
        if (self.pi.YAxisTitles) {
            UIFont *font = [UIFont systemFontOfSize:AdaptedFontSizeValue(tinySize)];
            NSUInteger yLabelCount = self.pi.YAxisTitles.count;
            CGFloat yLabelHeight = tinySize;
            CGFloat yLabelSpace = (chartHeight-(yLabelCount*yLabelHeight))/(yLabelCount-1);
            [self.pi.YAxisTitles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                CGRect rect = CGRectMake(0, legendTotalHeight+idx*(yLabelHeight+yLabelSpace)+3, xLabelWidth*self.pi.XAxisTitles.count+yLabelWidth, yLabelHeight);
                NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
                style.alignment = NSTextAlignmentRight;
                [obj drawWithRect:rect options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName:style, NSForegroundColorAttributeName:[UIColor grayColor]} context:nil];
            }];
        }
    }

    //图例
    {
        __block CGFloat startX = 10;
        if (self.pi.legendItems) {
            [self.pi.legendItems enumerateObjectsUsingBlock:^(Item * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                CGSize size = [obj.value sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:AdaptedFontSizeValue(smallSize)]}];
                CGFloat h = 20;
                CGFloat w = size.width + h + 15;
                LegendView *legendView = [[LegendView alloc] initWithFrame:CGRectMake(startX , 0, w, h)];
                legendView.iconImageView.image = [UIImage imageNamed:obj.key];
                legendView.legendLabel.text = obj.value;
                [self addSubview:legendView];
                startX += w + 10;
            }];
        }
    }

    //绘制折线
    {
        //绘制折线数据
        if (self.pi.YAxisDatas.count) {
            CGFloat maxValue = ((NSString *)self.pi.YAxisTitles.firstObject).floatValue;
            CGFloat minValue = ((NSString *)self.pi.YAxisTitles.firstObject).floatValue;
            for (NSString *value in self.pi.YAxisTitles) {
                if (value.floatValue > maxValue) {
                    maxValue = value.floatValue;
                }
                if (value.floatValue < minValue) {
                    minValue = value.floatValue;
                }
            }
            CGContextRef context = UIGraphicsGetCurrentContext(); //折线
            CGContextSetLineWidth(context, 1.5);
            CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor); //设置线的颜色
            [self.pi.YAxisDatas enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                CGFloat per = chartHeight/(maxValue-minValue);
                CGFloat dataHeight = per * (obj.floatValue - minValue);
                CGFloat x = space+idx*(xLabelWidth);
                CGFloat y = self.bounds.size.height - dataHeight - chartBottomHeight;
                //折线
                if (idx) {
                    CGContextAddLineToPoint(context, x+xLabelWidth/2.0, y);
                }
                else{
                    CGContextMoveToPoint(context, x+xLabelWidth/2.0, y); //设置线的起始点
                }
            }];
            CGContextStrokePath(context);//直接把所有的点连起来
        }
 
    }
    
    
    {
        //绘制折线上的圆点
        if (self.pi.YAxisDatas.count) {
            CGFloat maxValue = ((NSString *)self.pi.YAxisTitles.firstObject).floatValue;
            CGFloat minValue = ((NSString *)self.pi.YAxisTitles.firstObject).floatValue;
            for (NSString *value in self.pi.YAxisTitles) {
                if (value.floatValue > maxValue) {
                    maxValue = value.floatValue;
                }
                if (value.floatValue < minValue) {
                    minValue = value.floatValue;
                }
            }
            [self.pi.YAxisDatas enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                CGFloat per = chartHeight/(maxValue-minValue);
                CGFloat dataHeight = per * (obj.floatValue - minValue);
                CGFloat x = space+idx*(xLabelWidth);
                CGFloat y = self.bounds.size.height - dataHeight - chartBottomHeight;
                CGContextRef context = UIGraphicsGetCurrentContext();
                CGContextSetLineWidth(context, 1.5);  //线条宽度
                CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor); //设置填充色
                CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor); //设置线条颜色
                CGContextAddEllipseInRect(context, CGRectMake(x+xLabelWidth/2.0 - 5, y - 5, 10, 10));
                CGContextDrawPath(context, kCGPathFillStroke);  // 渲染类型为  填充和Stroke
            }];
            
        }
        
    }
   
}


@end


@implementation LegendView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.iconImageView.frame = CGRectMake(0, 0, self.viewHeight, self.viewHeight);
        [self addSubview:self.iconImageView];
        self.legendLabel.frame = CGRectMake(self.iconImageView.right+2, self.iconImageView.y, self.viewWidth-self.viewHeight, self.viewHeight);
        [self addSubview:self.legendLabel];
        [self adjustFrame];
    }
    return self;
}

-(UIImageView *)iconImageView{
    if (_iconImageView==nil) {
        _iconImageView = [UIImageView new];
    }
    return _iconImageView;
}

-(UILabel *)legendLabel{
    if (_legendLabel==nil) {
        _legendLabel = [UILabel new];
        _legendLabel.textColor = [UIColor darkTextColor];
        _legendLabel.font = [UIFont systemFontOfSize:AdaptedFontSizeValue(smallSize)];
    }
    return _legendLabel;
}

@end


//
//  TitleView.m
//  FinancialStatistics
//
//  Created by LOLITA on 17/6/15.
//  Copyright © 2017年 LOLITA. All rights reserved.
//

#import "TitleView.h"

@implementation TitleView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        NSArray* nibViews =  [[NSBundle mainBundle] loadNibNamed:@"TitleView" owner:nil options:nil];
        self = nibViews.firstObject;
        self.frame = frame;
        [self adjustFrameWithXScale:1 YScale:1 WScale:self.viewWidth/375.0 HScale:self.viewHeight/70.0];
        
        self.titleLabel.font = [UIFont systemFontOfSize:AdaptedFontSizeValue(normalSize)];
        self.subTitleLabel.font = [UIFont systemFontOfSize:AdaptedFontSizeValue(smallSize)];
        
    }
    
    return self;
}


@end

//
//  TitleView.h
//  FinancialStatistics
//
//  Created by LOLITA on 17/6/15.
//  Copyright © 2017年 LOLITA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TitleView : UIView


/**
 标题
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

/**
 子标题
 */
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@end

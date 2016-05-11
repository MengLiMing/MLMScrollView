//
//  MLMScrollView.h
//  SilverTimesPro
//
//  Created by apple on 15/11/6.
//  Copyright (c) 2015年 富唐国际. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MLMScrollView : UIScrollView

@property (nonatomic) BOOL hasPage;
@property (nonatomic) BOOL run;

- (instancetype)initWithFrame:(CGRect)frame viewSource:(NSMutableArray *)sourceArray addToView:(UIView *)view;

@end

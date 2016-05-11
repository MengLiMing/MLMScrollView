//
//  ViewController.m
//  Demo
//
//  Created by my on 16/5/11.
//  Copyright © 2016年 MS. All rights reserved.
//

#import "ViewController.h"
#import "MLMScrollView.h"

@interface ViewController ()
{
    MLMScrollView *_scrollView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initScroll];
}

- (void)initScroll {
    NSMutableArray *viewArray = [NSMutableArray array];
    for (NSInteger i = 0 ; i < 4; i ++) {
        UILabel *label = [[UILabel alloc] init];
        label.text = [NSString stringWithFormat:@"%ld",i];
        label.textAlignment = NSTextAlignmentCenter;
        [viewArray addObject:label];
    }
    _scrollView = [[MLMScrollView alloc] initWithFrame:self.view.bounds viewSource:viewArray addToView:self.view];
//    _scrollView.run = YES;
    _scrollView.hasPage = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

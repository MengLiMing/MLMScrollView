//
//  MLMScrollView.m
//  SilverTimesPro
//
//  Created by apple on 15/11/6.
//  Copyright (c) 2015年 富唐国际. All rights reserved.
//

#import "MLMScrollView.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

typedef enum{
    Left,
    Right
}Direction;

@interface MLMScrollView () <UIScrollViewDelegate>
{
    NSMutableArray *nextView;
    CGFloat startX;
    UIView *superV;
    NSTimer *timer;
    
    //定时器运行
    BOOL isRun;
    
    //拖拽中
    BOOL draging;
}
@property (nonatomic, assign) Direction dire;
@property (nonatomic, strong) UIPageControl *pageC;

@property (nonatomic) NSArray *arr;
@end
@implementation MLMScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setHasPage:(BOOL)hasPage {
    self.pageC.hidden = !hasPage;
}

- (void)setRun:(BOOL)run {
    if (run) {
        [self startRun];
    } else {
        [self stopRun];
    }
    _run = run;
}


- (void)startRun {
    if (!timer) {
        isRun = YES;
        self.dire = Right;
        timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(switchView) userInfo:nil repeats:YES];
    }
}


- (void)stopRun {
    isRun = NO;
    [timer invalidate];
    timer = nil;
}

- (void)switchView {
    [self changeSourceArray:self.dire];
    [self changePage];
}


- (instancetype)initWithFrame:(CGRect)frame viewSource:(NSMutableArray *)sourceArray addToView:(UIView *)view{
    if (self = [super init]) {
        self.frame = frame;
        superV = view;
        self.clipsToBounds = NO;

        nextView = [NSMutableArray array];
        nextView = sourceArray;
        [self initView];
        isRun = NO;
        [self scrollViewAfresh];
    }
    return self;
}
- (void)initView {
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.pagingEnabled = YES;
    self.delegate = self;
    
    if (nextView.count <= 1) {
        self.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
        self.contentOffset = CGPointMake(0, 0);
        UIView *firstView = nextView[0];
        firstView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [self addSubview:firstView];
    } else {
        self.contentSize = CGSizeMake(self.frame.size.width * 3, self.frame.size.height);
        self.contentOffset = CGPointMake(self.frame.size.width, 0);
    }
    [superV addSubview:self];
    
    self.pageC = [[UIPageControl alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y + self.frame.size.height - 20, superV.frame.size.width, 20)];
    self.pageC.numberOfPages = nextView.count;
    self.pageC.userInteractionEnabled = NO;
    self.pageC.currentPage = 0;
    self.pageC.hidden = NO;
    self.pageC.currentPageIndicatorTintColor = [UIColor colorWithRed:255/255.0 green:48/255.0 blue:48/255.0 alpha:1];
    self.pageC.pageIndicatorTintColor = [UIColor grayColor];
    [superV addSubview:self.pageC];
}


- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    if (nextView.count > 0) {
        if (frame.size.height > SCREEN_WIDTH) {
            UIImageView *v = (UIImageView *)nextView[0];
            v.frame = CGRectMake(v.frame.origin.x, SCREEN_WIDTH - frame.size.height, SCREEN_WIDTH,2* frame.size.height - SCREEN_WIDTH);
            NSLog(@"v - %@",NSStringFromCGRect(v.frame));
        }
    }

}


/**
 * 根据滑动方向改变数组的顺序
 */
- (void)changeSourceArray:(Direction)dir {

    switch (dir) {
        case Left:
            [nextView insertObject:nextView[nextView.count - 1] atIndex:0];
            [nextView removeObjectAtIndex:nextView.count - 1];
            break;
        case Right:
            [nextView insertObject:nextView[0] atIndex:nextView.count];
            [nextView removeObjectAtIndex:0];
            break;
        default:
            break;
    }
    if (isRun) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:.2 animations:^{
                [self setContentOffset:CGPointMake(2 *self.frame.size.width, 0)];
            } completion:^(BOOL finished) {
                [self scrollViewAfresh];
                [self setContentOffset:CGPointMake(self.frame.size.width, 0) animated:NO];
            }];
        });
    }
}



/**
 *  改变pageController的currentPage
 */
- (void)changePage{
    
    NSInteger page = self.pageC.currentPage;
    

    //算法更改
    switch (self.dire) {
        case Left:
            self.pageC.currentPage = (page - 1 + nextView.count)%nextView.count;
            break;
        case Right:
            self.pageC.currentPage = (page + 1)%nextView.count;
            break;
        default:
            break;
    }
    
    
    draging = NO;
    
}

/**
 *  每次滑动开始，根据方向布局
 */
- (void)scrollViewAfresh {
    
    
    for (UIView *v in self.subviews) {
        [v removeFromSuperview];
    }
    
    
    UIView *firstView = nextView[0];
    firstView.frame = CGRectMake((1) * self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
    [self addSubview:firstView];
    
    
    switch (self.dire) {
        case Right:
        {
            UIView *secondView = nextView[1];
            secondView.frame = CGRectMake((2) * self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
            [self addSubview:secondView];
        }
            break;
        case Left:
        {
            UIView *secondView = [nextView lastObject];
            secondView.frame = CGRectMake((0) * self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
            [self addSubview:secondView];
        }
            break;
            
        default:
            break;
    }
    
}


#pragma mark - scrollview代理

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    scrollView.userInteractionEnabled = YES;
    if (_run) {
        [self startRun];
    }
    
}
/**
 *  开始拖拽时，按照数组中视图的顺序重新排序,*****开始时mainScroll的偏移永远在中间
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {

    [self setContentOffset:CGPointMake(self.frame.size.width, 0) animated:NO];
    
    NSLog(@"%@",NSStringFromCGPoint(scrollView.contentOffset));
    startX = scrollView.contentOffset.x;
    draging = YES;
    if (_run) {
        [self stopRun];
    }
}


/**
 *  此处判断滑动时开始时的方向
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.x > startX) {
        self.dire = Right;
        
    }
    
    if (scrollView.contentOffset.x < startX) {
        self.dire = Left;
    }
    
    if (draging) {
        scrollView.userInteractionEnabled = NO;
        [self scrollViewAfresh];
        if (fabs(scrollView.contentOffset.x- startX) > scrollView.frame.size.width/2) {
            [self changeSourceArray:self.dire];
            [self changePage];
        }
    }
    
}

@end

//
//  startUp.m
//  supervision
//
//  Created by eidision on 15/5/15.
//  Copyright (c) 2015年 eidision. All rights reserved.
//

#import "startUp.h"

@interface startUp () <UIScrollViewDelegate>
@property (strong, nonatomic)  UIScrollView *scrollView;
@property (strong, nonatomic)  UIPageControl *pageControl;
@property UIButton *doneButton;
@end

@implementation startUp

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        
        CGFloat originWidth = self.frame.size.width;
        CGFloat originHeight = self.frame.size.height;
        NSLog(@"%f%f%f%f", frame.origin.x, frame.origin.y, frame.size.height, frame.size.width);
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
        self.scrollView.pagingEnabled = YES;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.bounces = NO;
        [self addSubview:self.scrollView];
        
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height*.87, self.frame.size.width, 10)];
        self.pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:0.153 green:0.533 blue:0.796 alpha:1.000];
        self.pageControl.pageIndicatorTintColor = [UIColor colorWithRed:150.0/256 green:150.0/256 blue:150.0/256 alpha:1];
        [self addSubview:self.pageControl];
        
        self.pageControl.numberOfPages = 3;
        self.scrollView.contentSize = CGSizeMake(originWidth*3, 0);


        //Done Button
        self.doneButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width*.3, self.frame.size.height*.9, self.frame.size.width*.4, 30)];

        [self.doneButton setBackgroundImage:[UIImage imageNamed:@"doneButton"] forState:UIControlStateNormal];
        self.doneButton.layer.borderColor = [UIColor colorWithRed:0.153 green:0.533 blue:0.796 alpha:1.000].CGColor;
        [self.doneButton addTarget:self action:@selector(onFinishedIntroButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        self.doneButton.layer.borderWidth =.5;
        self.doneButton.layer.cornerRadius = 15;
        [self addSubview:self.doneButton];
        
        
        //This is the starting point of the ScrollView
        CGPoint scrollPoint = CGPointMake(0, 0);
        [self.scrollView setContentOffset:scrollPoint animated:YES];
        
        self.scrollView.delegate = self;
        
        
        
        float _x = 0;
        for (int index = 1; index < 4; index ++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0 + _x, 0, originWidth, originHeight)];
            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"startup_%d",index]];
            [self.scrollView addSubview:imageView];
            _x += originWidth;
        }
    }
    return self;
}

- (void)onFinishedIntroButtonPressed:(id)sender {
    [self.delegate onDoneButtonPressed];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat pageWidth = CGRectGetWidth(self.bounds);
    CGFloat pageFraction = self.scrollView.contentOffset.x / pageWidth;
    self.pageControl.currentPage = roundf(pageFraction);
    
}

@end

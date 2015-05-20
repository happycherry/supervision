//
//  backButtonView.m
//  supervision
//
//  Created by eidision on 15/5/16.
//  Copyright (c) 2015年 eidision. All rights reserved.
//

#import "backButtonView.h"

@implementation backButtonView

- (instancetype)init
{
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    CGFloat screen_width = size.width;
    CGFloat height = 40.0;

    self = [super initWithFrame:CGRectMake(0, 0, 20, 15)];
    if (self) {
//        self.titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 7.0/16*screen_width - 2, height*2/3)];
//        self.titleLable.text = @"污染源监测情况";
//        self.titleLable.textColor = [UIColor whiteColor];
//        self.titleLable.textAlignment = NSTextAlignmentCenter;
//        [self.titleLable setFont:[UIFont boldSystemFontOfSize:16]];
//        
//        self.subtitleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, height*2/3 - 2, 7.0/16*screen_width, height*1/3)];
//        self.subtitleLable.textColor = [UIColor whiteColor];
//        self.subtitleLable.textAlignment = NSTextAlignmentCenter;
//        [self.subtitleLable setFont:[UIFont systemFontOfSize:14]];
//        
//        [self addSubview:self.titleLable];
//        [self addSubview:self.subtitleLable];
        
        self.backgroundColor =[UIColor redColor];
    }
    
    return self;
}

@end

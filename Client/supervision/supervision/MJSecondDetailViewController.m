//
//  MJSecondDetailViewController.m
//  MJPopupViewControllerDemo
//
//  Created by Martin Juhasz on 24.06.12.
//  Copyright (c) 2012 martinjuhasz.de. All rights reserved.
//

#import "MJSecondDetailViewController.h"

@interface MJSecondDetailViewController ()

@end

@implementation MJSecondDetailViewController

@synthesize delegate;

-(void)viewDidLoad
{
    NSMutableArray *tempResult = [[NSMutableArray alloc] init];
    BOOL flag = YES;
    
    if (self.portalInfo) {
        self.cityName.text = self.portalInfo[@"name"] ? self.portalInfo[@"name"] : @"undefined";
        
        self.pollution_types.text =
        [(NSArray *)self.portalInfo[@"exce"] count] ? [self.portalInfo[@"exce"] componentsJoinedByString:@"，"]: @"无";
        
        if ([self.portalInfo[@"no_exce"] count]) {
            [tempResult addObjectsFromArray:self.portalInfo[@"no_exce"]];
        }
        if ([self.portalInfo[@"exce"] count]) {
            [tempResult addObjectsFromArray:self.portalInfo[@"exce"]];
            flag = NO;
        }
        
        self.supervisions.text = tempResult ? [tempResult componentsJoinedByString:@"，"] : @"undefined";

        self.time.text = self.portalInfo[@"time"] ? self.portalInfo[@"time"] : @"undefined";
        NSLog(@"%@", flag ? @"sdf": @"asdfsd");
        self.standardImageView.image = flag ? [UIImage imageNamed:@"standarded"] : [UIImage imageNamed:@"unstandarded"];
    }
    
}

- (IBAction)back:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelButtonClicked:)]) {
        [self.delegate cancelButtonClicked:self];
    }
}

@end

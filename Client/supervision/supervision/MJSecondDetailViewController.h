//
//  MJSecondDetailViewController.h
//  MJPopupViewControllerDemo
//
//  Created by Martin Juhasz on 24.06.12.
//  Copyright (c) 2012 martinjuhasz.de. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MJSecondPopupDelegate;


@interface MJSecondDetailViewController : UIViewController

@property (assign, nonatomic) id <MJSecondPopupDelegate>delegate;

@property (nonatomic, strong) NSDictionary *portalInfo;

@property (weak, nonatomic) IBOutlet UILabel *cityName;
@property (weak, nonatomic) IBOutlet UILabel *pollution_types;
@property (weak, nonatomic) IBOutlet UILabel *supervisions;
@property (weak, nonatomic) IBOutlet UILabel *time;

@property (weak, nonatomic) IBOutlet UIImageView *standardImageView;

@end



@protocol MJSecondPopupDelegate<NSObject>
@optional
- (void)cancelButtonClicked:(MJSecondDetailViewController*)secondDetailViewController;
@end
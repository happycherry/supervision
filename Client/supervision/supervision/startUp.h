//
//  startUp.h
//  supervision
//
//  Created by eidision on 15/5/15.
//  Copyright (c) 2015年 eidision. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol startupViewDelegate <NSObject>

-(void)onDoneButtonPressed;

@end

@interface startUp : UIView

@property id<startupViewDelegate> delegate;

@end

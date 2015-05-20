//
//  AnnotationInMap.m
//  hbj_app
//
//  Created by eidision on 14/11/25.
//  Copyright (c) 2014年 zhangchao. All rights reserved.
//

#import "AnnotationInMap.h"

@implementation AnnotationInMap

-(id) initWithCGLocation:(CLLocationCoordinate2D) coord
{
    self = [super init];
    if (self) {
        _coordinate = coord;
    }
    return self;
}

@end

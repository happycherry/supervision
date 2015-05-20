//
//  AnnotationInMap.h
//  hbj_app
//
//  Created by eidision on 14/11/25.
//  Copyright (c) 2014年 zhangchao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface AnnotationInMap : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic,strong)NSString *tag;

-(id) initWithCGLocation:(CLLocationCoordinate2D) coord;

@end

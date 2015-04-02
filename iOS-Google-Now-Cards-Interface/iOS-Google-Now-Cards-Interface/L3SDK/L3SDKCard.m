//
//  Lam3SwipePanel.m
//  Lam3SwipePanel
//
//  Created by Domenico Vacchiano on 28/03/15.
//  Copyright (c) 2015 LamCube. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "L3SDKCard.h"
#import  <QuartzCore/QuartzCore.h>


@implementation L3SDKCard
@synthesize zeroFrame;

- (void)drawRect:(CGRect)rect {

    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.bounds];
    
    //initial frame
    self.zeroFrame=self.frame;
    
    //shadow
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.layer.shadowOpacity = 0.5f;
    self.layer.shadowPath = shadowPath.CGPath;
    [self setBackgroundColor:[UIColor whiteColor]];
    
}

-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self drawRect:frame];
    }
    return self;
    
}




@end

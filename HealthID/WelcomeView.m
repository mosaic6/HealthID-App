//
//  WelcomeView.m
//  HealthID
//
//  Created by Joshua Walsh on 5/25/15.
//  Copyright (c) 2015 Joshua Walsh. All rights reserved.
//

#import "WelcomeView.h"

@implementation WelcomeView

@synthesize firstView = _firstView;

- (void)baseInit {
    _firstView = NO;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self baseInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if ((self = [super initWithCoder:aDecoder])) {
        [self baseInit];
    }
    return self;
}

@end

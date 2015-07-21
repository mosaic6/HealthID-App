//
//  DashboardCards.m
//  HealthID
//
//  Created by Joshua Walsh on 7/14/15.
//  Copyright (c) 2015 Joshua Walsh. All rights reserved.
//

#import "DashboardCards.h"

@implementation DashboardCards

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

//- (void)drawRect:(CGRect)rect {
//    // Drawing code
//}


- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        
        UIView *card = [[UIView alloc]init];
        card.backgroundColor = [UIColor lightGrayColor];
        
        // border radius
        [card.layer setCornerRadius:5.0f];
        
        // border
        [card.layer setBorderColor:[UIColor grayColor].CGColor];
        [card.layer setBorderWidth:1.5f];
        
        UILabel *aLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 30, self.bounds.size.width / 2, 35)];
        aLabel.textAlignment = NSTextAlignmentCenter;
        aLabel.text = @"Weight";
        
        [self addSubview:aLabel];
        
        
    }
    
    return self;
}

@end

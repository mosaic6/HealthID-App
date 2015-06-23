//
//  NDCollapsiveDateView.m
//  NDCollapsiveDatePicker
//
//  Created by Simon Wicha on 4/02/2015.
//  Copyright (c) 2015 Simon Wicha. All rights reserved.
//

#import "NDCollapsiveDateView.h"

@implementation NDCollapsiveDateView

NDCollapsiveDateView *collapsiveDateView;
NSString *_title;
UIImage *_image;

+(id)collapsiveDateView{
    collapsiveDateView = [[[NSBundle mainBundle] loadNibNamed:@"NDCollapsiveDateView" owner:nil options:nil] lastObject];
    if ([collapsiveDateView isKindOfClass:[NDCollapsiveDateView class]])
        return collapsiveDateView;
    else
        return nil;
}

-(id)initWithFrame:(CGRect)frame title:(NSString*)title andImage:(UIImage*)image {
    self = [NDCollapsiveDateView collapsiveDateView];
    if (self) {
        self.frame = frame;
        self.collapsiveLabel.text = title;
        self.collapsiveLabel.font = [UIFont fontWithName:@"Dosis-Regular" size:20];
        self.collapsiveImageView.image = image;
        
        self.collapsiveLabel.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        self.collapsiveLabel.layer.shadowOffset = CGSizeMake(0, 1);
        self.collapsiveLabel.layer.shadowOpacity = 0.1;
        
        self.layer.cornerRadius = 1.f;
        self.layer.borderWidth = 1.f;
        self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        self.collapsiveDatePickerView.hidden = NO;
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame title:(NSString*)title image:(UIImage*)image hiddenHeight:(CGFloat)hiddenHeight andShownHeight:(CGFloat)shownHeight {
    self = [self initWithFrame:frame title:title andImage:image];
    if (self) {
        [self setShown:shownHeight andHiddenHeight:hiddenHeight];
    }
    return self;
}


-(void)setShown:(CGFloat)shown andHiddenHeight:(CGFloat)hidden {
    self.hiddenHeight = hidden;
    self.shownHeight = shown;
}


- (IBAction)buttonTouched:(id)sender {
    if (!self.collapsiveLabel.hidden) {
        self.collapsiveLabel.hidden = YES;
        self.collapsiveDatePickerView.hidden = NO;
        [UIView animateWithDuration:0.3f delay:0.f options:UIViewAnimationOptionTransitionCurlUp animations:^{
            self.collapsiveDatePickerView.alpha = 1.f;
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.shownHeight);
            [self layoutIfNeeded];
        } completion:nil];
    } else {
        NSDate *date = [collapsiveDateView.collapsiveDatePickerView getDate];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        NSString *stringDate = [dateFormatter stringFromDate:date];
        self.collapsiveLabel.text = stringDate;
        self.collapsiveLabel.hidden = NO;
        self.collapsiveDatePickerView.hidden = YES;
        [UIView animateWithDuration:0.3f animations:^{
            self.collapsiveDatePickerView.alpha = 0.f;
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.hiddenHeight);
            [self layoutIfNeeded];
        }];
        [self.delegate datePickerViewDidCollapse:self.collapsiveDatePickerView];
    }

}


@end

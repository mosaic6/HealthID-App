//
//  NewCholesterolViewController.h
//  HealthID
//
//  Created by Joshua Walsh on 6/17/15.
//  Copyright (c) 2015 Joshua Walsh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RKDropdownAlert/RKDropdownAlert.h>

@interface NewCholesterolViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *cholesterolTF;
@property (weak, nonatomic) IBOutlet UIPickerView *cholesterolPicker;
@property (strong, nonatomic) NSMutableArray *cholesterolData;

- (IBAction)dismissView:(id)sender;
- (IBAction)saveCholesterol:(id)sender;
@end

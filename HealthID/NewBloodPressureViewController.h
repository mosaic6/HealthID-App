//
//  NewBloodPressureViewController.h
//  HealthID
//
//  Created by Joshua Walsh on 5/27/15.
//  Copyright (c) 2015 Joshua Walsh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RKDropdownAlert/RKDropdownAlert.h>
@interface NewBloodPressureViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *systolicTF;
@property (weak, nonatomic) IBOutlet UILabel *diastolicTF;
@property (weak, nonatomic) IBOutlet UIPickerView *bpPicker;
@property (strong, nonatomic) NSMutableArray *systolicData;
@property (strong, nonatomic) NSMutableArray *diastolicData;

- (IBAction)dismissView:(id)sender;
- (IBAction)saveBloodPressure:(id)sender;
@end

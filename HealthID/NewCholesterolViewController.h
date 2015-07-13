//
//  NewCholesterolViewController.h
//  HealthID
//
//  Created by Joshua Walsh on 6/17/15.
//  Copyright (c) 2015 Joshua Walsh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RKDropdownAlert/RKDropdownAlert.h>
#import <HealthKit/HealthKit.h>
@interface NewCholesterolViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *cholesterolTF;
@property (weak, nonatomic) IBOutlet UIPickerView *cholesterolPicker;
@property (strong, nonatomic) NSMutableArray *cholesterolData;
@property (strong, nonatomic) NSDate *date;

@property (strong, nonatomic) HKHealthStore *healthStore;

- (IBAction)dismissView:(id)sender;
- (IBAction)saveCholesterol:(id)sender;
@end

//
//  NewGlucoseViewController.h
//  HealthID
//
//  Created by Joshua Walsh on 6/17/15.
//  Copyright (c) 2015 Joshua Walsh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RKDropdownAlert/RKDropdownAlert.h>
#import "CoreDataStack.h"
#import "Constants.h"
#import "Dates.h"
#import "Diabetes.h"

@interface NewGlucoseViewController : UIViewController <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *dateTimeTF;
@property (weak, nonatomic) IBOutlet UITextField *glucoseLevelTF;
@property (weak, nonatomic) IBOutlet UITextField *insulinUnitsTF;
@property (weak, nonatomic) IBOutlet UITextField *insulinTypeTF;
@property (weak, nonatomic) IBOutlet UITextField *carbsTF;
@property (weak, nonatomic) IBOutlet UITextField *tagTF;
@property (weak, nonatomic) IBOutlet UITextField *feelingTF;
@property (weak, nonatomic) IBOutlet UITextField *notesTF;
@property (weak, nonatomic) IBOutlet UIDatePicker *dateTimePicker;
@property (weak, nonatomic) IBOutlet UIPickerView *glucoseLevelPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *insulinUnitsPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *insulinTypePicker;
@property (weak, nonatomic) IBOutlet UIPickerView *carbsPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *feelingPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *tagPicker;

@property (strong, nonatomic) NSMutableArray *numberArray;
@property (strong, nonatomic) NSMutableArray *menuItems;
@property (strong, nonatomic) NSArray *insulinTypeArray;
@property (strong, nonatomic) NSArray *feelingsArray;
@property (strong, nonatomic) NSArray *tagArray;
@property (strong, nonatomic) UILabel *tagLabel;
@property (strong, nonatomic) UILabel *feelingLabel;
@property (strong, nonatomic) UITapGestureRecognizer *tap;
@property (nonatomic) BOOL isPublic;

- (IBAction)dismissView:(id)sender;
- (IBAction)saveGlucose:(id)sender;

@end

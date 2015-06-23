//
//  NewWeightViewController.h
//  HealthID
//
//  Created by Joshua Walsh on 5/27/15.
//  Copyright (c) 2015 Joshua Walsh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RKDropdownAlert/RKDropdownAlert.h>
@interface NewWeightViewController : UIViewController <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveBtn;
@property (weak, nonatomic) IBOutlet UIPickerView *weightPicker;
@property (weak, nonatomic) IBOutlet UILabel *weightTF;
@property (strong, nonatomic) NSMutableArray *weightArray;
- (IBAction)dismissView:(id)sender;
- (IBAction)saveWeight:(id)sender;
@end

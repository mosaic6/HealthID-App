//
//  NewVaccinationViewController.h
//  HealthID
//
//  Created by Joshua Walsh on 6/4/15.
//  Copyright (c) 2015 Joshua Walsh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataStack.h"
#import "Vaccinations.h"
#import "Constants.h"
#import <RKDropdownAlert/RKDropdownAlert.h>
#import <NDCollapsiveDatePicker/NDCollapsiveDateView.h>

@interface NewVaccinationViewController : UIViewController <UITextFieldDelegate, NDCollapsiveDateViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *vaccinationNameTF;
@property (weak, nonatomic) IBOutlet UISwitch *isPublic;
@property (weak, nonatomic) IBOutlet UITextField *notesTF;
@property (strong, nonatomic) UITapGestureRecognizer *tap;

@property (strong, nonatomic) NDCollapsiveDateView *collapseDateView;
@property (strong, nonatomic) Vaccinations *vaccination;

- (IBAction)saveVaccination:(id)sender;
- (IBAction)dismissView:(id)sender;
@end

//
//  NewConditionViewController.h
//  HealthID
//
//  Created by Joshua Walsh on 5/31/15.
//  Copyright (c) 2015 Joshua Walsh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IGLDropDownMenu.h"
#import "CoreDataStack.h"
#import "Conditions.h"
#import <RKDropdownAlert/RKDropdownAlert.h>
#import <NDCollapsiveDatePicker/NDCollapsiveDateView.h>

@interface NewConditionViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate, IGLDropDownMenuDelegate, NDCollapsiveDateViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *conditionNameTF;
@property (weak, nonatomic) IBOutlet UITextField *notesTF;
@property (strong, nonatomic) IGLDropDownMenu *statusMenu;
@property (strong, nonatomic) NDCollapsiveDateView *collapseDateView;
@property (strong, nonatomic) UILabel *statusLabel;
@property (strong, nonatomic) UITapGestureRecognizer *tap;

@property (weak, nonatomic) IBOutlet UISwitch *isPublic;

@property (strong, nonatomic) Conditions *condition;

- (IBAction)dismissView:(id)sender;
- (IBAction)saveNewCondition:(id)sender;
@end

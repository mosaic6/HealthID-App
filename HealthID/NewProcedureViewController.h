//
//  NewProcedureViewController.h
//  HealthID
//
//  Created by Joshua Walsh on 6/2/15.
//  Copyright (c) 2015 Joshua Walsh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataStack.h"
#import "Procedures.h"
#import <RKDropdownAlert/RKDropdownAlert.h>
#import <NDCollapsiveDatePicker/NDCollapsiveDateView.h>

@interface NewProcedureViewController : UIViewController <UITextFieldDelegate, NDCollapsiveDateViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *procedureNameTF;
@property (weak, nonatomic) IBOutlet UITextField *notesTF;
@property (weak, nonatomic) IBOutlet UISwitch *isPublic;
@property (strong, nonatomic) UITapGestureRecognizer *tap;

@property (strong, nonatomic) NDCollapsiveDateView *collapseDateView;
@property (strong, nonatomic) Procedures *procedure;

- (IBAction)dismissView:(id)sender;
- (IBAction)saveProcedure:(id)sender;
@end

//
//  NewAllergyViewController.h
//  HealthID
//
//  Created by Joshua Walsh on 5/27/15.
//  Copyright (c) 2015 Joshua Walsh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IGLDropDownMenu.h"
#import <RKDropdownAlert/RKDropdownAlert.h>
#import <NDCollapsiveDatePicker/NDCollapsiveDateView.h>

@interface NewAllergyViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate, IGLDropDownMenuDelegate, NDCollapsiveDateViewDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveBtn;
@property (weak, nonatomic) IBOutlet UITextField *allergyTF;
@property (strong, nonatomic) IGLDropDownItem *item;
@property (strong, nonatomic) IGLDropDownMenu *reactionMenu;
@property (strong, nonatomic) UILabel *reactionLabel;
@property (weak, nonatomic) IBOutlet UITextField *notesTF;
@property (strong, nonatomic) NDCollapsiveDateView *collapseDateView;
@property (strong, nonatomic) UITapGestureRecognizer *tap;
@property (strong, nonatomic) NSManagedObjectContext *managedObject;
@property (weak, nonatomic) IBOutlet UISwitch *isPublic;
@property (strong, nonatomic) NSArray *reactionList;
@property (strong, nonatomic) NSMutableArray *menuItems;

- (IBAction)dismissView:(id)sender;
- (IBAction)saveAllergy:(id)sender;

@end

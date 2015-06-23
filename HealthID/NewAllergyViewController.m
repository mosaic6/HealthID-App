//
//  NewAllergyViewController.m
//  HealthID
//
//  Created by Joshua Walsh on 5/27/15.
//  Copyright (c) 2015 Joshua Walsh. All rights reserved.
//

#import "NewAllergyViewController.h"
#import "IGLDropDownItem.h"
#import "RKDropdownAlert.h"
#import "Dates.h"
#import "Constants.h"
#import "Allergies.h"
#import "CoreDataStack.h"
@interface NewAllergyViewController ()

@end

@implementation NewAllergyViewController
@synthesize allergyTF,
            reactionMenu,
            notesTF,
            tap,
            saveBtn,
            managedObject,
            reactionList,
            menuItems,
            item,
            reactionLabel,
            isPublic,
            collapseDateView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CALayer *border = [CALayer layer];
    CALayer *border2 = [CALayer layer];
    CALayer *border3 = [CALayer layer];
    CGFloat borderWidth = 0.5f;
    border.borderColor = [UIColor darkGrayColor].CGColor;
    border2.borderColor = [UIColor darkGrayColor].CGColor;
    border3.borderColor = [UIColor darkGrayColor].CGColor;
    border.frame = CGRectMake(0, allergyTF.frame.size.height - borderWidth, allergyTF.frame.size.width, allergyTF.frame.size.height);
    border2.frame = CGRectMake(0, notesTF.frame.size.height - borderWidth, notesTF.frame.size.width, notesTF.frame.size.height);
    border.borderWidth = borderWidth;
    border2.borderWidth = borderWidth;
    border3.borderWidth = borderWidth;
    [allergyTF.layer addSublayer:border];
    [notesTF.layer addSublayer:border2];
    allergyTF.layer.masksToBounds = YES;
    notesTF.layer.masksToBounds = YES;
    allergyTF.delegate = self;
    notesTF.delegate = self;
    
    reactionLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 150, self.view.frame.size.width - 32, 45)];
    reactionLabel.textAlignment = NSTextAlignmentCenter;
    reactionLabel.font = [UIFont fontWithName:@"Dosis-Regular" size:24];
    reactionLabel.text = @"Reaction Type";
    
    reactionList = [[NSArray alloc]initWithObjects:@"Mild", @"Severe", @"Immediate Medical Attention", nil];
    
    menuItems = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < reactionList.count; i++) {
        item = [[IGLDropDownItem alloc]init];
        [item setText:reactionList[i]];
        [menuItems addObject:item];
    }
    
    reactionMenu = [[IGLDropDownMenu alloc]init];
    reactionMenu.menuText = @"Reaction Type";
    reactionMenu.dropDownItems = menuItems;
    reactionMenu.paddingLeft = 15;
    [reactionMenu setFrame:CGRectMake(16, 150, self.view.frame.size.width -32, 45)];
    [reactionMenu reloadView];
    reactionMenu.delegate = self;
    
    collapseDateView = [[NDCollapsiveDateView alloc] initWithFrame:CGRectMake(16, 210, self.view.frame.size.width - 32, 45) title:@"Last Reaction Date" andImage:[UIImage imageNamed:@"calendar"]];
    [collapseDateView setShown:200.f andHiddenHeight:50];
    collapseDateView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    collapseDateView.backgroundColor = [UIColor whiteColor];
    collapseDateView.delegate = self;
    
    [self.view addSubview:reactionLabel];
    [self.view addSubview:collapseDateView];
    [self.view addSubview:reactionMenu];
}

- (void)dismissKeyboard{
    [allergyTF resignFirstResponder];
    [notesTF resignFirstResponder];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

#pragma mark - IGLDropDownMenuDelegate

- (void)dropDownMenu:(IGLDropDownMenu *)dropDownMenu selectedItemAtIndex:(NSInteger)index {

    item = dropDownMenu.dropDownItems[index];
    reactionLabel.text = [NSString stringWithFormat:@"%@", item.text];
    NSLog(@"%@", item.text);
    
}

#pragma mark - NDCollapsiveDatePickerView delegate

-(void)datePickerViewDidCollapse:(NDCollapsiveDatePickerView *)datePickerView {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *stringDate = [dateFormatter stringFromDate:datePickerView.date];
    NSLog(@"selected date: %@",stringDate);
}

#pragma mark - Textfield Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [textView resignFirstResponder];
    
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (IBAction)dismissView:(id)sender {
    [allergyTF resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveAllergy:(id)sender {
    
    NSString *name = allergyTF.text;
    NSString *notes = notesTF.text;
    NSString *reaction = reactionLabel.text;
    
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    
    Allergies *entry = [NSEntityDescription insertNewObjectForEntityForName:@"Allergies" inManagedObjectContext:coreDataStack.managedObjectContext];
    
    if (name && name.length) {
        entry.name = name;
        entry.created_at = [[NSDate date]timeIntervalSince1970];
        entry.notes = notes;
        entry.reaction = reaction;
        
        if (isPublic.isOn) {
            entry.is_public = 1;
        } else {
            entry.is_public = 0;
        }
        
        [coreDataStack saveContext];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [RKDropdownAlert title:@"Saving Error" message:@"There was an error saving your allergy" backgroundColor:[UIColor redColor] textColor:[UIColor whiteColor]];
    }
}

@end

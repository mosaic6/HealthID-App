//
//  NewGlucoseViewController.m
//  HealthID
//
//  Created by Joshua Walsh on 6/17/15.
//  Copyright (c) 2015 Joshua Walsh. All rights reserved.
//

#import "NewGlucoseViewController.h"

@interface NewGlucoseViewController ()

@end

@implementation NewGlucoseViewController
@synthesize dateTimeTF,
            glucoseLevelTF,
            insulinUnitsTF,
            insulinTypeTF,
            carbsTF,
            tagTF,
            tagLabel,
            feelingTF,
            feelingLabel,
            notesTF,
            dateTimePicker,
            glucoseLevelPicker,
            insulinTypePicker,
            insulinUnitsPicker,
            carbsPicker,
            feelingPicker,
            tagPicker,
            numberArray,
            feelingsArray,
            insulinTypeArray,
            tagArray,
            tap,
            isPublic;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CALayer *border = [CALayer layer];
    CALayer *border2 = [CALayer layer];
    CALayer *border3 = [CALayer layer];
    CALayer *border4 = [CALayer layer];
    CALayer *border5 = [CALayer layer];
    CALayer *border6 = [CALayer layer];
    CALayer *border7 = [CALayer layer];
    CALayer *border8 = [CALayer layer];
    CGFloat borderWidth = 0.5f;
    border.borderColor = [UIColor darkGrayColor].CGColor;
    border2.borderColor = [UIColor darkGrayColor].CGColor;
    border3.borderColor = [UIColor darkGrayColor].CGColor;
    border4.borderColor = [UIColor darkGrayColor].CGColor;
    border5.borderColor = [UIColor darkGrayColor].CGColor;
    border6.borderColor = [UIColor darkGrayColor].CGColor;
    border7.borderColor = [UIColor darkGrayColor].CGColor;
    border8.borderColor = [UIColor darkGrayColor].CGColor;
    border.frame = CGRectMake(0, dateTimeTF.frame.size.height - borderWidth, dateTimeTF.frame.size.width, dateTimeTF.frame.size.height);
    border2.frame = CGRectMake(0, glucoseLevelTF.frame.size.height - borderWidth, glucoseLevelTF.frame.size.width, glucoseLevelTF.frame.size.height);
    border3.frame = CGRectMake(0, insulinTypeTF.frame.size.height - borderWidth, insulinTypeTF.frame.size.width, insulinTypeTF.frame.size.height);
    border4.frame = CGRectMake(0, insulinUnitsTF.frame.size.height - borderWidth, insulinUnitsTF.frame.size.width, insulinUnitsTF.frame.size.height);
    border5.frame = CGRectMake(0, carbsTF.frame.size.height - borderWidth, carbsTF.frame.size.width, carbsTF.frame.size.height);
    border6.frame = CGRectMake(0, tagTF.frame.size.height - borderWidth, tagTF.frame.size.width, tagTF.frame.size.height);
    border7.frame = CGRectMake(0, feelingTF.frame.size.height - borderWidth, feelingTF.frame.size.width, feelingTF.frame.size.height);
    border8.frame = CGRectMake(0, notesTF.frame.size.height - borderWidth, notesTF.frame.size.width, notesTF.frame.size.height);
    border.borderWidth = borderWidth;
    border2.borderWidth = borderWidth;
    border3.borderWidth = borderWidth;
    border4.borderWidth = borderWidth;
    border5.borderWidth = borderWidth;
    border6.borderWidth = borderWidth;
    border7.borderWidth = borderWidth;
    border8.borderWidth = borderWidth;
    
    [dateTimeTF.layer addSublayer:border];
    [glucoseLevelTF.layer addSublayer:border2];
    [insulinUnitsTF.layer addSublayer:border3];
    [insulinTypeTF.layer addSublayer:border4];
    [carbsTF.layer addSublayer:border5];
    [tagTF.layer addSublayer:border6];
    [feelingTF.layer addSublayer:border7];
    [notesTF.layer addSublayer:border8];
    dateTimeTF.layer.masksToBounds = YES;
    glucoseLevelTF.layer.masksToBounds = YES;
    insulinTypeTF.layer.masksToBounds = YES;
    insulinUnitsTF.layer.masksToBounds = YES;
    carbsTF.layer.masksToBounds = YES;
    tagTF.layer.masksToBounds = YES;
    feelingTF.layer.masksToBounds = YES;
    notesTF.layer.masksToBounds = YES;
    dateTimeTF.delegate = self;
    glucoseLevelTF.delegate = self;
    insulinUnitsTF.delegate = self;
    insulinTypeTF.delegate = self;
    carbsTF.delegate = self;
    tagTF.delegate = self;
    feelingTF.delegate = self;
    notesTF.delegate = self;
    
    numberArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < 501; i++) {
        [numberArray addObject:[NSString stringWithFormat:@"%d", i]];
    }
    
    insulinTypeArray = [[NSArray alloc]initWithObjects:@"Fast Acting", @"Pre Mix", @"Long Acting (BASAL)", nil];
    
    tagArray = [[NSArray alloc]initWithObjects:@"Pre-Breakfast", @"Post-Breakfast", @"Pre-Lunch", @"Post-Lunch", @"Pre-Dinner", @"Post-Dinner", @"Night", nil];
    
    feelingsArray = [[NSArray alloc]initWithObjects:@"Great", @"Just Ok", @"Not So Good", @"Terrible", nil];
    
    glucoseLevelPicker.delegate = self;
    glucoseLevelPicker.dataSource = self;
    glucoseLevelPicker.hidden = YES;
    
    insulinUnitsPicker.delegate = self;
    insulinUnitsPicker.dataSource = self;
    insulinUnitsPicker.hidden = YES;
    
    insulinTypePicker.delegate = self;
    insulinTypePicker.dataSource = self;
    insulinTypePicker.hidden = YES;
    
    carbsPicker.delegate = self;
    carbsPicker.dataSource = self;
    carbsPicker.hidden = YES;
    
    feelingPicker.delegate = self;
    feelingPicker.dataSource = self;
    feelingPicker.hidden = YES;
    
    tagPicker.delegate = self;
    tagPicker.dataSource = self;
    tagPicker.hidden = YES;
    
    dateTimePicker.backgroundColor = [UIColor whiteColor];
    dateTimePicker.alpha = 1.0;
    
    UIView *view = [[dateTimePicker subviews]objectAtIndex:0];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    [dateTimePicker addTarget:self action:@selector(datePicked:) forControlEvents:UIControlEventValueChanged];
    [dateTimePicker setMaximumDate:[NSDate date]];
    [self datePicked:self];

}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return NO;
}

- (IBAction)dismissView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveGlucose:(id)sender {
    
//    NSString *dateTimeString = dateTimeTF.text;
    NSString *glucoseString = glucoseLevelTF.text;
    int glucoseValue = [glucoseString intValue];
    NSString *insulinUnitsString = insulinUnitsTF.text;
    int insulinValue = [insulinUnitsString intValue];
    NSString *insulinTypeString = insulinTypeTF.text;
    NSString *carbsString = carbsTF.text;
    int carbValue = [carbsString intValue];
    NSString *tagString = tagTF.text;
    int tagValue = [tagString intValue];
    NSString *feelingString = feelingTF.text;
    int feelingValue = [feelingString intValue];
    NSString *notesString = notesTF.text;
    
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    Diabetes *entity = [NSEntityDescription insertNewObjectForEntityForName:@"Diabetes" inManagedObjectContext:coreDataStack.managedObjectContext];
    
    if (glucoseValue) {
        entity.created_at = [[NSDate date]timeIntervalSinceNow];
        entity.tracked_at = [[NSDate date]timeIntervalSinceNow];
        entity.glucose_level = glucoseValue;
        entity.insulin_type = insulinTypeString;
        entity.insulin_units = insulinValue;
        entity.carbs = carbValue;
        entity.tag = tagValue;
        entity.feeling = feelingValue;
        entity.notes = notesString;
        
        [coreDataStack saveContext];
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [RKDropdownAlert title:@"Saving Error" message:@"There was an error saving your glucose level" backgroundColor:[UIColor redColor] textColor:[UIColor whiteColor]];
    }

}


#pragma mark - Picker View Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if ([pickerView isEqual:glucoseLevelPicker]){
        return [numberArray count];
    } else if ([pickerView isEqual:insulinTypePicker]){
        return [insulinTypeArray count];
    } else if ([pickerView isEqual:feelingPicker]){
        return [feelingsArray count];
    } else if ([pickerView isEqual:tagPicker]){
        return [tagArray count];
    } else if ([pickerView isEqual:carbsPicker]){
        return [numberArray count];
    } else if ([pickerView isEqual:insulinUnitsPicker]){
        return [numberArray count];
    } else {
        return 0;
    }
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    pickerView.backgroundColor = [UIColor whiteColor];
    
    if ([pickerView isEqual:glucoseLevelPicker]) {
        return [numberArray objectAtIndex:row];
    } else if ([pickerView isEqual:insulinUnitsPicker]){
        return [numberArray objectAtIndex:row];
    } else if ([pickerView isEqual:insulinTypePicker]){
        return [insulinTypeArray objectAtIndex:row];
    } else if ([pickerView isEqual:carbsPicker]){
        return [numberArray objectAtIndex:row];
    } else if ([pickerView isEqual:feelingPicker]){
        return [feelingsArray objectAtIndex:row];
    } else if ([pickerView isEqual:tagPicker]){
        return [tagArray objectAtIndex:row];
    } else {
        return @"No data here";
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if ([pickerView isEqual:glucoseLevelPicker]) {
        glucoseLevelTF.text = [NSString stringWithFormat:@"%ld", (long)row];
    } else if ([pickerView isEqual:insulinUnitsPicker]){
        insulinUnitsTF.text = [NSString stringWithFormat:@"%ld", (long)row];
    } else if ([pickerView isEqual:insulinTypePicker]){
        insulinTypeTF.text = [NSString stringWithFormat:@"%@", [insulinTypeArray objectAtIndex:row]];
    } else if ([pickerView isEqual:carbsPicker]){
        carbsTF.text = [NSString stringWithFormat:@"%ld", (long)row];
    } else if ([pickerView isEqual:tagPicker]){
        tagTF.text = [NSString stringWithFormat:@"%@", [tagArray objectAtIndex:row]];
    } else if ([pickerView isEqual:feelingPicker]){
        feelingTF.text = [NSString stringWithFormat:@"%@", [feelingsArray objectAtIndex:row]];
    }
}

- (void)datePicked:(id)sender{
    if (self.dateTimePicker.alpha !=0) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mma"];
        
        dateTimeTF.text = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:dateTimePicker.date]];
    }
}

#pragma mark
#pragma mark - UITextField Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSInteger nextTag = textField.tag + 1;
    UIResponder *nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        [nextResponder becomeFirstResponder];
        
    } else {
        [textField resignFirstResponder];
        [self setViewMovedUp:NO];
    }
    return NO;
}


- (void)dismissKeyboard {
    [notesTF resignFirstResponder];
    [self setViewMovedUp:NO];
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [textView resignFirstResponder];
    [self setViewMovedUp:NO];
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (void)keyboardWillShow {
    // Animate the current view out of the way
    if (self.view.frame.origin.y >= 0) {
        [self setViewMovedUp:YES];
    } else if (self.view.frame.origin.y < 0) {
        [self setViewMovedUp:NO];
    }
}

- (void)keyboardWillHide {
    if (self.view.frame.origin.y >= 0) {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0) {
        [self setViewMovedUp:NO];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if ([textField isEqual:notesTF]) {
        //move the main view, so that the keyboard does not hide it.
        if  (self.view.frame.origin.y >= 0) {
            [self setViewMovedUp:YES];
        }
        glucoseLevelPicker.hidden = YES;
        insulinTypePicker.hidden = YES;
        insulinUnitsPicker.hidden = YES;
        carbsPicker.hidden = YES;
        tagPicker.hidden = YES;
        feelingPicker.hidden = YES;
        dateTimePicker.hidden = YES;
    } else if ([textField isEqual:glucoseLevelTF]){
        [textField resignFirstResponder];
        glucoseLevelPicker.hidden = NO;
        insulinTypePicker.hidden = YES;
        insulinUnitsPicker.hidden = YES;
        carbsPicker.hidden = YES;
        tagPicker.hidden = YES;
        feelingPicker.hidden = YES;
        dateTimePicker.hidden = YES;
    } else if ([textField isEqual:insulinUnitsTF]){
        [textField resignFirstResponder];
        insulinUnitsPicker.hidden = NO;
        insulinTypePicker.hidden = YES;
        glucoseLevelPicker.hidden = YES;
        carbsPicker.hidden = YES;
        tagPicker.hidden = YES;
        feelingPicker.hidden = YES;
        dateTimePicker.hidden = YES;
    } else if ([textField isEqual:insulinTypeTF]){
        [textField resignFirstResponder];
        insulinTypePicker.hidden = NO;
        insulinUnitsPicker.hidden = YES;
        glucoseLevelPicker.hidden = YES;
        carbsPicker.hidden = YES;
        tagPicker.hidden = YES;
        feelingPicker.hidden = YES;
        dateTimePicker.hidden = YES;
    } else if ([textField isEqual:carbsTF]){
        [textField resignFirstResponder];
        carbsPicker.hidden = NO;
        insulinUnitsPicker.hidden = YES;
        glucoseLevelPicker.hidden = YES;
        insulinTypePicker.hidden = YES;
        tagPicker.hidden = YES;
        feelingPicker.hidden = YES;
        dateTimePicker.hidden = YES;
    } else if ([textField isEqual:tagTF]){
        [textField resignFirstResponder];
        tagPicker.hidden = NO;
        insulinUnitsPicker.hidden = YES;
        glucoseLevelPicker.hidden = YES;
        insulinTypePicker.hidden = YES;
        carbsPicker.hidden = YES;
        feelingPicker.hidden = YES;
        dateTimePicker.hidden = YES;
    } else if ([textField isEqual:feelingTF]){
        [textField resignFirstResponder];
        feelingPicker.hidden = NO;
        insulinUnitsPicker.hidden = YES;
        glucoseLevelPicker.hidden = YES;
        insulinTypePicker.hidden = YES;
        carbsPicker.hidden = YES;
        tagPicker.hidden = YES;
        dateTimePicker.hidden = YES;
    } else if ([textField isEqual:dateTimeTF]){
        [textField resignFirstResponder];
        dateTimePicker.hidden = NO;
        insulinUnitsPicker.hidden = YES;
        glucoseLevelPicker.hidden = YES;
        insulinTypePicker.hidden = YES;
        carbsPicker.hidden = YES;
        tagPicker.hidden = YES;
        feelingPicker.hidden = YES;
    }
}

//method to move the view up/down whenever the keyboard is shown/dismissed
- (void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp) {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    } else {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}


@end

//
//  NewProcedureViewController.m
//  HealthID
//
//  Created by Joshua Walsh on 6/2/15.
//  Copyright (c) 2015 Joshua Walsh. All rights reserved.
//

#import "NewProcedureViewController.h"
#import "Constants.h"
#import "Dates.h"

@interface NewProcedureViewController ()

@end

@implementation NewProcedureViewController
@synthesize procedureNameTF,
            isPublic,
            notesTF,
            procedure,
            collapseDateView,
            tap;

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
    border.frame = CGRectMake(0, procedureNameTF.frame.size.height - borderWidth, procedureNameTF.frame.size.width, procedureNameTF.frame.size.height);
    border3.frame = CGRectMake(0, notesTF.frame.size.height - borderWidth, notesTF.frame.size.width, notesTF.frame.size.height);
    border.borderWidth = borderWidth;
    border2.borderWidth = borderWidth;
    border3.borderWidth = borderWidth;
    [procedureNameTF.layer addSublayer:border];
    [notesTF.layer addSublayer:border3];
    procedureNameTF.layer.masksToBounds = YES;
    notesTF.layer.masksToBounds = YES;
    procedureNameTF.delegate = self;
    notesTF.delegate = self;

    collapseDateView = [[NDCollapsiveDateView alloc] initWithFrame:CGRectMake(16, 150, self.view.frame.size.width - 32, 45) title:@"Last Reaction Date" andImage:[UIImage imageNamed:@"calendar"]];
    [collapseDateView setShown:200.f andHiddenHeight:50];
    collapseDateView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    collapseDateView.backgroundColor = [UIColor whiteColor];
    collapseDateView.delegate = self;
    
    [self.view addSubview:collapseDateView];
    
}

#pragma mark - NDCollapsiveDatePickerView delegate

-(void)datePickerViewDidCollapse:(NDCollapsiveDatePickerView *)datePickerView {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *stringDate = [dateFormatter stringFromDate:datePickerView.date];
    NSLog(@"selected date: %@",stringDate);
}

- (void)dismissKeyboard{
    [procedureNameTF resignFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
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

- (IBAction)saveProcedure:(id)sender {
    
    NSString *name = procedureNameTF.text;
    NSString *notes = notesTF.text;
    
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    
    procedure = [NSEntityDescription insertNewObjectForEntityForName:@"Procedures" inManagedObjectContext:coreDataStack.managedObjectContext];
    
    if (name && name.length) {
        procedure.name = name;
        procedure.created_on = [[NSDate date]timeIntervalSince1970];
        procedure.notes = notes;
        procedure.procedure_date = [[NSDate date]timeIntervalSince1970];
        
        if (isPublic.isOn) {
            procedure.is_public = 1;
        } else {
            procedure.is_public = 0;
        }
        [coreDataStack saveContext];
        
        [self dismissView:self];
    } else {
        [RKDropdownAlert title:@"Saving Error" message:@"There was an error saving your procedure" backgroundColor:[UIColor redColor] textColor:[UIColor whiteColor]];
    }
}

- (IBAction)dismissView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end

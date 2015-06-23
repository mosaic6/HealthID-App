//
//  NewConditionViewController.m
//  HealthID
//
//  Created by Joshua Walsh on 5/31/15.
//  Copyright (c) 2015 Joshua Walsh. All rights reserved.
//

#import "NewConditionViewController.h"
#import "Constants.h"
#import "Dates.h"
@interface NewConditionViewController ()

@end

@implementation NewConditionViewController
@synthesize conditionNameTF,
            statusMenu,
            statusLabel,
            notesTF,
            isPublic,
            condition,
            collapseDateView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CALayer *border = [CALayer layer];
    CALayer *border2 = [CALayer layer];
    CGFloat borderWidth = 0.5f;
    border.borderColor = [UIColor darkGrayColor].CGColor;
    border2.borderColor = [UIColor darkGrayColor].CGColor;
    border.frame = CGRectMake(0, conditionNameTF.frame.size.height - borderWidth, conditionNameTF.frame.size.width, conditionNameTF.frame.size.height);
    border2.frame = CGRectMake(0, notesTF.frame.size.height - borderWidth, notesTF.frame.size.width, notesTF.frame.size.height);
    border.borderWidth = borderWidth;
    border2.borderWidth = borderWidth;
    [conditionNameTF.layer addSublayer:border];
    [notesTF.layer addSublayer:border2];
    conditionNameTF.layer.masksToBounds = YES;
    notesTF.layer.masksToBounds = YES;
    conditionNameTF.delegate = self;
    notesTF.delegate = self;

    NSArray *statusList = @[@{@"image":@"sun.png",@"title":@"Diagnosed"},
                             @{@"image":@"clouds.png",@"title":@"In Treatment"},
                             @{@"image":@"snow.png",@"title":@"Remission"},
                             @{@"image":@"snow.png",@"title":@"Resolved"}];
    
    
    NSMutableArray *menuItems = [[NSMutableArray alloc]init];
    for (int i = 0; i < statusList.count; i++) {
        NSDictionary *dict = statusList[i];
        
        IGLDropDownItem *item = [[IGLDropDownItem alloc]init];
        [item setText:dict[@"title"]];
        [menuItems addObject:item];
    }
    
    statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 150, self.view.frame.size.width - 32, 45)];
    statusLabel.textAlignment = NSTextAlignmentCenter;
    statusLabel.font = [UIFont fontWithName:@"Dosis-Regular" size:24];
    statusLabel.text = @"Status";
    
    statusMenu = [[IGLDropDownMenu alloc]init];
    statusMenu.menuText = @"Status";
    statusMenu.dropDownItems = menuItems;
    statusMenu.paddingLeft = 15;
    [statusMenu setFrame:CGRectMake(16, 150, self.view.frame.size.width - 32, 45)];
    [statusMenu reloadView];
    statusMenu.delegate = self;
    
    collapseDateView = [[NDCollapsiveDateView alloc] initWithFrame:CGRectMake(16, 210, self.view.frame.size.width - 32, 45) title:@"Last Reaction Date" andImage:[UIImage imageNamed:@"calendar"]];
    [collapseDateView setShown:200.f andHiddenHeight:50];
    collapseDateView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    collapseDateView.backgroundColor = [UIColor whiteColor];
    collapseDateView.delegate = self;
    
    [self.view addSubview:statusLabel];
    [self.view addSubview:collapseDateView];
    [self.view addSubview:statusMenu];
    
}

- (void)dismissKeyboard{
    [conditionNameTF resignFirstResponder];
    [notesTF resignFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
  
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

- (void)dropDownMenu:(IGLDropDownMenu *)dropDownMenu selectedItemAtIndex:(NSInteger)index
{
    IGLDropDownItem *item = dropDownMenu.dropDownItems[index];
    statusLabel.text = [NSString stringWithFormat:@"%@", item.text];
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
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveNewCondition:(id)sender {
    
    NSString *name = conditionNameTF.text;
    NSString *notes = notesTF.text;
    NSString *status = statusLabel.text;
    
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    condition = [NSEntityDescription insertNewObjectForEntityForName:@"Conditions" inManagedObjectContext:coreDataStack.managedObjectContext];
    
    if (name && name.length) {
        condition.name = name;
        condition.created_at = [[NSDate date]timeIntervalSince1970];
        condition.status = status;
        condition.notes = notes;
        condition.date_diagnosed = [[NSDate date]timeIntervalSince1970];
        if (isPublic.isOn) {
            condition.is_public = 1;
        } else {
            condition.is_public = 0;
        }
        
        [coreDataStack saveContext];
        
        [self dismissView:self];
        
    } else {
        [RKDropdownAlert title:@"Saving Error" message:@"There was an error saving your condition" backgroundColor:[UIColor redColor] textColor:[UIColor whiteColor]];
    }
    
    
    
}
@end

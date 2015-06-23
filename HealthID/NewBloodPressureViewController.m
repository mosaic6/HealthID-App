//
//  NewBloodPressureViewController.m
//  HealthID
//
//  Created by Joshua Walsh on 5/27/15.
//  Copyright (c) 2015 Joshua Walsh. All rights reserved.
//

#import "NewBloodPressureViewController.h"
#import "BloodPressure.h"
#import "CoreDataStack.h"
@interface NewBloodPressureViewController ()

@end

@implementation NewBloodPressureViewController
@synthesize systolicTF, diastolicTF, bpPicker, systolicData, diastolicData;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    systolicData = [[NSMutableArray alloc]init];
    diastolicData = [[NSMutableArray alloc]init];
    
    
    for (int i = 0; i < 501; i++) {
        [systolicData addObject:[NSString stringWithFormat:@"%d", i]];
        [diastolicData addObject:[NSString stringWithFormat:@"%d", i]];
    }
    
    self.bpPicker.delegate = self;
    self.bpPicker.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)dismissView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveBloodPressure:(id)sender {
    
    NSString *diastolicString = diastolicTF.text;
    NSString *systolicString = systolicTF.text;
    int diastolicValue = [diastolicString intValue];
    int systolicValue = [systolicString intValue];
    
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    
    BloodPressure *entry = [NSEntityDescription insertNewObjectForEntityForName:@"BloodPressure" inManagedObjectContext:coreDataStack.managedObjectContext];
    
    if (diastolicValue && systolicValue) {
        entry.diastolic = diastolicValue;
        entry.systolic = systolicValue;
        entry.created_at = [[NSDate date]timeIntervalSinceNow];
        [coreDataStack saveContext];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [RKDropdownAlert title:@"Saving Error" message:@"There was an error saving your blood pressure" backgroundColor:[UIColor redColor] textColor:[UIColor whiteColor]];
    }
}

#pragma mark - Picker View Delegate

#pragma mark - Picker View Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0){
        return [systolicData count];
    } else {
        return [diastolicData count];
    }
    
    
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        return [systolicData objectAtIndex:row];
    } else {
        return [diastolicData objectAtIndex:row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSInteger firstNum = [self.bpPicker selectedRowInComponent:0];
    NSInteger secondNum = [self.bpPicker selectedRowInComponent:1];
    
    systolicTF.text = [NSString stringWithFormat:@"%ld", (long)firstNum];
    diastolicTF.text = [NSString stringWithFormat:@"%ld", (long)secondNum];
}
@end

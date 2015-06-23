//
//  NewCholesterolViewController.m
//  HealthID
//
//  Created by Joshua Walsh on 6/17/15.
//  Copyright (c) 2015 Joshua Walsh. All rights reserved.
//

#import "NewCholesterolViewController.h"
#import "Cholesterols.h"
#import "CoreDataStack.h"
@interface NewCholesterolViewController ()

@end

@implementation NewCholesterolViewController
@synthesize cholesterolData,cholesterolPicker,cholesterolTF;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    cholesterolData = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < 501; i++) {
        [cholesterolData addObject:[NSString stringWithFormat:@"%d", i]];
    }
    
    self.cholesterolPicker.delegate = self;
    self.cholesterolPicker.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismissView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveCholesterol:(id)sender {
    NSString *cholesterolString = cholesterolTF.text;
    int cholesterolValue = [cholesterolString intValue];
    
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    Cholesterols *entity = [NSEntityDescription insertNewObjectForEntityForName:@"Cholesterols" inManagedObjectContext:coreDataStack.managedObjectContext];
    
    if (cholesterolValue) {
        entity.value = cholesterolValue;
        entity.created_at = [[NSDate date]timeIntervalSinceNow];
        [coreDataStack saveContext];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [RKDropdownAlert title:@"Saving Error" message:@"There was an error saving your cholesterol" backgroundColor:[UIColor redColor] textColor:[UIColor whiteColor]];
    }
}

#pragma mark - Picker View Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0){
        return [cholesterolData count];
    } else {
        return 0;
    }
    
    
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        return [cholesterolData objectAtIndex:row];
    } else {
        return @"No data here";
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSInteger firstNum = [self.cholesterolPicker selectedRowInComponent:0];
    
    cholesterolTF.text = [NSString stringWithFormat:@"%ld", (long)firstNum];
}

@end

//
//  NewWeightViewController.m
//  HealthID
//
//  Created by Joshua Walsh on 5/27/15.
//  Copyright (c) 2015 Joshua Walsh. All rights reserved.
//

#import "NewWeightViewController.h"
#import "CoreDataStack.h"
#import "Weights.h"
@interface NewWeightViewController ()

@end

@implementation NewWeightViewController
@synthesize weightTF, weightPicker, weightArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    weightArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < 501; i++) {
        [weightArray addObject:[NSString stringWithFormat:@"%d", i]];
    }
    
    self.weightPicker.dataSource = self;
    self.weightPicker.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (IBAction)dismissView:(id)sender {
    [weightTF resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveWeight:(id)sender {
    
    NSString *string = weightTF.text;
    float value = [string floatValue];
    
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    
    Weights *entry = [NSEntityDescription insertNewObjectForEntityForName:@"Weights" inManagedObjectContext:coreDataStack.managedObjectContext];
    
    if (value) {
        entry.value = value;
        entry.created_at = [[NSDate date]timeIntervalSince1970];
        [coreDataStack saveContext];
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [RKDropdownAlert title:@"Saving Error" message:@"There was an error saving your weight" backgroundColor:[UIColor redColor] textColor:[UIColor whiteColor]];
    }
    
}

#pragma mark - Picker View Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [weightArray count];
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return weightArray[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSLog(@"%ld",(long)component);
    weightTF.text = [NSString stringWithFormat:@"%ld", (long)row];
}
@end

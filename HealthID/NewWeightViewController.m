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
@synthesize weightTF,
            weightPicker,
            weightArray,
            healthStore,
            date;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    weightArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < 501; i++) {
        [weightArray addObject:[NSString stringWithFormat:@"%d", i]];
    }
    
    self.weightPicker.dataSource = self;
    self.weightPicker.delegate = self;
    
    healthStore = [[HKHealthStore alloc] init];
    date = [NSDate date];
    
    [self getWeight];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [weightPicker selectRow:150 inComponent:0 animated:NO];
    [weightPicker reloadAllComponents];
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
        [self updateWeight];
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
    weightTF.text = [NSString stringWithFormat:@"%ld", (long)row];
}

#pragma mark - HealthKit

- (void)updateWeight{
    
    double weightInGrams = [weightTF.text intValue];
    
    NSMassFormatter *massFormatter = [[NSMassFormatter alloc]init];
    massFormatter.unitStyle = NSMassFormatterUnitPound;
    
    HKQuantityType *hkQuantityType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    HKQuantity *hkQuantity = [HKQuantity quantityWithUnit:[HKUnit poundUnit] doubleValue:weightInGrams];
    
    HKQuantitySample *weightSample = [HKQuantitySample quantitySampleWithType:hkQuantityType quantity:hkQuantity startDate:date endDate:date];
    [healthStore saveObject:weightSample withCompletion:^(BOOL success, NSError *error) {
        
        if(success){
            NSLog(@"Success");
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void)getWeight {
    // Fetch the user's default weight unit in pounds.
    NSMassFormatter *massFormatter = [[NSMassFormatter alloc] init];
    massFormatter.unitStyle = NSFormattingUnitStyleShort;
    
    NSMassFormatterUnit weightFormatterUnit = NSMassFormatterUnitPound;
    self.weightTF.text = [massFormatter unitStringFromValue:10 unit:weightFormatterUnit];
    
    // Query to get the user's latest weight, if it exists.
    HKQuantityType *weightType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    [self fetchMostRecentDataofQuanityType:weightType withCompletion:^(HKQuantity *mostRecentQuantity, NSError *error) {
        if (error) {
            NSLog(@"An error occured fetching the user's weight information. In your app, try to handle this gracefully. The error was: %@.", error);
            abort();
        }
        
        // Determine the weight in the required unit.
        double usersWeight = 0.0;
        
        if (mostRecentQuantity) {
            HKUnit *weightUnit = [HKUnit poundUnit];
            usersWeight = [mostRecentQuantity doubleValueForUnit:weightUnit];
            
            // Update the user interface.
            dispatch_async(dispatch_get_main_queue(), ^{
                self.weightTF.text = [NSNumberFormatter localizedStringFromNumber:@(usersWeight) numberStyle:NSNumberFormatterNoStyle];
            });
        }
    }];
}

- (void)fetchMostRecentDataofQuanityType:(HKQuantityType *)quantityType withCompletion:(void(^)(HKQuantity *mostRecentQuantity, NSError *error))completion{
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:HKSampleSortIdentifierStartDate ascending:NO];
    HKSampleQuery *query = [[HKSampleQuery alloc] initWithSampleType:quantityType predicate:nil limit:1 sortDescriptors:@[sortDescriptor] resultsHandler:^(HKSampleQuery *query, NSArray *results, NSError *error) {
        if (completion && error) {
            completion(nil, error);
            return;
        }
        HKQuantitySample *quantitySample = results.firstObject;
        HKQuantity *quantity = quantitySample.quantity;
        if (completion)completion(quantity, error);
    }];
    [self.healthStore executeQuery:query];

}

#pragma mark - Convenience

- (NSNumberFormatter *)numberFormatter {
    static NSNumberFormatter *numberFormatter;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        numberFormatter = [[NSNumberFormatter alloc] init];
    });
    
    return numberFormatter;
}

@end

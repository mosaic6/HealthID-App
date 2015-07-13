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
@synthesize cholesterolData,
            cholesterolPicker,
            cholesterolTF,
            healthStore,
            date;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    cholesterolData = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < 501; i++) {
        [cholesterolData addObject:[NSString stringWithFormat:@"%d", i]];
    }
    
    self.cholesterolPicker.delegate = self;
    self.cholesterolPicker.dataSource = self;
    
    healthStore = [[HKHealthStore alloc]init];
    date = [NSDate date];
    
    [self getCholesterol];
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
        
        [self updateCholesterol];
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

#pragma mark - HealthKit

- (void)updateCholesterol{
    
    double cholesterolInGrams = [cholesterolTF.text doubleValue];
    HKUnit *mgPerdL = [HKUnit unitFromString:@"mg"];

    HKQuantityType *hkQuantityType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryCholesterol];
    HKQuantity *hkQuantity = [HKQuantity quantityWithUnit:mgPerdL doubleValue:cholesterolInGrams];
    
    [hkQuantity isCompatibleWithUnit:[HKUnit unitFromString:@"kg"]];
    
    HKQuantitySample *weightSample = [HKQuantitySample quantitySampleWithType:hkQuantityType quantity:hkQuantity startDate:date endDate:date];
    [healthStore saveObject:weightSample withCompletion:^(BOOL success, NSError *error) {
        
        if(success){
            NSLog(@"Success");
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void)getCholesterol {
    // Fetch the user's default cholesterol unit in pounds.
    NSMassFormatter *massFormatter = [[NSMassFormatter alloc] init];
    massFormatter.unitStyle = NSFormattingUnitStyleShort;
    
    NSMassFormatterUnit cholesterolFormatterUnit = NSMassFormatterUnitGram;
    self.cholesterolTF.text = [massFormatter unitStringFromValue:10 unit:cholesterolFormatterUnit];
    
    // Query to get the user's latest weight, if it exists.
    HKQuantityType *cholesterolType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryCholesterol];
    [self fetchMostRecentDataofQuanityType:cholesterolType withCompletion:^(HKQuantity *mostRecentQuantity, NSError *error) {
        if (error) {
            NSLog(@"An error occured fetching the user's cholesterol information. In your app, try to handle this gracefully. The error was: %@.", error);
            abort();
        }
        
        // Determine the weight in the required unit.
        double usersCholesterol = 0.0;
        
        if (mostRecentQuantity) {
            HKUnit *cholesterolUnit = [HKUnit gramUnit];
            usersCholesterol = [mostRecentQuantity doubleValueForUnit:cholesterolUnit];
            
            // Update the user interface.
            dispatch_async(dispatch_get_main_queue(), ^{
                self.cholesterolTF.text = [NSNumberFormatter localizedStringFromNumber:@(usersCholesterol) numberStyle:NSNumberFormatterNoStyle];
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

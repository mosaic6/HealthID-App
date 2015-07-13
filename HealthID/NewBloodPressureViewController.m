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
@synthesize systolicTF,
            diastolicTF,
            bpPicker,
            systolicData,
            diastolicData,
            date,
            healthStore;

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
    
    healthStore = [[HKHealthStore alloc] init];
    date = [NSDate date];
    
    [self getBloodPressure];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [bpPicker selectRow:120 inComponent:0 animated:NO];
    [bpPicker selectRow:80 inComponent:1 animated:NO];
    [bpPicker reloadAllComponents];
}

- (IBAction)dismissView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveBloodPressure:(id)sender {
    
    NSString *diastolicString = diastolicTF.text;
    NSString *systolicString = systolicTF.text;
    double diastolicValue = [diastolicString doubleValue];
    double systolicValue = [systolicString doubleValue];
    
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    
    BloodPressure *entry = [NSEntityDescription insertNewObjectForEntityForName:@"BloodPressure" inManagedObjectContext:coreDataStack.managedObjectContext];
    
    if (diastolicValue && systolicValue) {
        entry.diastolic = diastolicValue;
        entry.systolic = systolicValue;
        entry.created_at = [[NSDate date]timeIntervalSinceNow];
        [self saveBloodPressureIntoHealthStore:systolicValue Dysbp:diastolicValue];
        [coreDataStack saveContext];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [RKDropdownAlert title:@"Saving Error" message:@"There was an error saving your blood pressure" backgroundColor:[UIColor redColor] textColor:[UIColor whiteColor]];
    }
}


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

#pragma mark - HealthKit

- (void)saveBloodPressureIntoHealthStore:(double)Systolic Dysbp:(double)Diastolic {
    
    HKUnit *BloodPressureUnit = [HKUnit millimeterOfMercuryUnit];
    
    HKQuantity *SystolicQuantity = [HKQuantity quantityWithUnit:BloodPressureUnit doubleValue:Systolic];
    HKQuantity *DiastolicQuantity = [HKQuantity quantityWithUnit:BloodPressureUnit doubleValue:Diastolic];
    
    HKQuantityType *SystolicType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodPressureSystolic];
    HKQuantityType *DiastolicType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodPressureDiastolic];
    
    NSDate *now = [NSDate date];
    
    HKQuantitySample *SystolicSample = [HKQuantitySample quantitySampleWithType:SystolicType quantity:SystolicQuantity startDate:now endDate:now];
    HKQuantitySample *DiastolicSample = [HKQuantitySample quantitySampleWithType:DiastolicType quantity:DiastolicQuantity startDate:now endDate:now];
    
    NSSet *objects=[NSSet setWithObjects:SystolicSample,DiastolicSample, nil];
    HKCorrelationType *bloodPressureType = [HKObjectType correlationTypeForIdentifier:
                                            HKCorrelationTypeIdentifierBloodPressure];
    HKCorrelation *BloodPressure = [HKCorrelation correlationWithType:bloodPressureType startDate:now endDate:now objects:objects];
    [self.healthStore saveObject:BloodPressure withCompletion:^(BOOL success, NSError *error) {
        if (!success) {
            NSLog(@"An error occured saving the height sample %@. In your app, try to handle this gracefully. The error was: %@.", BloodPressure, error);
            abort();
        }
    }];
}

- (void)getBloodPressure {
    
    // Fetch the user's default bp unit in millimeters.
    NSMassFormatter *massFormatter = [[NSMassFormatter alloc] init];
    massFormatter.unitStyle = NSFormattingUnitStyleMedium;
    
    NSMassFormatterUnit bpFormatterUnit = NSMassFormatterUnitGram;
    self.systolicTF.text = [massFormatter unitStringFromValue:10 unit:bpFormatterUnit];
    self.diastolicTF.text = [massFormatter unitStringFromValue:10 unit:bpFormatterUnit];
    
    // Query to get the user's latest weight, if it exists.
    HKQuantityType *bpTypeSystolic = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodPressureSystolic];
    [self fetchMostRecentDataofQuanityType:bpTypeSystolic withCompletion:^(HKQuantity *mostRecentQuantity, NSError *error) {
        if (error) {
            NSLog(@"An error occured fetching the user's weight information. In your app, try to handle this gracefully. The error was: %@.", error);
            abort();
        }
        
        // Determine the weight in the required unit.
        double usersBP = 0.0;
        
        if (mostRecentQuantity) {
            HKUnit *bpUnit = [HKUnit millimeterOfMercuryUnit];
            usersBP = [mostRecentQuantity doubleValueForUnit:bpUnit];
            
            // Update the user interface.
            dispatch_async(dispatch_get_main_queue(), ^{
                self.systolicTF.text = [NSNumberFormatter localizedStringFromNumber:@(usersBP) numberStyle:NSNumberFormatterNoStyle];
            });
        }
    }];
    
    HKQuantityType *bpTypeDiastolic = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodPressureDiastolic];
    [self fetchMostRecentDataofQuanityType:bpTypeDiastolic withCompletion:^(HKQuantity *mostRecentQuantity, NSError *error) {
        if (error) {
            NSLog(@"An error occured fetching the user's weight information. In your app, try to handle this gracefully. The error was: %@.", error);
            abort();
        }
        
        // Determine the weight in the required unit.
        double usersBP = 0.0;
        
        if (mostRecentQuantity) {
            HKUnit *bpUnit = [HKUnit millimeterOfMercuryUnit];
            usersBP = [mostRecentQuantity doubleValueForUnit:bpUnit];
            
            // Update the user interface.
            dispatch_async(dispatch_get_main_queue(), ^{
                self.diastolicTF.text = [NSNumberFormatter localizedStringFromNumber:@(usersBP) numberStyle:NSNumberFormatterNoStyle];
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

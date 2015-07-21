//
//  DashboardViewController.m
//  HealthID
//
//  Created by Joshua Walsh on 5/25/15.
//  Copyright (c) 2015 Joshua Walsh. All rights reserved.
//

#import "DashboardViewController.h"
#import "Dates.h"
#import "NewMedicationViewController.h"
#import "DashboardCards.h"
#import "Canvas.h"
@interface DashboardViewController ()

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation DashboardViewController
@synthesize welcomeView, dashboardList, mainCollectionView;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBar.backItem.hidesBackButton = YES;
    Dates *date = [[Dates alloc]init];
    date.date = [[NSDate alloc]initWithTimeIntervalSinceNow:0];
    date.dateFormatter = [[NSDateFormatter alloc]init];
    [date.dateFormatter setDateFormat:@"MM/dd/yyyy hh:mma"];
    date.dateString = [date.dateFormatter stringFromDate:date.date];
    NSLog(@"%@", date.dateString);
    
    dashboardList = [[NSArray alloc]initWithObjects:@"Medications",
                     @"Diabetes",
                     @"Weight",
                     @"Blood Pressure",
                     @"Allergies",
                     @"Conditions",
                     @"Procedures",
                     @"Cholesterol",
                     @"Vaccinations", nil];
    
//    welcomeView.hidden = YES;
    
    [self.fetchedResultsController performFetch:nil];
    
    [self healthKit];
    
    DashboardCards *card = [[DashboardCards alloc]initWithFrame:CGRectMake(16, 100, self.view.frame.size.width - 16, 200)];
    
    card.hidden = YES;
    
    [self.view addSubview:card];
    
    self.mainCollectionView.delegate = self;
    self.mainCollectionView.dataSource = self;
    [mainCollectionView reloadData];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBarHidden = YES;
}

- (NSFetchRequest *)entryListFetchRequest{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Weights"];
    
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"created_at" ascending:NO]];
    
    return request;
}

- (NSFetchedResultsController *)fetchedResultsController{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    NSFetchRequest *request = [self entryListFetchRequest];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:coreDataStack.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    return _fetchedResultsController;
}

#pragma mark - HealthKit

- (void)healthKit {
    if(NSClassFromString(@"HKHealthStore") && [HKHealthStore isHealthDataAvailable])
    {
        NSLog(@"HealthKit Available");
        
        HKHealthStore *healthStore = [[HKHealthStore alloc] init];
        
        // Share body mass, height and body mass index
        NSSet *shareObjectTypes = [NSSet setWithObjects:
                                   [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass],
                                   [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight],
                                   [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMassIndex],
//                                   [HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierDateOfBirth],
//                                   [HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierBiologicalSex],
                                   [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount],
                                   [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodGlucose],
                                   [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodPressureDiastolic],
                                   [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodPressureSystolic],
                                   [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryCholesterol],
                                   nil];
        
        // Read date of birth, biological sex and step count
        NSSet *readObjectTypes  = [NSSet setWithObjects:
                                   [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass],
                                   [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight],
                                   [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMassIndex],
                                   [HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierDateOfBirth],
                                   [HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierBiologicalSex],
                                   [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount],
                                   [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodGlucose],
                                   [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodPressureDiastolic],
                                   [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodPressureSystolic],
                                   [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryCholesterol],
                                   nil];
        
        // Request access
        [healthStore requestAuthorizationToShareTypes:shareObjectTypes
                                            readTypes:readObjectTypes
                                           completion:^(BOOL success, NSError *error) {
                                               
                                               if(success == YES)
                                               {
                                                   NSLog(@"Success");
                                               }
                                               else
                                               {
                                                   NSLog(@"%@", error.localizedDescription);
                                               }
                                               
                                           }];
    }

}

#pragma mark - Collection View Methods


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [dashboardList count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    UILabel *cellLabel = (UILabel *)[cell viewWithTag:100];
    cellLabel.frame = CGRectMake(0, 0, self.view.frame.size.width, 30);
    UIImageView *cellImage = (UIImageView *)[cell viewWithTag:200];
    
    cellLabel.text = [dashboardList objectAtIndex:indexPath.row];
    
    [cell.layer setBorderWidth:1.0f];
    [cell.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [cell.layer setCornerRadius:50.0f];
    
    if ([cellLabel.text isEqualToString:@"Medications"]) {
        cellImage.image = [UIImage imageNamed:@"pillIcon"];
    } else if ([cellLabel.text isEqualToString:@"Diabetes"]){
        cellImage.image = [UIImage imageNamed:@"diabetesIcon"];
    } else if ([cellLabel.text isEqualToString:@"Weight"]){
        cellImage.image = [UIImage imageNamed:@"weight icon"];
    } else if ([cellLabel.text isEqualToString:@"Blood Pressure"]){
        cellImage.image = [UIImage imageNamed:@"bloodPressure"];
    } else if ([cellLabel.text isEqualToString:@"Allergies"]){
        cellImage.image = [UIImage imageNamed:@"allergies icon"];
    } else if ([cellLabel.text isEqualToString:@"Procedures"]){
        cellImage.image = [UIImage imageNamed:@"scalpel"];
    } else if ([cellLabel.text isEqualToString:@"Vaccinations"]){
        cellImage.image = [UIImage imageNamed:@"medical"];
    } else if ([cellLabel.text isEqualToString:@"Cholesterol"]){
        cellImage.image = [UIImage imageNamed:@"diabetesIcon"];
    } else if ([cellLabel.text isEqualToString:@"Conditions"]){
        cellImage.image = [UIImage imageNamed:@"diabetesIcon"];
    }

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    UILabel *cellLabel = (UILabel *)[cell viewWithTag:100];
    NSString *cellText = cellLabel.text;
    
    cell.transform = CGAffineTransformMakeScale(1, 1);
    [UIView animateKeyframesWithDuration:0.07 delay:0 options:0 animations:^{
        // End
        cell.transform = CGAffineTransformMakeScale(1, 1.2);
    } completion:^(BOOL finished) {
        [UIView animateKeyframesWithDuration:0.07 delay:0 options:0 animations:^{
            // End
            cell.transform = CGAffineTransformMakeScale(1.2, 0.9);
        } completion:^(BOOL finished) {
            [UIView animateKeyframesWithDuration:0.07 delay:0 options:0 animations:^{
                // End
                cell.transform = CGAffineTransformMakeScale(0.9, 0.9);
            } completion:^(BOOL finished) {
                [UIView animateKeyframesWithDuration:0.07 delay:0 options:0 animations:^{
                    // End
                    cell.transform = CGAffineTransformMakeScale(1, 1);
                } completion:^(BOOL finished) {
                    
                }];
            }];
        }];
    }];
    
    if ([cellText isEqualToString:@"Medications"]) {
        [self performSegueWithIdentifier:@"showNewMedication" sender:self];
    } else if ([cellText isEqualToString:@"Weight"]){
        [self performSegueWithIdentifier:@"showNewWeight" sender:self];
    } else if ([cellText isEqualToString:@"Blood Pressure"]){
        [self performSegueWithIdentifier:@"showNewBloodPressure" sender:self];
    } else if ([cellText isEqualToString:@"Allergies"]){
        [self performSegueWithIdentifier:@"showNewAllergy" sender:self];
    } else if ([cellText isEqualToString:@"Conditions"]){
        [self performSegueWithIdentifier:@"showNewCondition" sender:self];
    } else if ([cellText isEqualToString:@"Procedures"]){
        [self performSegueWithIdentifier:@"showNewProcedure" sender:self];
    } else if ([cellText isEqualToString:@"Vaccinations"]){
        [self performSegueWithIdentifier:@"showNewVaccination" sender:self];
    } else if ([cellText isEqualToString:@"Cholesterol"]){
        [self performSegueWithIdentifier:@"showNewCholesterol" sender:self];
    } else if ([cellText isEqualToString:@"Diabetes"]){
        [self performSegueWithIdentifier:@"showNewGlucose" sender:self];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
//    UILabel *cellLabel = (UILabel *)[cell viewWithTag:100];
//    NSString *cellText = cellLabel.text;
    
    [cell reloadInputViews];
}


@end

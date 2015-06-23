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
@interface DashboardViewController ()

@end

@implementation DashboardViewController
@synthesize welcomeView, startingTableList, dashboardList;
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
    
    startingTableList.delegate = self;
    startingTableList.dataSource = self;
    [startingTableList reloadData];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - Tableview Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dashboardList count];
}


#pragma mark - Tableview Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    cell.textLabel.font = [UIFont fontWithName:@"Dosis-Regular" size:20];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Dosis-Regular" size:18];
    
    cell.textLabel.text = [dashboardList objectAtIndex:indexPath.row];
    
    if ([cell.textLabel.text isEqualToString:@"Medications"]) {
        cell.imageView.image = [UIImage imageNamed:@"pillIcon"];
    } else if ([cell.textLabel.text isEqualToString:@"Diabetes"]){
        cell.imageView.image = [UIImage imageNamed:@"diabetesIcon"];
    } else if ([cell.textLabel.text isEqualToString:@"Weight"]){
        cell.imageView.image = [UIImage imageNamed:@"weight icon"];
    } else if ([cell.textLabel.text isEqualToString:@"Blood Pressure"]){
        cell.imageView.image = [UIImage imageNamed:@"bloodPressure"];
    } else if ([cell.textLabel.text isEqualToString:@"Allergies"]){
        cell.imageView.image = [UIImage imageNamed:@"allergies icon"];
    } else if ([cell.textLabel.text isEqualToString:@"Procedures"]){
        cell.imageView.image = [UIImage imageNamed:@"scalpel"];
    } else if ([cell.textLabel.text isEqualToString:@"Vaccinations"]){
        cell.imageView.image = [UIImage imageNamed:@"medical"];
    } else if ([cell.textLabel.text isEqualToString:@"Cholesterol"]){
        cell.imageView.image = [UIImage imageNamed:@"diabetesIcon"];
    } else if ([cell.textLabel.text isEqualToString:@"Conditions"]){
        cell.imageView.image = [UIImage imageNamed:@"diabetesIcon"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *cellText = cell.textLabel.text;
    
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

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSIndexPath *oldIndex = [tableView indexPathForSelectedRow];
    [tableView cellForRowAtIndexPath:oldIndex].accessoryType = UITableViewCellAccessoryNone;
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    return indexPath;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

}
@end

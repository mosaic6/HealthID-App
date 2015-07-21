//
//  NewMedicationViewController.m
//  HealthID
//
//  Created by Joshua Walsh on 5/26/15.
//  Copyright (c) 2015 Joshua Walsh. All rights reserved.
//

#import "NewMedicationViewController.h"
#import <AFNetworking/AFNetworking.h>
@interface NewMedicationViewController ()

@end

@implementation NewMedicationViewController
@synthesize medicationNameTF, medicationTableView, drugs, patients, activityView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CALayer *border = [CALayer layer];
    CGFloat borderWidth = 0.5f;
    border.borderColor = [UIColor darkGrayColor].CGColor;
    border.frame = CGRectMake(0, medicationNameTF.frame.size.height - borderWidth, medicationNameTF.frame.size.width, medicationNameTF.frame.size.height);
    border.borderWidth = borderWidth;
    [medicationNameTF.layer addSublayer:border];
    medicationNameTF.layer.masksToBounds = YES;
    [medicationNameTF becomeFirstResponder];
    
    drugs = [[NSArray alloc]init];
    patients = [[NSArray alloc]init];
    
    medicationTableView.hidden = YES;
    medicationTableView.dataSource = self;
    medicationTableView.delegate = self;
    [medicationTableView reloadData];

    activityView = [[UIActivityIndicatorView alloc]
                                             initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    activityView.center=self.view.center;
    activityView.hidden = YES;
    [self.view addSubview:activityView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}   

- (void)getMedicationName{
    NSString *medName = [[NSString alloc]initWithString:medicationNameTF.text];
    NSString *urlRequest = [NSString stringWithFormat:@"https://api.fda.gov/drug/event.json?api_key=fvSlHapDnXke1aq2FazJtEnrPwU2mcoXFLbLAlaa&search=%@",medName];
  
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlRequest parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        drugs = [responseObject objectForKey:@"results"];
        
        for (NSDictionary *drug in drugs) {
            patients = [[[[[drug valueForKey:@"patient"]
                                          valueForKey:@"drug"]
                                          valueForKey:@"openfda"]
                                          valueForKey:@"brand_name"]objectAtIndex:0];
            
            NSLog(@"%@", patients);
            
            [medicationTableView reloadData];
            [activityView startAnimating];
        }
        medicationTableView.hidden = NO;
        [medicationNameTF resignFirstResponder];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"ERROR: %@", error);
    }];
    activityView.hidden = NO;
    [activityView startAnimating];
}

- (IBAction)dismissView:(id)sender {
    [medicationNameTF resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveMedication:(id)sender {
}

- (IBAction)searchMed:(id)sender {
    
    [self getMedicationName];
}

#pragma mark - Tableview Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [patients count];
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
    
    NSDictionary *tempDict = [patients objectAtIndex:indexPath.row];
    self.drugName = [NSString stringWithFormat:@"%@", tempDict];
    
    
    if (![tempDict isKindOfClass:[NSNull class]]) {
        cell.textLabel.text = self.drugName;
        [activityView stopAnimating];
    } else {
        cell.textLabel.text = @"No drug found";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *cellText = cell.textLabel.text;
    
    medicationNameTF.text = cellText;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSIndexPath *oldIndex = [tableView indexPathForSelectedRow];
    [tableView cellForRowAtIndexPath:oldIndex].accessoryType = UITableViewCellAccessoryNone;
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    return indexPath;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
    return indexPath;
}

@end

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
@synthesize medicationNameTF;
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
//    medicationNameTF.text = 
    
    [medicationNameTF becomeFirstResponder];
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
        for (NSDictionary *item in responseObject) {
            NSLog(@"%@", item);
//            NSLog(@"%@", [item objectForKey:@"results"][@"brand_name"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"ERROR: %@", error);
    }];
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
@end

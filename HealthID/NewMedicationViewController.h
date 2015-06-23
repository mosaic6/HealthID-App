//
//  NewMedicationViewController.h
//  HealthID
//
//  Created by Joshua Walsh on 5/26/15.
//  Copyright (c) 2015 Joshua Walsh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"


@interface NewMedicationViewController : UIViewController <UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UITextField *medicationNameTF;
@property (strong, nonatomic) NSMutableArray *medicationList;

@property (strong, nonatomic) NSString *drugName;
@property (strong, nonatomic) NSString *dosage;

- (IBAction)dismissView:(id)sender;
- (IBAction)saveMedication:(id)sender;
- (IBAction)searchMed:(id)sender;
@end

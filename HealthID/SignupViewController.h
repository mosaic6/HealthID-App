//
//  SignupViewController.h
//  HealthID
//
//  Created by Joshua Walsh on 5/24/15.
//  Copyright (c) 2015 Joshua Walsh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SendGrid/SendGrid.h>
#import <SendGrid/SendGridEmail.h>
#import <KGModal/KGModal.h>
@interface SignupViewController : UIViewController <UITextFieldDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *signupBtn;
@property (weak, nonatomic) IBOutlet UITextField *emailTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *confirmTF;
@property (strong, nonatomic) UITapGestureRecognizer *tap;
@property (strong, nonatomic) KGModal *termsModal;
- (IBAction)signUp:(id)sender;
- (IBAction)showTerms:(id)sender;
@end

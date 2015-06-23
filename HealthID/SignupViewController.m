//
//  SignupViewController.m
//  HealthID
//
//  Created by Joshua Walsh on 5/24/15.
//  Copyright (c) 2015 Joshua Walsh. All rights reserved.
//

#import "SignupViewController.h"
#import "RKDropdownAlert.h"
@interface SignupViewController ()

@end

@implementation SignupViewController
@synthesize signupBtn, emailTF, passwordTF, confirmTF, tap, termsModal;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationItem.title = @"healthid";
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    signupBtn.layer.cornerRadius = 5;

    CALayer *border = [CALayer layer];
    CALayer *border2 = [CALayer layer];
    CALayer *border3 = [CALayer layer];
    CGFloat borderWidth = 0.5f;
    border.borderColor = [UIColor darkGrayColor].CGColor;
    border.frame = CGRectMake(0, emailTF.frame.size.height - borderWidth, emailTF.frame.size.width, emailTF.frame.size.height);
    border2.frame = CGRectMake(0, passwordTF.frame.size.height - borderWidth, passwordTF.frame.size.width, passwordTF.frame.size.height);
    border3.frame = CGRectMake(0, confirmTF.frame.size.height - borderWidth, confirmTF.frame.size.width, confirmTF.frame.size.height);
    border.borderWidth = borderWidth;
    border2.borderWidth = borderWidth;
    border3.borderWidth = borderWidth;
    [emailTF.layer addSublayer:border];
    [passwordTF.layer addSublayer:border2];
    [confirmTF.layer addSublayer:border3];
    emailTF.layer.masksToBounds = YES;
    passwordTF.layer.masksToBounds = YES;
    confirmTF.layer.masksToBounds = YES;
    
    emailTF.delegate = self;
    passwordTF.delegate = self;
    confirmTF.delegate = self;
    
    tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (![defaults boolForKey:@"registered"]) {
        NSLog(@"No user registered");
    } else {
        NSLog(@"User registered");
        NSLog(@"%@", [defaults objectForKey:@"email"]);
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [emailTF becomeFirstResponder];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Enable iOS 7 back gesture
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}

#pragma mark - Textfield Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSInteger nextTag = textField.tag + 1;
    UIResponder *nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        [nextResponder becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return NO;
}

- (void)dismissKeyboard {
    [emailTF resignFirstResponder];
    [passwordTF resignFirstResponder];
    [confirmTF resignFirstResponder];
}

- (IBAction)signUp:(id)sender {
    
    NSString *email = [self.emailTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *confirm = [self.confirmTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([email isEqualToString:@""] || [password isEqualToString:@""] || [confirm isEqualToString:@""]){
        [RKDropdownAlert title:@"Signup Error" message:@"There was an error signing up. Try again." backgroundColor:[UIColor redColor] textColor:[UIColor whiteColor]];
    }   else {
        [self registerNewUser];
        [self performSegueWithIdentifier:@"showDashboard" sender:self];
        
        SendGrid *sendgrid = [SendGrid apiUser:@"jtwalsh" apiKey:@"pK2VA4ag"];
        
        SendGridEmail *email = [[SendGridEmail alloc] init];
        email.to = emailTF.text;
        email.from = @"support@healthid.com";
        email.subject = @"Welcome to HealthID";
        email.html = @"<h1>This confirms your HealthID account</h1><br/><p>Start by setting up a medication, allergy, or any other medical condition that is important to you.</p>";
        email.text = @"This confirms your HealthID account";
        
        [sendgrid sendWithWeb:email];
    }
}

- (IBAction)showTerms:(id)sender {
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 250)];
    
    CGRect welcomeLabelRect = contentView.bounds;
    welcomeLabelRect.origin.y = 20;
    welcomeLabelRect.size.height = 20;
    UIFont *welcomeLabelFont = [UIFont boldSystemFontOfSize:17];
    UILabel *welcomeLabel = [[UILabel alloc] initWithFrame:welcomeLabelRect];
    welcomeLabel.text = @"Terms of Service";
    welcomeLabel.font = welcomeLabelFont;
    welcomeLabel.textColor = [UIColor whiteColor];
    welcomeLabel.textAlignment = NSTextAlignmentCenter;
    welcomeLabel.backgroundColor = [UIColor clearColor];
    welcomeLabel.shadowColor = [UIColor blackColor];
    welcomeLabel.shadowOffset = CGSizeMake(0, 1);
    [contentView addSubview:welcomeLabel];
    
    CGRect infoLabelRect = CGRectInset(contentView.bounds, 5, 5);
    infoLabelRect.origin.y = CGRectGetMaxY(welcomeLabelRect)+5;
    infoLabelRect.size.height -= CGRectGetMinY(infoLabelRect) + 50;
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:infoLabelRect];
    infoLabel.text = @"Terms of service will go here... ";
    infoLabel.numberOfLines = 6;
    infoLabel.textColor = [UIColor whiteColor];
    infoLabel.textAlignment = NSTextAlignmentCenter;
    infoLabel.backgroundColor = [UIColor clearColor];
    infoLabel.shadowColor = [UIColor blackColor];
    infoLabel.shadowOffset = CGSizeMake(0, 1);
    [contentView addSubview:infoLabel];
    
    CGFloat btnY = CGRectGetMaxY(infoLabelRect)+5;
    CGFloat btnH = CGRectGetMaxY(contentView.frame)-5 - btnY;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(infoLabelRect.origin.x, btnY, infoLabelRect.size.width, btnH);
    [contentView addSubview:btn];
    
    [[KGModal sharedInstance] showWithContentView:contentView andAnimated:YES];
}


- (void)checkPassword {
    if ([passwordTF.text isEqualToString:confirmTF.text]) {
        NSLog(@"Passwords match");
    } else {
        [RKDropdownAlert title:@"Password Error" message:@"Your passwords do not match. Try again." backgroundColor:[UIColor redColor] textColor:[UIColor whiteColor]];
    }
}

- (void)registerNewUser {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:emailTF.text forKey:@"email"];
    [userDefault setObject:passwordTF.text forKey:@"password"];
    [userDefault setBool:YES forKey:@"registered"];
    [userDefault synchronize];
}

@end

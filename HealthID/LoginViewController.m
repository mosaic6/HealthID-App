//
//  LoginViewController.m
//  HealthID
//
//  Created by Joshua Walsh on 5/12/15.
//  Copyright (c) 2015 Joshua Walsh. All rights reserved.
//

#import "LoginViewController.h"
#import "RKDropdownAlert.h"
#import "Constants.h"
@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize loginBtn,
            emailTF,
            passwordTF,
            tap,
            accountLabel,
            signupBtn;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationItem.title = @"healthid";
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.navigationItem.hidesBackButton = YES;
    
    loginBtn.layer.cornerRadius = 5;
    
    CALayer *border = [CALayer layer];
    CALayer *border2 = [CALayer layer];
    CGFloat borderWidth = 0.5f;
    border.borderColor = [UIColor darkGrayColor].CGColor;
    border2.borderColor = [UIColor darkGrayColor].CGColor;
    border.frame = CGRectMake(0, emailTF.frame.size.height - borderWidth, emailTF.frame.size.width, emailTF.frame.size.height);
    border2.frame = CGRectMake(0, passwordTF.frame.size.height - borderWidth, passwordTF.frame.size.width, passwordTF.frame.size.height);
    border.borderWidth = borderWidth;
    border2.borderWidth = borderWidth;
    [emailTF.layer addSublayer:border];
    [passwordTF.layer addSublayer:border2];
    emailTF.layer.masksToBounds = YES;
    passwordTF.layer.masksToBounds = YES;
    
    emailTF.delegate = self;
    passwordTF.delegate = self;
    
    tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults boolForKey:@"registered"]) {
        NSLog(@"No user registered");
    } else {
        NSLog(@"User registered: %@", [defaults objectForKey:@"email"]);
        accountLabel.hidden = YES;
        signupBtn.hidden = YES;
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
    return NO;
}

- (void)dismissKeyboard {
    [emailTF resignFirstResponder];
    [passwordTF resignFirstResponder];
}

- (IBAction)login:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //    NSString *email = [self.emailTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //    NSString *password = [self.passwordTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([emailTF.text isEqualToString:[defaults objectForKey:@"email"]] && [passwordTF.text isEqualToString:[defaults objectForKey:@"password"]]) {
        [self performSegueWithIdentifier:@"login" sender:self];
    } else {
        [RKDropdownAlert title:@"Login Error" message:@"Your username or password are incorrect" backgroundColor:[UIColor redColor] textColor:[UIColor whiteColor]];
    }
}

#pragma mark
#pragma mark - UITextField Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSInteger nextTag = textField.tag + 1;
    UIResponder *nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        [nextResponder becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return NO;
}




- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [textView resignFirstResponder];
    
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (void)keyboardWillShow {
    // Animate the current view out of the way
    if (self.view.frame.origin.y >= 0) {
        [self setViewMovedUp:YES];
    } else if (self.view.frame.origin.y < 0) {
        [self setViewMovedUp:NO];
    }
}

- (void)keyboardWillHide {
    if (self.view.frame.origin.y >= 0) {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0) {
        [self setViewMovedUp:NO];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)sender
{
    if ([sender isEqual:emailTF]) {
        //move the main view, so that the keyboard does not hide it.
        if  (self.view.frame.origin.y >= 0) {
            [self setViewMovedUp:YES];
        }
    }
}

//method to move the view up/down whenever the keyboard is shown/dismissed
- (void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp) {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    } else {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}



@end

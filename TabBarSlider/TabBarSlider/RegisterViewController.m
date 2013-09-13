//
//  RegisterViewController.m
//  TabBarSlider
//
//  Created by Jules Marcilhacy on 13/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import "RegisterViewController.h"
#import "AppDelegate.h"
#import "AuthAPIClient.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)FacebookLogin:(id)sender {
    
    [self.FBspinner startAnimating];
    [sender setTitleColor:[UIColor colorWithRed:78/255 green:90/255 blue:149/255 alpha:0.0] forState: UIControlStateNormal];
    
    NSLog(@"login with facebook");
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate openSession];
}

- (IBAction)EmailRegister:(id)sender {
    
    [self.usernameInput resignFirstResponder];
    [self.emailInput resignFirstResponder];
    [self.confirmEmailInput resignFirstResponder];
    [self.passwordInput resignFirstResponder];
    [self.spinner startAnimating];
    [sender setTitleColor:[UIColor colorWithRed:78/255 green:90/255 blue:149/255 alpha:0.0] forState: UIControlStateNormal];
    
    NSString *username = self.usernameInput.text;
    NSString *email = self.emailInput.text;
    NSString *confirmEmail = self.confirmEmailInput.text;
    NSString *password = self.passwordInput.text;
    
    if (username.length == 0){
        NSLog(@"Please choose a username");
        self.usernameInput.placeholder=@"Please choose a username";
        [self.spinner stopAnimating];
        [sender setTitleColor:[UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:1.0] forState: UIControlStateNormal];
    } else if (email.length == 0) {
        NSLog(@"Please choose a username");
        self.emailInput.placeholder=@"Please enter your email address";
        [self.spinner stopAnimating];
        [sender setTitleColor:[UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:1.0] forState: UIControlStateNormal];
    } else if (![email isEqualToString:confirmEmail]) {
        NSLog(@"Your emails do not match");
        self.confirmEmailInput.text=@"";
        self.confirmEmailInput.placeholder=@"Make sure your emails match!";
        [self.spinner stopAnimating];
        [sender setTitleColor:[UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:1.0] forState: UIControlStateNormal];
    } else if (password.length == 0) {
        NSLog(@"Please choose a password");
        self.passwordInput.placeholder=@"Please choose a password";
        [self.spinner stopAnimating];
        [sender setTitleColor:[UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:1.0] forState: UIControlStateNormal];
    } else if (![self NSStringIsValidEmail:email]) {
        self.emailInput.text=@"";
        self.confirmEmailInput.text=@"";
        self.emailInput.placeholder=@"Please enter a valid email address first";
        [self.spinner stopAnimating];
        [sender setTitleColor:[UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:1.0] forState: UIControlStateNormal];
    } else {
    
    NSLog(@"Register with email => username = %@, email = %@, confirmEmail = %@, password = %@", username, email, confirmEmail, password);
    
    [[AuthAPIClient sharedClient] postPath:[NSString stringWithFormat:@"app/register?&username=%@&email=%@&password=%@", username, email, password]
                               parameters:nil
                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      NSError * error = nil;
                                      NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
                                      
                                      NSLog(@"response: %@",response);
                                      NSString *authToken = [response objectForKey:@"access_token"];
                                      NSString *refreshToken = [response objectForKey:@"refresh_token"];
                                      CredentialStore *store = [[CredentialStore alloc] init];
                                      [store setAuthToken:authToken];
                                      [store setRefreshToken:refreshToken];
                                      
                                      NSLog(@"Register and login success with email from register view controller");
                                      [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccess" object:nil];
                                      
                                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      NSLog(@"error: %@", error.userInfo);
                                      self.errorLabel.text = error.userInfo[@"NSLocalizedRecoverySuggestion"];
                                      self.errorView.hidden=NO;
                                      self.errorLabel.hidden=NO;
                                      [self.spinner stopAnimating];
                                      [sender setTitleColor:[UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:1.0] forState: UIControlStateNormal];
                                  }];
    }    
}

- (IBAction)backToHP:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL) NSStringIsValidEmail:(NSString *)checkString {
    
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Text View Delegate

- (void) textFieldDidBeginEditing:(UITextField *)myTextField
{
    [self animateTextField:myTextField up:YES];
}

- (void) textFieldDidEndEditing:(UITextField *)myTextField
{
    [self animateTextField:myTextField up:NO];
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    int movement = (up ? -165 : 165);
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3f];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

@end

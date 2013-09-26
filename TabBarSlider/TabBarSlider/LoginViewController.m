//
//  LoginViewController.m
//  TabBarSlider
//
//  Created by Jules Marcilhacy on 09/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import "LoginViewController.h"
#import "AuthAPIClient.h"
#import "AFJSONRequestOperation.h"
#import "CredentialStore.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@interface LoginViewController ()

@end

@implementation LoginViewController

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
    [self.view endEditing:YES];// Do any additional setup after loading the view.
    
    self.errorView.backgroundColor=[UIColor colorWithRed:(243/255.0) green:(221/255.0) blue:(221/255.0) alpha:1];
    self.errorView.layer.borderColor = [UIColor colorWithRed:(237/255.0) green:(211/255.0) blue:(215/255.0) alpha:1].CGColor;
    self.errorView.layer.borderWidth = 1.0f;
    self.errorView.layer.cornerRadius = 5;
    self.errorView.layer.masksToBounds = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FacebookError) name:@"facebookError" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)FacebookError{
    [self.FBspinner stopAnimating];
    [self.FBButton setTitleColor:[UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:1] forState: UIControlStateNormal];
}

- (IBAction)EmailLogin:(id)sender {
    
    [self.spinner startAnimating];
    [self textFieldShouldReturn:self.passwordInput];
    [sender setTitleColor:[UIColor colorWithRed:(78.0/255) green:(90.0/255) blue:(149.0/255) alpha:0.0] forState: UIControlStateNormal];
    
    NSString *username = self.usernameInput.text;
    NSString *password = self.passwordInput.text;
    
    NSLog(@"login with email => username = %@, password = %@", username, password);
    
    [[AuthAPIClient sharedClient] getPath:[NSString stringWithFormat:@"oauth/v2/token?client_id=9_2yfw4otqwgo4w4wc488gggsg4c0gk4gco8g00c48ggkwowk44w&client_secret=4miogk8bd56oo444kkk0gk4os4o0wwkks4osksws4o8k8wkw0c&grant_type=password&username=%@&password=%@", username, password]
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
                                      
                                      NSLog(@"login success with email from login view controller");
                                      [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccess" object:nil];
                                      
                                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      NSLog(@"error: %@", error);
                                      NSString *errorMessage = error.userInfo[@"NSLocalizedRecoverySuggestion"];
                                      
                                      if ([errorMessage isEqualToString:@"{\"error\":\"invalid_grant\"}"]) {
                                          self.errorLabel.text = @"Invalid credentials";
                                      } else {
                                          self.errorLabel.text = @"Impossible to connect to the server";
                                      }
                                      self.firstErrorLabel.hidden = NO;
                                      self.errorView.hidden = NO;
                                      self.errorLabel.hidden = NO;
                                      [self.spinner stopAnimating];
                                      [sender setTitleColor:[UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:1.0] forState: UIControlStateNormal];                                      
                                  }];
}

- (IBAction)FacebookLogin:(id)sender {
    
    [self.FBspinner startAnimating];
    [sender setTitleColor:[UIColor colorWithRed:255/255 green:255/255 blue:149/255 alpha:0.0] forState: UIControlStateNormal];
    
    NSLog(@"login with facebook");
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate openSession];
}

- (IBAction)backToHP:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
    int movement = (up ? -133 : 133);
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3f];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}
@end

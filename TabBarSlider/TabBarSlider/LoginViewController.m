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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
                                      
                                      [self dismissViewControllerAnimated:YES completion:nil];
                                      
                                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      NSLog(@"error: %@", error);
                                  }];
}

- (IBAction)FacebookLogin:(id)sender {
    
    [self.FBspinner startAnimating];
    
    [sender setTitleColor:[UIColor colorWithRed:78/255 green:90/255 blue:149/255 alpha:0.0] forState: UIControlStateNormal];
    NSLog(@"login with facebook");
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate openSession];
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

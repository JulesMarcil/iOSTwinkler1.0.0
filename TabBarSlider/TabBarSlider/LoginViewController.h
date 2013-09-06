//
//  LoginViewController.h
//  TabBarSlider
//
//  Created by Jules Marcilhacy on 09/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController  <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UITextField *usernameInput;
@property (weak, nonatomic) IBOutlet UITextField *passwordInput;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *FBspinner;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)EmailLogin:(id)sender;
- (IBAction)FacebookLogin:(id)sender;
- (IBAction)backToHP:(id)sender;

@end

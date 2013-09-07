//
//  AddListViewController.m
//  Twinkler
//
//  Created by Arnaud Drizard on 07/09/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import "AddListViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface AddListViewController ()

@end

@implementation AddListViewController

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
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    UIColor *borderColor = [UIColor colorWithRed:(200/255.0) green:(200/255.0) blue:(200/255.0) alpha:1] ;
    UIColor *textColor = [UIColor colorWithRed:(65/255.0) green:(65/255.0) blue:(65/255.0) alpha:1] ;
    
    [self.doneButton setTitleColor: textColor forState: UIControlStateNormal];
    [self.doneButton.layer  setBorderColor:borderColor.CGColor];
    [self.doneButton.layer  setBorderWidth:1.0];
    
    [self.cancelButton setTitleColor: textColor forState: UIControlStateNormal];
    [self.cancelButton.layer  setBorderColor:borderColor.CGColor];
    [self.cancelButton.layer  setBorderWidth:1.0];
    
    self.groupNameContainer.backgroundColor=[UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:0.8];
    self.groupNameContainer.layer.borderColor = [UIColor colorWithRed:(205/255.0) green:(205/255.0) blue:(205/255.0) alpha:1].CGColor;
    self.groupNameContainer.layer.borderWidth = 1.0f;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (IBAction)dismissView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end

//
//  ExpenseDetailViewController.m
//  TabBarSlider
//
//  Created by Arnaud Drizard on 05/09/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import "ExpenseDetailViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ExpenseDetailViewController ()

@end

@implementation ExpenseDetailViewController

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
    
    CGRect frame= [self.actionBarView frame];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    [self.actionBarView setFrame:CGRectMake(frame.origin.x,
                                                 screenRect.size.height-frame.size.height-50,
                                                 frame.size.width,
                                                 frame.size.height)];
    
    frame= [self.expenseAuthorLabel frame];
    [self.expenseAuthorLabel setFrame:CGRectMake(frame.origin.x,
                                            screenRect.size.height-frame.size.height-25,
                                            frame.size.width,
                                            frame.size.height)];
    
    frame= [self.memberTableView frame];
    [self.memberTableView setFrame:CGRectMake(frame.origin.x,
                                                 frame.size.height,
                                                 frame.size.width,
                                              176)];
    
    UIColor *borderColor = [UIColor colorWithRed:(200/255.0) green:(200/255.0) blue:(200/255.0) alpha:1] ;
    UIColor *textColor = [UIColor colorWithRed:(65/255.0) green:(65/255.0) blue:(65/255.0) alpha:1] ;
    
    [self.editBtn setTitleColor: textColor forState: UIControlStateNormal];
    [self.editBtn.layer  setBorderColor:borderColor.CGColor];
    [self.editBtn.layer  setBorderWidth:1.0];
    
    [self.dismissBtn setTitleColor: textColor forState: UIControlStateNormal];
    [self.dismissBtn.layer  setBorderColor:borderColor.CGColor];
    [self.dismissBtn.layer  setBorderWidth:1.0];
    
    self.memberTableView.backgroundColor=[UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:0.8];
    self.memberTableView.layer.borderColor = [UIColor colorWithRed:(205/255.0) green:(205/255.0) blue:(205/255.0) alpha:1].CGColor;
    self.memberTableView.layer.borderWidth = 1.0f;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)editExpense:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)dismissDetail:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end

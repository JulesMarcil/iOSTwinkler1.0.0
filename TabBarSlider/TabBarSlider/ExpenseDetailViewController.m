//
//  ExpenseDetailViewController.m
//  TabBarSlider
//
//  Created by Arnaud Drizard on 06/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import "ExpenseDetailViewController.h"

@interface ExpenseDetailViewController ()

@end

@implementation ExpenseDetailViewController
@synthesize expenseDetailMemberTable=_expenseDetailMemberTable;

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

- (IBAction)backToExpenseList:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end

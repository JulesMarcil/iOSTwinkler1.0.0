//
//  AddGroupViewController.m
//  TabBarSlider
//
//  Created by Arnaud Drizard on 05/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import "AddGroupViewController.h"
#import "Group.h"

@interface AddGroupViewController ()

@end

@implementation AddGroupViewController

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
    
    NSDictionary *Euro = [[NSDictionary alloc] initWithObjectsAndKeys:@"Euro", @"name", @"€", @"Symbol", @1, @"id", nil];
    NSDictionary *USDollar = [[NSDictionary alloc] initWithObjectsAndKeys:@"US Dollar", @"name", @"$", @"Symbol", @2, @"id", nil];
    NSDictionary *BritishPound = [[NSDictionary alloc] initWithObjectsAndKeys:@"BritishPound", @"name", @"£", @"Symbol", @3, @"id", nil];
    NSDictionary *IndianRupee = [[NSDictionary alloc] initWithObjectsAndKeys:@"Indian Rupee", @"name", @"Rs", @"Symbol", @4, @"id", nil];
    NSDictionary *AustralianDollar = [[NSDictionary alloc] initWithObjectsAndKeys:@"Australian Dollar", @"name", @"AU$", @"Symbol", @5, @"id", nil];
    NSDictionary *CanadianDollar = [[NSDictionary alloc] initWithObjectsAndKeys:@"Canadian Dollar", @"name", @"CA$", @"Symbol", @6, @"id", nil];
    NSDictionary *SwissFranc = [[NSDictionary alloc] initWithObjectsAndKeys:@"Swiss Franc", @"name", @"CHF", @"Symbol", @7, @"id", nil];
    NSDictionary *ChineseYuanRenminbi = [[NSDictionary alloc] initWithObjectsAndKeys:@"Chinese Yuan Renminbi", @"name", @"CN¥", @"Symbol", @8, @"id", nil];
    NSDictionary *JapaneseYen = [[NSDictionary alloc] initWithObjectsAndKeys:@"Japanese Yen", @"name", @"¥", @"Symbol", @9, @"id", nil];
    NSDictionary *ColombianPeso = [[NSDictionary alloc] initWithObjectsAndKeys:@"Colombian Peso", @"name", @"$", @"Symbol", @10, @"id", nil];
    NSDictionary *BrazilianReal = [[NSDictionary alloc] initWithObjectsAndKeys:@"Brazilian Real", @"name", @"R$", @"Symbol", @11, @"id", nil];
    
    NSArray *currencies = [[NSArray alloc] initWithObjects:Euro,USDollar,BritishPound,IndianRupee,AustralianDollar,CanadianDollar,SwissFranc,ChineseYuanRenminbi,JapaneseYen,ColombianPeso,BrazilianReal, nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ReturnInput"]) {
        if ([self.groupName.text length]) {
            
            Group *group = [[Group alloc] initWithName:self.groupName.text
                                            identifier:nil
                                               members:nil
                                          activeMember:nil
                                              currency:self.selectedCurrency[@"id"]];
            self.group = group;
        }
    }
}

@end

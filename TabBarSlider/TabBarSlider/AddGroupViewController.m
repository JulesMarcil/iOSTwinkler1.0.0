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
    
    currencies = [[NSArray alloc] initWithObjects:Euro,USDollar,BritishPound,IndianRupee,AustralianDollar,CanadianDollar,SwissFranc,ChineseYuanRenminbi,JapaneseYen,ColombianPeso,BrazilianReal, nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//----Currency Picker--------//
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    //One column
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    //set number of rows
    return currencies.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    //set item per row
    return [currencies objectAtIndex:row][@"name"];
}

-(void)closePicker:(id)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        self.currencyPicker.frame = CGRectMake(self.currencyPicker.frame.origin.x,
                                                    500, //Displays the view off the screen
                                                    self.currencyPicker.frame.size.width,
                                                    self.currencyPicker.frame.size.height);
    }];
}


- (void)dismissCurrencyPicker:(id)sender {
    CGRect toolbarTargetFrame = CGRectMake(0, self.view.bounds.size.height, 320, 44);
    CGRect datePickerTargetFrame = CGRectMake(0, self.currencyPicker.bounds.size.height+44, 320, 216);
    [UIView beginAnimations:@"MoveOut" context:nil];
    [self.view viewWithTag:9].alpha = 0;
    [self.view viewWithTag:10].frame = datePickerTargetFrame;
    [self.view viewWithTag:11].frame = toolbarTargetFrame;
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(removeViews:)];
    [UIView commitAnimations];
    [self closePicker:nil];
}



- (IBAction)showPicker:(id)sender {
    if ([self.view viewWithTag:9]) {
        return;
    }
    
    CGRect toolbarTargetFrame = CGRectMake(0, self.view.bounds.size.height-216-44, 320, 44);
    CGRect datePickerTargetFrame = CGRectMake(0, self.view.bounds.size.height-216, 320, 216);
    
    UIView *darkView = [[UIView alloc] initWithFrame:self.view.bounds];
    darkView.alpha = 0;
    darkView.backgroundColor = [UIColor blackColor];
    darkView.tag = 9;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissMemberPicker:)] ;
    [darkView addGestureRecognizer:tapGesture];
    [self.view addSubview:darkView];
    [self.view addSubview:self.currencyPicker];
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, 320, 44)] ;
    toolBar.tag = 11;
    toolBar.barStyle = UIBarStyleBlackTranslucent;
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissCurrencyPicker:)];
    [toolBar setItems:[NSArray arrayWithObjects:spacer, doneButton, nil]];
    [self.view addSubview:toolBar];
    
    [UIView beginAnimations:@"MoveIn" context:nil];
    toolBar.frame = toolbarTargetFrame;
    self.currencyPicker.frame = datePickerTargetFrame;
    darkView.alpha = 0.5;
    [UIView commitAnimations];
    
    //Set selected owner to the first one in the list (to be updated with current member)
    self.selectedCurrency = [currencies objectAtIndex:0];
    self.currentCurrency.text=self.selectedCurrency[@"name"];
    [self.currencyPicker reloadAllComponents];
    [self.currencyPicker selectRow:0 inComponent:0 animated:YES];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.selectedCurrency = [currencies objectAtIndex:row];
    self.currentCurrency.text=self.selectedCurrency[@"name"];
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

//
//  TabBarViewController.m
//  TabBarSlider
//
//  Created by Arnaud Drizard on 01/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import "TabBarViewController.h"
#import "CustomTabBarSegue.h"
#import "AddExpenseViewController.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController

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
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    CGRect frame= [self.coverPic frame];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    [self.coverPic setFrame:CGRectMake(0,
                                                0,
                                                frame.size.width,
                                                frame.size.height)];
    frame= [self.topWhiteBar frame];
    [self.topWhiteBar setFrame:CGRectMake(0,
                                       0,
                                       frame.size.width,
                                       frame.size.height)];
    frame= [self.placeholderView frame];
    [self.placeholderView setFrame:CGRectMake(0,
                                          144,
                                          frame.size.width,
                                          screenHeight - 100)];
    frame= [self.toolbar frame];
    [self.toolbar setFrame:CGRectMake(0,
                                              100,
                                              frame.size.width,
                                              44)];
    
    
    TabBarViewController *src= self.navigationController.visibleViewController;
    UIViewController *dst =[self.storyboard instantiateViewControllerWithIdentifier:@"timelineTab"];
    src.currentViewController =dst;
    [src.placeholderView addSubview:dst.view];
    
    [src addChildViewController:dst];
    [self.timelineButton setSelected:YES];
    
    [self.expenseButton addTarget:self action:@selector(expenseButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.timelineButton addTarget:self action:@selector(timelineButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.listButton addTarget:self action:@selector(listButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.revealButtonItem addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{

}
- (void)expenseButtonPressed:(UIButton *)sender {
    CGPoint pt = {31,0};
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.1];
    //you can change the setAnimationDuration value, it is in seconds.
    
    CGRect rect = CGRectMake(pt.x, pt.y, self.activeTabBarImage.frame.size.height, self.activeTabBarImage.frame.size.width);
    
    [self.activeTabBarImage setFrame:rect];
    [sender setSelected:YES];
    [self.timelineButton setSelected:NO];
    [self.listButton setSelected:NO];
    
    [UIView commitAnimations];
    [self performSegueWithIdentifier: @"expenseSegue" sender: self];
}
- (void)timelineButtonPressed:(UIButton *)sender {
    CGPoint pt = {138,0};
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.1];
    //you can change the setAnimationDuration value, it is in seconds.
    
    CGRect rect = CGRectMake(pt.x, pt.y, self.activeTabBarImage.frame.size.height, self.activeTabBarImage.frame.size.width);
    
    [self.activeTabBarImage setFrame:rect];
    [sender setSelected:YES];
    [self.listButton setSelected:NO];
    [self.expenseButton setSelected:NO];
    
    [UIView commitAnimations];
    [self performSegueWithIdentifier: @"timelineSegue" sender: self];
}
- (void)listButtonPressed:(UIButton *)sender {
    CGPoint pt = {244,0};
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.1];
    //you can change the setAnimationDuration value, it is in seconds.
    
    CGRect rect = CGRectMake(pt.x, pt.y, self.activeTabBarImage.frame.size.height, self.activeTabBarImage.frame.size.width);
    
    [self.activeTabBarImage setFrame:rect];
    [sender setSelected:YES];
    [self.timelineButton setSelected:NO];
    [self.expenseButton setSelected:NO];
    
    [UIView commitAnimations];
    [self performSegueWithIdentifier: @"listSegue" sender: self];
}



@end

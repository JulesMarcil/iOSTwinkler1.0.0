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
#import "SWRevealViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "memberCollectionViewCell.h"
#import "ExpenseViewController.h"

@interface TabBarViewController ()

- (void)scrollViewDidScroll:(UIScrollView *)sender;

@end

@implementation TabBarViewController

@synthesize scrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"tabbarvc viewdidload navcontrollers count = %u", self.navigationController.navigationController.viewControllers.count);
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    self.memberArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentGroupMembers"];
    self.groupTitle.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentGroupName"];
    
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    
    [self.mainView setFrame:screenRect];
    
    CGRect frame= [self.topWhiteBar frame];
    [self.topWhiteBar setFrame:CGRectMake(0,
                                          0,
                                          frame.size.width,
                                          frame.size.height)];
    frame= [self.placeholderView frame];
    [self.placeholderView setFrame:CGRectMake(0,
                                              0,
                                              frame.size.width,
                                              screenHeight+20)];
    frame= [self.toolbar frame];
    [self.toolbar setFrame:CGRectMake(0,
                                      0,
                                      frame.size.width,
                                      100)];
    self.toolbar.backgroundColor=[UIColor colorWithRed:(236/255.0) green:(162/255.0) blue:(150/255.0) alpha:0.95];
    
    
    self.tabBarBck.layer.cornerRadius = 2;
    self.tabBarBck.layer.masksToBounds = YES;
    self.activeTabBarImage.layer.cornerRadius = 2;
    self.activeTabBarImage.layer.masksToBounds = YES;
    
    
    [self.timelineButton setSelected:YES];
    
    [self.expenseButton addTarget:self action:@selector(expenseButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.expenseButton addTarget:self action:@selector(goToExpenses) forControlEvents:UIControlEventTouchUpInside];
    [self.timelineButton addTarget:self action:@selector(goToTimeline) forControlEvents:UIControlEventTouchUpInside];
    [self.timelineButton addTarget:self action:@selector(timelineButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.listButton addTarget:self action:@selector(listButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.listButton addTarget:self action:@selector(goToList) forControlEvents:UIControlEventTouchUpInside];
    
    [self.revealButtonItem addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [self.leftButton addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [self.leftButton addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    [self.revealButtonItem addTarget:self action:@selector(hideLeftToggle) forControlEvents:UIControlEventTouchUpInside];
    [self.leftButton addTarget:self action:@selector(hideLeftToggle) forControlEvents:UIControlEventTouchUpInside];
    
    [self.revealViewController.panGestureRecognizer addTarget:self action:@selector(GestureEnded:)];
    
    
    //-----ScrollView------//
    frame= [self.scrollView frame];
    [self.scrollView setFrame:CGRectMake(0,
                                         0,
                                         320,
                                         screenHeight+20)];
    
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(960, self.scrollView.frame.size.height);
    self.scrollView.backgroundColor=[UIColor colorWithRed:(245/255.0) green:(245/255.0) blue:(245/255.0) alpha:1];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.scrollsToTop = NO;
    self.scrollView.delegate = self;
    
    self.pageControl.numberOfPages=3;
    self.pageControl.currentPage=1;
    
    self.view.autoresizesSubviews=NO;
    
    //TIMELINE
    UIStoryboard *timelineStoryboard = [UIStoryboard storyboardWithName:@"timelineStoryboard" bundle:nil];
    TabBarViewController *middleVC = [timelineStoryboard instantiateInitialViewController];
    
    UIView *timelineView = middleVC.view;
    [timelineView setFrame:CGRectMake(320,
                                       20,
                                       320,
                                       screenHeight+20)];
    
    [self.scrollView addSubview:timelineView];
    [self addChildViewController:middleVC];

    
    //EXPENSE
     UIStoryboard *expenseStoryboard = [UIStoryboard storyboardWithName:@"expenseStoryboard" bundle:nil];
     ExpenseViewController *leftVC = [expenseStoryboard instantiateInitialViewController];
     
     UIView *expenseView = leftVC.view;
     [expenseView setFrame:CGRectMake(0,
                                      20,
                                      320,
                                      screenHeight+20)];
     
     [self.scrollView addSubview:expenseView];
     [self addChildViewController:leftVC];
    
    //DASHBOARD
    UIStoryboard *dashboardStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    TabBarViewController  *rightVC = [dashboardStoryboard instantiateViewControllerWithIdentifier:@"dashboardVC"];
    
    UIView *dashboardView = rightVC.view;
    [dashboardView setFrame:CGRectMake(640,
                                       20,
                                       320,
                                       screenHeight)];
    
    [self.scrollView addSubview:dashboardView];
    [self addChildViewController:rightVC];
    
    [self.scrollView setContentOffset:CGPointMake(320, 0) animated:NO];
    
    
}

-(void)GestureEnded:(UIPanGestureRecognizer *)gesture{
    if (gesture.state==UIGestureRecognizerStateEnded) {
        [self hideLeftToggle];
    }
}

-(void)hideLeftToggle{
    if(self.revealViewController.frontViewPosition==4){
        self.leftButton.hidden=NO;
        NSLog(@"RevealView %i",self.revealViewController.frontViewPosition);
    }else {
        self.leftButton.hidden=YES;
        NSLog(@"RevealView %i",self.revealViewController.frontViewPosition);
    };
}

-(void)hideRightToggle{
    if(self.rightButton.hidden==YES){
        self.rightButton.hidden=NO;
        NSLog(@"RevealView %i",self.revealViewController.frontViewPosition);
    } else {
        self.rightButton.hidden=YES;
        NSLog(@"RevealView %i",self.revealViewController.frontViewPosition);
    };
}

-(void)addRevealToggle{
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)scrollViewDidScroll:(UIScrollView *)sender {
    
    CGFloat pageWidth = 320;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
    
    if (page==0){
        
        CGPoint pt = expenseCGPoint;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.1];
        //you can change the setAnimationDuration value, it is in seconds.
        
        CGRect rect = CGRectMake(pt.x, pt.y, self.activeTabBarImage.frame.size.width,self.activeTabBarImage.frame.size.height);
        
        [self.activeTabBarImage setFrame:rect];
        [self.expenseButton setSelected:YES];
        [self.timelineButton setSelected:NO];
        [self.listButton setSelected:NO];
        
        [UIView commitAnimations];
    }
    else if(page==1){
        CGPoint pt = timelineCGPoint;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.1];
        //you can change the setAnimationDuration value, it is in seconds.
        
        CGRect rect = CGRectMake(pt.x, pt.y, self.activeTabBarImage.frame.size.width,self.activeTabBarImage.frame.size.height);
        
        [self.activeTabBarImage setFrame:rect];
        [self.expenseButton setSelected:NO];
        [self.timelineButton setSelected:YES];
        [self.listButton setSelected:NO];
        
        [UIView commitAnimations];
    }else{
        CGPoint pt = listCGPoint;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.1];
        //you can change the setAnimationDuration value, it is in seconds.
        
        CGRect rect = CGRectMake(pt.x, pt.y, self.activeTabBarImage.frame.size.width,self.activeTabBarImage.frame.size.height);
        
        [self.activeTabBarImage setFrame:rect];
        [self.expenseButton setSelected:NO];
        [self.timelineButton setSelected:NO];
        [self.listButton setSelected:YES];
        
        [UIView commitAnimations];
    }
    
}

- (void)expenseButtonPressed:(UIButton *)sender {
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
}
- (void)timelineButtonPressed:(UIButton *)sender {
    [self.scrollView setContentOffset:CGPointMake(320, 0) animated:YES];
}
- (void)listButtonPressed:(UIButton *)sender {
    [self.scrollView setContentOffset:CGPointMake(640, 0) animated:YES];
}

-(void)goToExpenses{
}

-(void)goToTimeline{
}

-(void)goToList{
}

//--------DESGIN---------
-(void) setRoundedView:(UIImageView *)imageView picture: (UIImage *)picture toDiameter:(float)newSize{
    // Begin a new image that will be the new image with the rounded corners
    // (here with the size of an UIImageView)
    UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, NO, 1.0);
    
    // Add a clip before drawing anything, in the shape of an rounded rect
    [[UIBezierPath bezierPathWithRoundedRect:imageView.bounds
                                cornerRadius:100.0] addClip];
    // Draw your image
    CGRect frame=imageView.bounds;
    frame.size.width=newSize;
    frame.size.height=newSize;
    [picture drawInRect:frame];
    
    // Get the image, here setting the UIImageView image
    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    
    // Lets forget about that we were drawing
    UIGraphicsEndImageContext();
}


@end

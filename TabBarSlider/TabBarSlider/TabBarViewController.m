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
#import "DRNRealTimeBlurView.h"
#import <QuartzCore/QuartzCore.h>
#import "memberCollectionViewCell.h"

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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    self.memberArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentGroupMembers"];
    self.groupTitle.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentGroupName"];
    
    
    CGRect frame= [self.coverPic frame];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    
    [self.mainView setFrame:screenRect];
    
    [self.coverPic setFrame:CGRectMake(0,
                                       0,
                                       frame.size.width,
                                       100)];
    frame= [self.topWhiteBar frame];
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
    [self.rightButton addTarget:self.revealViewController action:@selector(rightRevealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [self.revealButtonItem addTarget:self action:@selector(hideLeftToggle) forControlEvents:UIControlEventTouchUpInside];
    [self.revealRightButtonItem addTarget:self action:@selector(hideRightToggle) forControlEvents:UIControlEventTouchUpInside];
    [self.leftButton addTarget:self action:@selector(hideLeftToggle) forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton addTarget:self action:@selector(hideRightToggle) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    NSLog(@"The value of integer num is %i", (int) self.revealViewController.frontViewController.view.frame.origin.x);
    
    [self.revealRightButtonItem addTarget:self.revealViewController action:@selector(rightRevealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    //-----ScrollView------//
    frame= [self.scrollView frame];
    [self.scrollView setFrame:CGRectMake(0,
                                         0,
                                         frame.size.width,
                                         screenHeight+20)];
    
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * 3, self.scrollView.frame.size.height);
    self.scrollView.backgroundColor=[UIColor colorWithRed:(245/255.0) green:(245/255.0) blue:(245/255.0) alpha:1];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.scrollsToTop = NO;
    self.scrollView.delegate = self;
    
    self.pageControl.numberOfPages=3;
    self.pageControl.currentPage=1;
    
    UIStoryboard *timelineStoryboard=[UIStoryboard storyboardWithName:@"timelineStoryboard" bundle:nil];
    TabBarViewController *dst=[timelineStoryboard instantiateInitialViewController];
    self.currentViewController =dst;
    [dst.view setFrame:CGRectMake(320, 20, dst.view.frame.size.width, dst.view.frame.size.height)];
    
    dst.view.layer.borderWidth = 1.0f;
    dst.view.layer.borderColor = [UIColor colorWithRed:(205/255.0) green:(205/255.0) blue:(205/255.0) alpha:1].CGColor;
    [self.scrollView addSubview:dst.view];
    
    [self addChildViewController:dst];
    
    UIStoryboard *expenseStoryboard=[UIStoryboard storyboardWithName:@"expenseStoryboard" bundle:nil];
    TabBarViewController *leftVC=[expenseStoryboard instantiateInitialViewController];
    self.leftViewController =leftVC;
    [leftVC.view setFrame:CGRectMake(0, 20, leftVC.view.frame.size.width, leftVC.view.frame.size.height)];
    
    [self.scrollView addSubview:leftVC.view];
    
    [self addChildViewController:leftVC];
    
    
    UIStoryboard *listStoryboard=[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    TabBarViewController *rightVC=[listStoryboard instantiateViewControllerWithIdentifier:@"dashboardVC"];
    self.leftViewController =rightVC;
    [rightVC.view setFrame:CGRectMake(640, 20, rightVC.view.frame.size.width, rightVC.view.frame.size.height)];
    
    [self.scrollView addSubview:rightVC.view];
    
    [self addChildViewController:rightVC];
    
    [self.scrollView setContentOffset:CGPointMake(320, 0) animated:NO];
}

-(void)hideLeftToggle{
    if(self.leftButton.hidden==YES){
        self.leftButton.hidden=NO;
    }else {
        self.leftButton.hidden=YES;
    };
}

-(void)hideRightToggle{
    if(self.rightButton.hidden==YES){
        self.rightButton.hidden=NO;
    } else {
        self.rightButton.hidden=YES;
    };
}

-(void)addRevealToggle{
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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

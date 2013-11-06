//
//  WalkthroughViewController.m
//  Twinkler
//
//  Created by Arnaud Drizard on 14/09/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import "WalkthroughViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "customPageControl.h"
#import "AppDelegate.h"
#import "GAITrackedViewController.h"

@interface WalkthroughViewController ()

@end

@implementation WalkthroughViewController

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
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    self.screenName = @"Walkthrough";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(facebookError) name:@"facebookError"  object:nil];
    
    self.spinnerContainer.hidden=YES;
    [self.spinner stopAnimating];
    
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * 6, self.scrollView.frame.size.height);
    self.scrollView.backgroundColor=[UIColor colorWithRed:(245/255.0) green:(245/255.0) blue:(245/255.0) alpha:1];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.scrollsToTop = NO;
    self.scrollView.delegate = self;
    
    self.pageControl.numberOfPages = 6;
    self.pageControl.currentPage = 0;
    
    self.scrollView.backgroundColor=[UIColor clearColor];
    self.firstView.backgroundColor=[UIColor clearColor];
    self.secondView.backgroundColor=[UIColor clearColor];
    self.thirdView.backgroundColor=[UIColor clearColor];
    self.fourthView.backgroundColor=[UIColor clearColor];
    self.fifthView.backgroundColor=[UIColor clearColor];
    self.sixthView.backgroundColor=[UIColor clearColor];
    
    self.spinnerContainer.layer.cornerRadius = 5;
    
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    if (screenRect.size.height<560) {
        
        UIImageView *subview = [[UIImageView alloc] initWithFrame:CGRectMake(0, -90, 320, 568)];
        [subview setImage:[UIImage imageNamed:@"create-group.png"]];
        [self.secondView addSubview:subview];
        
        UIImageView *subviewInvite = [[UIImageView alloc] initWithFrame:CGRectMake(0, -90, 320, 568)];
        [subviewInvite setImage:[UIImage imageNamed:@"invite.png"]];
        [self.thirdView addSubview:subviewInvite];
        
        
        UIImageView *subviewExpense = [[UIImageView alloc] initWithFrame:CGRectMake(0, -90, 320, 568)];
        [subviewExpense setImage:[UIImage imageNamed:@"track-expenses.png"]];
        [self.fourthView addSubview:subviewExpense];
        
        UIImageView *subviewPayback = [[UIImageView alloc] initWithFrame:CGRectMake(0, -90, 320, 568)];
        [subviewPayback setImage:[UIImage imageNamed:@"payback.png"]];
        [self.fifthView addSubview:subviewPayback];
        
        CGRect frame= [self.devicesContainer frame];
        [self.devicesContainer setFrame:CGRectMake(frame.origin.x,
                                              30,
                                              frame.size.width,
                                              frame.size.height)];
        self.twinklerLogo.hidden=YES;
    }else{
    
    UIImageView *subview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
    [subview setImage:[UIImage imageNamed:@"create-group.png"]];
    [self.secondView addSubview:subview];
    
    UIImageView *subviewInvite = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
    [subviewInvite setImage:[UIImage imageNamed:@"invite.png"]];
    [self.thirdView addSubview:subviewInvite];
    
    
    UIImageView *subviewExpense = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
    [subviewExpense setImage:[UIImage imageNamed:@"track-expenses.png"]];
    [self.fourthView addSubview:subviewExpense];
    
    UIImageView *subviewPayback = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
    [subviewPayback setImage:[UIImage imageNamed:@"payback.png"]];
    [self.fifthView addSubview:subviewPayback];
    }
    
    CGRect frame= [self.pageControl frame];
    [self.pageControl setFrame:CGRectMake(frame.origin.x,
                                                 screenRect.size.height-frame.size.height-90,
                                                 frame.size.width,
                                                 frame.size.height)];
    
    frame= [self.dismissButton frame];
    [self.dismissButton setFrame:CGRectMake(frame.origin.x,
                                          screenRect.size.height-frame.size.height-30,
                                          frame.size.width,
                                          frame.size.height)];
    
    
    frame= [self.connectWithFbButton frame];
    [self.connectWithFbButton setFrame:CGRectMake(frame.origin.x,
                                            screenRect.size.height-frame.size.height-40,
                                            frame.size.width,
                                            frame.size.height)];
    
    
    CGFloat screenHeight = screenRect.size.height;
    
    frame= [self.signinButton frame];
    [self.signinButton setFrame:CGRectMake(frame.origin.x,
                                           screenHeight-frame.size.height+5,
                                           frame.size.width,
                                           frame.size.height)];
    
    self.dismissButton.layer.masksToBounds = YES;
    self.dismissButton.layer.borderColor = [UIColor colorWithRed:(205/255.0) green:(205/255.0) blue:(205/255.0) alpha:1].CGColor;
    self.dismissButton.layer.borderWidth = 1.0f;
    
    
    self.catchphraseHeaderLabel.textColor=[UIColor colorWithRed:(234/255.0) green:(74/255.0) blue:(77/255.0) alpha:1];
    self.catchphraseSubLabel.textColor=[UIColor colorWithRed:(173/255.0) green:(173/255.0) blue:(173/255.0) alpha:1];
    
    [self.catchphraseHeaderLabel setFrame:CGRectMake(0,420,320,30)];
    [self.catchphraseSubLabel setFrame:CGRectMake(0,460,320,30)];
    
    if ([self.pageControl respondsToSelector:@selector(setPageIndicatorTintColor:)]) {
        self.pageControl.pageIndicatorTintColor = [UIColor colorWithRed:(249/255.0) green:(252/255.0) blue:(230/255.0) alpha:1];
    }
    
    frame= [self.whyFBLogin frame];
    [self.whyFBLogin setFrame:CGRectMake(frame.origin.x,
                                         screenHeight+10,
                                         frame.size.width,
                                         frame.size.height)];
    
    frame= [self.seeWhyContainer frame];
    [self.seeWhyContainer setFrame:CGRectMake(frame.origin.x,
                                              screenHeight-frame.size.height+5,
                                              frame.size.width,
                                              frame.size.height-15)];
    
    frame= [self.oldSigninButton frame];
    [self.oldSigninButton setFrame:CGRectMake(frame.origin.x,
                                           screenHeight-frame.size.height-10,
                                           frame.size.width,
                                           frame.size.height)];
    
    frame= [self.alreadyRegisteredLabel frame];
    [self.alreadyRegisteredLabel setFrame:CGRectMake(frame.origin.x,
                                              screenHeight-frame.size.height-45,
                                              frame.size.width,
                                              frame.size.height)];
    
    self.whyLabelContainer.layer.cornerRadius=5;
    self.whyLabelContainer.layer.masksToBounds = YES;
    self.whyLabelContainer.layer.borderColor = [UIColor colorWithRed:(205/255.0) green:(205/255.0) blue:(205/255.0) alpha:1].CGColor;
    self.whyLabelContainer.layer.borderWidth = 1.0f;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.screenName = @"Walkthrough";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    [self.pageControl setCurrentPage:page];
    switch (page) {
        case 0:
            self.dismissButton.titleLabel.text=@"Get Started!";
            break;
            
        case 5:
            self.dismissButton.hidden=YES;
            break;
            
            
        default:
            self.dismissButton.titleLabel.text=@"Next";
            self.dismissButton.titleLabel.textAlignment=NSTextAlignmentCenter;
            self.dismissButton.hidden=NO;
            break;
    }
    
    self.pageControl.currentPage = page;
}

- (IBAction)dismissView:(id)sender {
    if (self.pageControl.currentPage<5)
    [self.scrollView setContentOffset:CGPointMake(320*(self.pageControl.currentPage+1), 0) animated:YES];
}

- (IBAction)facebookConnect:(id)sender {
    self.spinnerContainer.hidden=NO;
    [self.spinner startAnimating];
    [self.connectWithFbButton setEnabled:NO];
    
    NSLog(@"login with facebook");
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate openSession];
    
}

- (IBAction)dismissFBView:(id)sender {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.5f];
    CGRect frame= [self.whyFBLogin frame];
    [self.whyFBLogin setFrame:CGRectMake(frame.origin.x,
                                         screenHeight+10,
                                         frame.size.width,
                                         frame.size.height)];
    [UIView commitAnimations];
    self.pageControl.hidden=NO;
}

- (IBAction)whyFBShow:(id)sender {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.5f];
    CGRect frame= [self.whyFBLogin frame];
    [self.whyFBLogin setFrame:CGRectMake(frame.origin.x,
                                         0,
                                         frame.size.width,
                                         frame.size.height)];
    [UIView commitAnimations];
    self.pageControl.hidden=YES;
}

- (void) facebookError {
    
    self.spinnerContainer.hidden=YES;
    [self.spinner stopAnimating];
    [self.connectWithFbButton setEnabled:YES];
}

@end

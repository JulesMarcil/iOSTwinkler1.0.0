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
    
    
    
    
    UIImageView *subview = [[UIImageView alloc] initWithFrame:self.view.frame];
    [subview setImage:[UIImage imageNamed:@"create-group.png"]];
    [self.secondView addSubview:subview];
    
    UIImageView *subviewInvite = [[UIImageView alloc] initWithFrame:self.view.frame];
    [subviewInvite setImage:[UIImage imageNamed:@"invite.png"]];
    [self.thirdView addSubview:subviewInvite];
    
    
    UIImageView *subviewExpense = [[UIImageView alloc] initWithFrame:self.view.frame];
    [subviewExpense setImage:[UIImage imageNamed:@"track-expenses.png"]];
    [self.fourthView addSubview:subviewExpense];
    
    UIImageView *subviewPayback = [[UIImageView alloc] initWithFrame:self.view.frame];
    [subviewPayback setImage:[UIImage imageNamed:@"payback.png"]];
    [self.fifthView addSubview:subviewPayback];
    
    CGRect frame= [self.pageControl frame];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
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
                                            screenRect.size.height-frame.size.height-30,
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
        case 5:
            self.dismissButton.hidden=YES;
            break;
            
            
        default:
            self.dismissButton.hidden=NO;
            break;
    }
    
    self.pageControl.currentPage = page;
}

- (IBAction)dismissView:(id)sender {
    if (self.pageControl.currentPage<5)
    [self.scrollView setContentOffset:CGPointMake(320*(self.pageControl.currentPage+1), 0) animated:YES];
}
@end

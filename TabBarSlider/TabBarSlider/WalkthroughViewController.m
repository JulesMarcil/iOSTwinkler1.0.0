//
//  WalkthroughViewController.m
//  Twinkler
//
//  Created by Arnaud Drizard on 14/09/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import "WalkthroughViewController.h"
#import <QuartzCore/QuartzCore.h>

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
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * 5, self.scrollView.frame.size.height);
    self.scrollView.backgroundColor=[UIColor colorWithRed:(245/255.0) green:(245/255.0) blue:(245/255.0) alpha:1];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.scrollsToTop = NO;
    self.scrollView.delegate = self;
    
    
    self.pageControl.numberOfPages = 5;
    self.pageControl.currentPage = 0;
    
    
    self.scrollView.backgroundColor=[UIColor colorWithRed:(245/255.0) green:(245/255.0) blue:(245/255.0) alpha:1];
    self.firstView.backgroundColor=[UIColor clearColor];
    self.secondView.backgroundColor=[UIColor clearColor];
    self.thirdView.backgroundColor=[UIColor clearColor];
    self.fourthView.backgroundColor=[UIColor clearColor];
    self.fifthView.backgroundColor=[UIColor clearColor];
    
    
    CGRect frame= [self.pageControl frame];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    [self.pageControl setFrame:CGRectMake(frame.origin.x,
                                                 screenRect.size.height-frame.size.height-80,
                                                 frame.size.width,
                                                 frame.size.height)];
    
    frame= [self.dismissButton frame];
    [self.dismissButton setFrame:CGRectMake(frame.origin.x,
                                          screenRect.size.height-frame.size.height-30,
                                          frame.size.width,
                                          frame.size.height)];
    
    self.dismissButton.layer.masksToBounds = YES;
    self.dismissButton.layer.borderColor = [UIColor colorWithRed:(205/255.0) green:(205/255.0) blue:(205/255.0) alpha:1].CGColor;
    self.dismissButton.layer.borderWidth = 1.0f;
    
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
    self.pageControl.currentPage = page;
}

- (IBAction)dismissView:(id)sender {
    if (self.pageControl.currentPage<4)
    [self.scrollView setContentOffset:CGPointMake(320*(self.pageControl.currentPage+1), 0) animated:YES];
}
@end

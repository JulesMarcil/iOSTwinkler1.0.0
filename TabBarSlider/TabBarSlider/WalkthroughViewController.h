//
//  WalkthroughViewController.h
//  Twinkler
//
//  Created by Arnaud Drizard on 14/09/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "customPageControl.h"

@interface WalkthroughViewController : UIViewController <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (weak, nonatomic) IBOutlet UIView *secondView;
@property (weak, nonatomic) IBOutlet UIView *thirdView;
@property (weak, nonatomic) IBOutlet UIView *fourthView;
@property (weak, nonatomic) IBOutlet UIView *fifthView;
@property (weak, nonatomic) IBOutlet UIView *sixthView;
@property (weak, nonatomic) IBOutlet customPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIButton *dismissButton;
@property (weak, nonatomic) IBOutlet UILabel *catchphraseHeaderLabel;
@property (weak, nonatomic) IBOutlet UILabel *catchphraseSubLabel;
@property (weak, nonatomic) IBOutlet UIButton *connectWithFbButton;
- (IBAction)dismissView:(id)sender;

@end

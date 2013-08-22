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

@interface TabBarViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

@implementation TabBarViewController

@synthesize collectionView=_collectionView;

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
                                          100,
                                          frame.size.width,
                                          screenHeight - 100)];
    frame= [self.toolbar frame];
    [self.toolbar setFrame:CGRectMake(0,
                                      0,
                                      frame.size.width,
                                      100)];
    self.toolbar.backgroundColor=[UIColor colorWithRed:(229/255.0) green:(98/255.0) blue:(83/255.0) alpha:1];

    [self.collectionView setFrame:CGRectMake(0,
                                      45,
                                      320,
                                      55)];
    self.collectionView.backgroundColor=[UIColor clearColor];
    switch ([self.memberArray  count]){
        case 1:
            [self.collectionView setFrame:CGRectMake(132,
                                                     45,
                                                     320,
                                                     55)];
            
            break;
            
        case 2:
            [self.collectionView setFrame:CGRectMake(100,
                                                     45,
                                                     320,
                                                     55)];
            break;
        case 3:
            [self.collectionView setFrame:CGRectMake(75,
                                                     45,
                                                     320,
                                                     55)];
            break;
        case 4:
            [self.collectionView setFrame:CGRectMake(45,
                                                     45,
                                                     320,
                                                     55)];
            break;
        case 5:
            [self.collectionView setFrame:CGRectMake(10,
                                                     45,
                                                     320,
                                                     55)];
            break;
            
    }
    
    self.tabBarBck.layer.cornerRadius = 2;
    self.tabBarBck.layer.masksToBounds = YES;
    self.activeTabBarImage.layer.cornerRadius = 2;
    self.activeTabBarImage.layer.masksToBounds = YES;
    
    UIStoryboard *timelineStoryboard=[UIStoryboard storyboardWithName:@"timelineStoryboard" bundle:nil];
    TabBarViewController *dst=[timelineStoryboard instantiateInitialViewController];
    self.currentViewController =dst;
    [self.placeholderView addSubview:dst.view];
    
    [self addChildViewController:dst];
    [self.timelineButton setSelected:YES];
    
    [self.expenseButton addTarget:self action:@selector(expenseButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.expenseButton addTarget:self action:@selector(goToExpenses) forControlEvents:UIControlEventTouchUpInside];
    [self.timelineButton addTarget:self action:@selector(goToTimeline) forControlEvents:UIControlEventTouchUpInside];
    [self.timelineButton addTarget:self action:@selector(timelineButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.listButton addTarget:self action:@selector(listButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.listButton addTarget:self action:@selector(goToList) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.revealButtonItem addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)expenseButtonPressed:(UIButton *)sender {
    CGPoint pt = {20,52};
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.1];
    //you can change the setAnimationDuration value, it is in seconds.
    
    CGRect rect = CGRectMake(pt.x, pt.y, self.activeTabBarImage.frame.size.width,self.activeTabBarImage.frame.size.height);
    
    [self.activeTabBarImage setFrame:rect];
    [sender setSelected:YES];
    [self.timelineButton setSelected:NO];
    [self.listButton setSelected:NO];
    
    [UIView commitAnimations];
}
- (void)timelineButtonPressed:(UIButton *)sender {
    CGPoint pt = {114,52};
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.1];
    //you can change the setAnimationDuration value, it is in seconds.
    
    CGRect rect = CGRectMake(pt.x, pt.y, self.activeTabBarImage.frame.size.width,self.activeTabBarImage.frame.size.height);
    
    [self.activeTabBarImage setFrame:rect];
    [sender setSelected:YES];
    [self.listButton setSelected:NO];
    [self.expenseButton setSelected:NO];
    
    [UIView commitAnimations];
}
- (void)listButtonPressed:(UIButton *)sender {
    CGPoint pt = {207,52};
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.1];
    //you can change the setAnimationDuration value, it is in seconds.
    
    CGRect rect = CGRectMake(pt.x, pt.y, self.activeTabBarImage.frame.size.width,self.activeTabBarImage.frame.size.height);
    
    [self.activeTabBarImage setFrame:rect];
    [sender setSelected:YES];
    [self.timelineButton setSelected:NO];
    [self.expenseButton setSelected:NO];
    
    [UIView commitAnimations];
}

-(void)goToExpenses{
    UIStoryboard *expenseStoryboard=[UIStoryboard storyboardWithName:@"expenseStoryboard" bundle:nil];
    UIViewController *dst=[expenseStoryboard instantiateInitialViewController];
    
    for (UIView *view in self.placeholderView.subviews){
        [view removeFromSuperview];
    }
    self.currentViewController =dst;
    [self.placeholderView addSubview:dst.view];
    
    for (UIViewController *vc in self.childViewControllers) {
        [vc.view removeFromSuperview];
        [vc removeFromParentViewController];
    }
    
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.3];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromLeft];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    [self addChildViewController:dst];
    
    [[self.placeholderView layer] addAnimation:animation forKey:@"showSecondViewController"];
}

-(void)goToTimeline{
    UIStoryboard *timelineStoryboard=[UIStoryboard storyboardWithName:@"timelineStoryboard" bundle:nil];
    UIViewController *dst=[timelineStoryboard instantiateInitialViewController];
    
    for (UIView *view in self.placeholderView.subviews){
        [view removeFromSuperview];
    }
    self.currentViewController =dst;
    [self.placeholderView addSubview:dst.view];
    
    for (UIViewController *vc in self.childViewControllers) {
        [vc.view removeFromSuperview];
        [vc removeFromParentViewController];
    }
    
    
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.3];
    [animation setType:kCATransitionPush];
    CGRect frame= [self.activeTabBarImage frame];
    if (frame.origin.x <120){
        [animation setSubtype:kCATransitionFromRight];
    }else{
        [animation setSubtype:kCATransitionFromLeft];
    }
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    [self addChildViewController:dst];
    
    [[self.placeholderView layer] addAnimation:animation forKey:@"showSecondViewController"];
}

-(void)goToList{
    UIStoryboard *timelineStoryboard=[UIStoryboard storyboardWithName:@"listStoryboard" bundle:nil];
    UIViewController *dst=[timelineStoryboard instantiateInitialViewController];
    
    for (UIView *view in self.placeholderView.subviews){
        [view removeFromSuperview];
    }
    self.currentViewController =dst;
    [self.placeholderView addSubview:dst.view];
    
    for (UIViewController *vc in self.childViewControllers) {
        [vc.view removeFromSuperview];
        [vc removeFromParentViewController];
    }
    
    [self addChildViewController:dst];
    
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.3];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromRight];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    [self addChildViewController:dst];
    
    [[self.placeholderView layer] addAnimation:animation forKey:@"showSecondViewController"];
}
#pragma mark - UICollectionView Datasource
// 1
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [self.memberArray  count];
}
// 2
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}
// 3
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"memberCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    UIImageView *memberView=[[UIImageView alloc] initWithFrame:CGRectMake(10,8,35,35)];
    memberView.image=[UIImage imageNamed: @"profile-pic-placeholder"];
    
    [self setRoundedView:memberView picture:memberView.image toDiameter:35.0];
    
    
    [cell addSubview:memberView];
    return cell;
}
// 4
/*- (UICollectionReusableView *)collectionView:
 (UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
 {
 return [[UICollectionReusableView alloc] init];
 }*/

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: Select Item
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
}
#pragma mark – UICollectionViewDelegateFlowLayout

// 1
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize retval = CGSizeMake(50, 50);
    return retval;
}

// 3
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0,0,0,0);
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

//
//  CustomTabBarSegue.m
//  TabBarSlider
//
//  Created by Arnaud Drizard on 03/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//


#import "CustomTabBarSegue.h"
#import "TabBarViewController.h"

@implementation CustomTabBarSegue

-(void) perform {
    TabBarViewController *src= (TabBarViewController *) [self sourceViewController];
    UIViewController *dst=(UIViewController *)[self destinationViewController];
    
    for (UIView *view in src.placeholderView.subviews){
        [view removeFromSuperview];
    }
    src.currentViewController =dst;
    [src.placeholderView addSubview:dst.view];
    
    for (UIViewController *vc in src.childViewControllers) {
        [vc.view removeFromSuperview];
        [vc removeFromParentViewController];
    }
    
    [src addChildViewController:dst];
}

@end

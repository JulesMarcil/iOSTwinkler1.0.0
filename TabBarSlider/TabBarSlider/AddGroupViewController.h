//
//  AddGroupViewController.h
//  TabBarSlider
//
//  Created by Arnaud Drizard on 05/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Group;

@interface AddGroupViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *groupName;
@property (weak, nonatomic) IBOutlet UITextField *groupCurrency;
@property (weak, nonatomic) Group *group;
@property (weak, nonatomic) NSDictionary *selectedCurrency;

@end

//
//  AddItemListViewController.h
//  TabBarSlider
//
//  Created by Arnaud Drizard on 05/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddItemListViewController : UIViewController

@property (strong, nonatomic) NSDictionary *item;
@property (weak, nonatomic) IBOutlet UITextField *itemInput;

@end

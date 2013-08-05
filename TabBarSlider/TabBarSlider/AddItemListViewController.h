//
//  AddItemListViewController.h
//  TabBarSlider
//
//  Created by Arnaud Drizard on 05/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddItemListViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *itemInput;

- (IBAction)doneAddItem:(UIStoryboardSegue *)segue;
- (IBAction)cancelAddItem:(UIStoryboardSegue *)segue;

@end

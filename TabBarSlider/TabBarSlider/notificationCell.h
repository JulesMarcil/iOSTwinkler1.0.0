//
//  notificationCell.h
//  TabBarSlider
//
//  Created by Arnaud Drizard on 03/09/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface notificationCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *messageContainer;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *getLabel;
@property (weak, nonatomic) IBOutlet UILabel *shareLabel;
@property (weak, nonatomic) IBOutlet UILabel *expenseName;


@end

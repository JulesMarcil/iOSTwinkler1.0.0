//
//  timelineBubbleCell.h
//  TabBarSlider
//
//  Created by Arnaud Drizard on 13/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface timelineBubbleCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextView *messageLabel;
@property (weak, nonatomic) IBOutlet UIView *messageContainer;
@property (weak, nonatomic) IBOutlet UILabel *timelineTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bubbleTailImage;
@property (weak, nonatomic) IBOutlet UIImageView *memberProfilePicImage;
@property (weak, nonatomic) IBOutlet UILabel *memberNameLabel;

@end

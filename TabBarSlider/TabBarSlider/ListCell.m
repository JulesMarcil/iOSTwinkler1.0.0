//
//  ListCell.m
//  Twinkler
//
//  Created by Arnaud Drizard on 06/09/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import "ListCell.h"

@implementation ListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

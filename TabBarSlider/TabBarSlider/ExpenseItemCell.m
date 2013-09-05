//
//  ExpenseItemCell.m
//  TabBarSlider
//
//  Created by Arnaud Drizard on 06/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import "ExpenseItemCell.h"

@implementation ExpenseItemCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.expenseContainer.backgroundColor=[UIColor colorWithRed:(240/255.0) green:(240/255.0) blue:(240/255.0) alpha:0];
        self.backgroundColor=[UIColor colorWithRed:(210/255.0) green:(210/255.0) blue:(210/255.0) alpha:0];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

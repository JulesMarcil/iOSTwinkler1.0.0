//
//  GroupDataController.h
//  TabBarSlider
//
//  Created by Arnaud Drizard on 03/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Group.h"   

@interface GroupDataController : NSObject

@property (nonatomic, copy) NSMutableArray *groupList;

- (NSUInteger)countOfList;
- (Group *)objectInListAtIndex:(NSUInteger)theIndex;
- (void)addGroupWithGroupData:(Group *)message;


@end

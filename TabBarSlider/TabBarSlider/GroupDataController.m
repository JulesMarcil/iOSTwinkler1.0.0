//
//  GroupDataController.m
//  TabBarSlider
//
//  Created by Arnaud Drizard on 03/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import "GroupDataController.h"
#import "Group.h"

@implementation GroupDataController

- (void)initializeDefaultDataList {
    NSMutableArray *GroupList = [[NSMutableArray alloc] init];
    self.groupList = GroupList;
    Group *group;
    group= [[Group alloc]initWithName:@"Carnac Attitude"];
    
    [self addGroupWithGroupData:group];
}

- (id)init {
    if (self = [super init]) {
        [self initializeDefaultDataList];
        return self;
    }
    return nil;
}

- (void)setGroupList:(NSMutableArray *)newList {
    if (_groupList != newList) {
        _groupList = [newList mutableCopy];
    }
}

- (NSUInteger)countOfList {
    return [self.groupList count];
}

- (Group *)objectInListAtIndex:(NSUInteger)theIndex {
    return [self.groupList objectAtIndex:theIndex];
}

- (void)addGroupWithGroupData:(Group *)message {
    [self.groupList addObject:message];
}

@end

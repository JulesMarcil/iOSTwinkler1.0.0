//
//  GroupDataController.m
//  TabBarSlider
//
//  Created by Arnaud Drizard on 03/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import "GroupDataController.h"
#import "Group.h"
#import "AuthAPIClient.h"

@implementation GroupDataController

- (void)initializeDefaultDataList {
    NSMutableArray *GroupList = [[NSMutableArray alloc] init];
    self.groupList = GroupList;
    
    [[AuthAPIClient sharedClient] getPath:@"app/groups"
                               parameters:nil
                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      NSError *error = nil;
                                      NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
                                      NSLog(@"success: %@", response);
                                      
                                      for(id key in response) {
                                          
                                          Group *group = [[Group alloc] initWithName:key[@"name"]
                                                                          identifier:key[@"id"]
                                                                             members:key[@"members"]
                                                              ];
                                          
                                          [self addGroupWithGroup:group];
                                      }
                                      [[NSNotificationCenter defaultCenter] postNotificationName:@"groupssWithJSONFinishedLoading" object:nil];
                                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      NSLog(@"error: %@", error);
                                  }];
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

- (void)addGroupWithGroup:(Group *)group {
    [self.groupList addObject:group];
}

@end
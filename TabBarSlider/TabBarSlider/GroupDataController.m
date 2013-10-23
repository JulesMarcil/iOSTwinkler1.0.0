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
#import "AFHTTPRequestOperation.h"

@implementation GroupDataController

- (void)initializeDefaultDataList {
    
    NSMutableArray *GroupList = [[NSMutableArray alloc] init];
    self.groupList = GroupList;
    
    CredentialStore *store = [[CredentialStore alloc] init];
    NSString *authToken = [store authToken];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@api/groups?access_token=%@", appURL, authToken]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    NSCachedURLResponse *cachedResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:request];
    
    //NSLog(@"cached response: %@", cachedResponse);
    
    if (cachedResponse != nil && [[cachedResponse data] length] > 0) {
        
        // Get cached data
        NSError* error;
        NSDictionary* response = [NSJSONSerialization JSONObjectWithData:cachedResponse.data options:kNilOptions error:&error];
        
        //NSLog(@"cached data = %@", response);
        
        for(id key in response) {
            
            Group *group = [[Group alloc] initWithName:key[@"name"]
                                            identifier:key[@"id"]
                                               members:key[@"members"]
                                          activeMember:key[@"activeMember"]
                                              currency:key[@"currency"]
                            ];
            
            [self addGroupWithGroup:group];
        }
        NSLog(@"GroupDataController: post Notification groupsWithCacheFinishedLoading");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"groupsWithJSONFinishedLoading" object:nil];
    }
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    [operation  setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error = nil;
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
        
        [self.groupList removeAllObjects];
        
        for(id key in response) {
            
            Group *group = [[Group alloc] initWithName:key[@"name"]
                                            identifier:key[@"id"]
                                               members:key[@"members"]
                                          activeMember:key[@"activeMember"]
                                              currency:key[@"currency"]
                            ];
            
            [self addGroupWithGroup:group];
        }
        NSLog(@"GroupDataController: post Notification groupsWithJSONFinishedLoading");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"groupsWithJSONFinishedLoading" object:nil];
    }
                                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          NSLog(@"error in request: %@",  operation.responseString);
                                          [[NSNotificationCenter defaultCenter] postNotificationName:@"groupsWithJSONFailedRefreshing" object:nil];
                                      }];
    
    [operation start];
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

- (void) removeGroupWithGroup:(Group *)group {
    [self.groupList removeObject:group];
}

- (void)refreshData {
    
    [[AuthAPIClient sharedClient] getPath:@"api/groups"
                               parameters:nil
                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      
                                      NSError *error = nil;
                                      NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
                                      
                                      [self.groupList removeAllObjects];
                                      
                                      for(id key in response) {
                                          
                                          Group *group = [[Group alloc] initWithName:key[@"name"]
                                                                          identifier:key[@"id"]
                                                                             members:key[@"members"]
                                                                        activeMember:key[@"activeMember"]
                                                                            currency:key[@"currency"]
                                                          ];
                                          
                                          [self addGroupWithGroup:group];
                                      }
                                      NSLog(@"GroupDataController: post Notification groupsWithJSONFinishedLoading");
                                      [[NSNotificationCenter defaultCenter] postNotificationName:@"groupsWithJSONFinishedLoading" object:nil];
                                  }
                                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      NSLog(@"error: %@", error);
                                      [[NSNotificationCenter defaultCenter] postNotificationName:@"groupsWithJSONFailedRefreshing" object:nil];
                                  }];
}

@end

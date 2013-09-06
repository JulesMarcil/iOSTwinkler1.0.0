//
//  ListDataController.m
//  TabBarSlider
//
//  Created by Arnaud Drizard on 03/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//


#import "ListDataController.h"
#import "List.h"
#import "AFHTTPRequestOperation.h"

@interface ListDataController ()

- (void)initializeDefaultDataList;

@end

@implementation ListDataController

- (void)initializeDefaultDataList {
    NSMutableArray *listList = [[NSMutableArray alloc] init];
    self.listList = listList;
    
    //Set parameters for request
    CredentialStore *store = [[CredentialStore alloc] init];
    NSString *authToken = [store authToken];
    NSString *currentGroupId = [[NSUserDefaults standardUserDefaults] stringForKey:@"currentGroupId"];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@api/lists?access_token=%@&currentGroupId=%@", appURL, authToken, currentGroupId]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    NSCachedURLResponse *cachedResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:request];
    if (cachedResponse != nil && [[cachedResponse data] length] > 0) {
        // Get cached data
        NSError* error;
        NSDictionary* response = [NSJSONSerialization JSONObjectWithData:cachedResponse.data options:kNilOptions error:&error];
        
        NSLog(@"cached data");
        [self.listList removeAllObjects];
        
        for(id key in response) {
            
            List *list = [[List alloc] initWithName:key[@"name"]
                                              items:key[@"items"]
                                         identifier:key[@"id"]];
            
            [self addListWithList:list];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"listsWithJSONFinishedLoading" object:nil];
    }
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    [operation  setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error = nil;
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
        
        [self.listList removeAllObjects];
        for(id key in response) {
            
            List *list = [[List alloc] initWithName:key[@"name"]
                                              items:key[@"items"]
                                         identifier:key[@"id"]];
            
            [self addListWithList:list];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"listsWithJSONFinishedLoading" object:nil];
        NSLog(@"listsWithJSONFinishedLoading");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", error);
    }];
    
    [operation start];
}

- (void)setListList:(NSMutableArray *)newList {
    if (_listList != newList) {
        _listList = [newList mutableCopy];
    }
}

- (id)init {
    if (self = [super init]) {
        [self initializeDefaultDataList];
        return self;
    }
    return nil;
}

- (NSUInteger)countOfList {
    return [self.listList count];
}

- (List *)objectInListAtIndex:(NSUInteger)theIndex {
    return [self.listList objectAtIndex:theIndex];
}

- (void)addListWithList:(List *)list {
    [self.listList addObject:list];
}

@end

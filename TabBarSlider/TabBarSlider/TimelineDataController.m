//
//  TimelineDataController.m
//  TabBarSlider
//
//  Created by Arnaud Drizard on 03/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import "TimelineDataController.h"
#import "Message.h"
#import "AFHTTPRequestOperation.h"

@implementation TimelineDataController

- (void)initializeDefaultDataList {
    
    NSMutableArray *MessageList = [[NSMutableArray alloc] init];
    self.MessageList = MessageList;
    
    //Set parameters for request
    CredentialStore *store = [[CredentialStore alloc] init];
    NSString *authToken = [store authToken];
    NSDictionary *currentMember = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentMember"];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@api/get/messages?access_token=%@&currentMemberId=%@", appURL, authToken, currentMember[@"id"]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    NSCachedURLResponse *cachedResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:request];
    if (cachedResponse != nil && [[cachedResponse data] length] > 0) {
        // Get cached data
        NSError* error;
        NSDictionary* response = [NSJSONSerialization JSONObjectWithData:cachedResponse.data options:kNilOptions error:&error];
        self.count = [NSNumber numberWithInt:response.count];
        
        for(id key in response) {
            
            Message *message = [[Message alloc] initWithType:key[@"type"]
                                                      author:key[@"author"]
                                                        date:[NSDate dateWithTimeIntervalSince1970:[key[@"time"] doubleValue]]
                                                        body:key[@"body"]
                                                       owner:key[@"owner"]
                                                      amount:key[@"amount"]
                                                        name:key[@"name"]
                                                       share:key[@"share"]
                                                 picturePath:key[@"picturePath"]
                                ];
            
            [self addMessage:message];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"messagesWithJSONFinishedLoading" object:nil];    }
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    [operation  setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error = nil;
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
        //NSLog(@"success: %@", response);
        [self.messageList removeAllObjects];
        self.count = [NSNumber numberWithInt:response.count];
        
        for(id key in response) {
            
            Message *message = [[Message alloc] initWithType:key[@"type"]
                                                      author:key[@"author"]
                                                        date:[NSDate dateWithTimeIntervalSince1970:[key[@"time"] doubleValue]]
                                                        body:key[@"body"]
                                                       owner:key[@"owner"]
                                                      amount:key[@"amount"]
                                                        name:key[@"name"]
                                                       share:key[@"share"]
                                                 picturePath:key[@"picturePath"]
                                ];
            
            [self addMessage:message];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"messagesWithJSONFinishedLoading" object:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", error);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"messagesWithJSONFaileddLoading" object:nil];
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

- (void)setMessageList:(NSMutableArray *)newList {
    if (_messageList != newList) {
        _messageList = [newList mutableCopy];
    }
}

- (NSUInteger)countOfList {
    return [self.messageList count];
}

- (Message *)objectInListAtIndex:(NSUInteger)theIndex {
    return [self.messageList objectAtIndex:theIndex];
}

- (void)addMessage:(Message *)message {
    [self.messageList addObject:message];
}

@end

//
//  TimelineDataController.m
//  TabBarSlider
//
//  Created by Arnaud Drizard on 03/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import "TimelineDataController.h"
#import "Message.h"
#import "AuthAPIClient.h"

@implementation TimelineDataController

- (void)initializeDefaultDataList {
    
    NSMutableArray *MessageList = [[NSMutableArray alloc] init];
    self.MessageList = MessageList;
    
    //Set parameters for request
    NSDictionary *currentMember = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentMember"];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:currentMember[@"id"], @"currentMemberId", nil];
    
    [[AuthAPIClient sharedClient] getPath:@"api/get/messages"
                               parameters:parameters
                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      NSError *error = nil;
                                      NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
                                      //NSLog(@"success: %@", response);
                                      
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
                                  }];
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

//
//  TimelineDataController.m
//  TabBarSlider
//
//  Created by Arnaud Drizard on 03/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import "TimelineDataController.h"
#import "Message.h"

@implementation TimelineDataController

- (void)initializeDefaultDataList {
    NSMutableArray *MessageList = [[NSMutableArray alloc] init];
    self.MessageList = MessageList;
    Message *message;
    NSDate *today = [NSDate date];
    message= [[Message alloc]initWithContent:@"Yo, c'est la teuf ici?" author:@"Nonouch" date: today];
    
    [self addMessageWithMessageData:message];
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

- (void)addMessageWithMessageData:(Message *)message {
    [self.messageList addObject:message];
}

@end

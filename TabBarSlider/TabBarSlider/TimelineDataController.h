//
//  TimelineDataController.h
//  TabBarSlider
//
//  Created by Arnaud Drizard on 03/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Message.h"

@interface TimelineDataController : NSObject

@property (nonatomic, copy) NSMutableArray *messageList;

- (NSUInteger)countOfList;
- (Message *)objectInListAtIndex:(NSUInteger)theIndex;
- (void)addMessageWithMessageData:(Message *)message;

@end

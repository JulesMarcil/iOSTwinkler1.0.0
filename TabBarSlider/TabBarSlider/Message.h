//
//  Message.h
//  TabBarSlider
//
//  Created by Arnaud Drizard on 03/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject

@property (nonatomic, strong) NSString *type;
@property (nonatomic,copy) NSString *author;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic,copy) NSString *body;
@property (nonatomic,copy) NSString *owner;
@property (nonatomic,copy) NSNumber *amount;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSNumber *share;
@property (nonatomic,copy) NSString *picturePath;

-(id) initWithType:(NSString *)type author:(NSString *)author date:(NSDate *)date body:(NSString *)body owner:(NSString *)owner amount:(NSNumber *)amount name:(NSString *)name share:(NSNumber *)share picturePath:(NSString *)picturePath;

@end

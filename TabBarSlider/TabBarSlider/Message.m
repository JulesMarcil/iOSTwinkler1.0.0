//
//  Message.m
//  TabBarSlider
//
//  Created by Arnaud Drizard on 03/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import "Message.h"

@implementation Message

-(id)initWithType:(NSString *)type author:(NSString *)author date:(NSDate *)date body:(NSString *)body owner:(NSString *)owner amount:(NSNumber *)amount name:(NSString *)name share:(NSNumber *)share picturePath:(NSString *)picturePath {
    self=[super init];
    if(self){
        _type=type;
        _author=author;
        _date=date;
        _body=body;
        _owner=owner;
        _amount=amount;
        _name=name;
        _share=share;
        _picturePath=picturePath;
        return self;
    }
    return nil;
}
@end

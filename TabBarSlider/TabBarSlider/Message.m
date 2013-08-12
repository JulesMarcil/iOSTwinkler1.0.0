//
//  Message.m
//  TabBarSlider
//
//  Created by Arnaud Drizard on 03/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import "Message.h"

@implementation Message
-(id)initWithContent:(NSString *)content author:(NSString *)author date:(NSDate *)date type:(NSString *)type{
    self=[super init];
    if(self){
        _content=content;
        _author=author;
        _date=date;
        _type=type;
        return self;
    }
    return nil;
}
@end

//
//  Message.h
//  TabBarSlider
//
//  Created by Arnaud Drizard on 03/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *author;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *type;

-(id) initWithContent:(NSString *)content author:(NSString *)author date:(NSDate *)date type:(NSString *)type;

@end

//
//  Group.h
//  TabBarSlider
//
//  Created by Arnaud Drizard on 03/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Group : NSObject
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *author;
@property (nonatomic, strong) NSDate *date;

-(id) initWithName:(NSString *)name;
@end

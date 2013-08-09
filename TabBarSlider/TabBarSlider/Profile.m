//
//  Profile.m
//  TabBarSlider
//
//  Created by Jules Marcilhacy on 09/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import "Profile.h"
#import "AuthAPIClient.h"

@implementation Profile

- (id)init {
    if (self = [super init]) {
        [self loadProfile];
        return self;
    }
    return nil;
}

-(id) initWithName:(NSString *)name friendNumber:(NSNumber *)friendNumber {
    self=[super init];
    if(self){
        _name=name;
        _friendNumber=friendNumber;
        return self;
    }
    return nil;
}

-(void) loadProfile {
    
    CredentialStore *store = [[CredentialStore alloc] init];
    NSString *authToken = [store authToken];
    NSLog(@"token  before loading profile: %@", authToken);
    
    [[AuthAPIClient sharedClient] getPath:@"api/profile"
                               parameters:nil
                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      NSError *error = nil;
                                      NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
                                      NSLog(@"profile loaded");
                                          
                                      [self initWithName:response[@"name"] friendNumber:response[@"friendNumber"]];
                                      
                                      [[NSNotificationCenter defaultCenter] postNotificationName:@"profileWithJSONFinishedLoading" object:nil];
                                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      NSLog(@"error: %@", error);
                                  }];
    
}

@end

//
//  AuthAPIClient.m
//  Twinkler_login
//
//  Created by Jules Marcilhacy on 03/08/13.
//  Copyright (c) 2013 Jules Marcilhacy. All rights reserved.
//

#import "AuthAPIClient.h"
#import "CredentialStore.h"
#import "AFJSONRequestOperation.h"

@implementation AuthAPIClient

+ (id)sharedClient {
    static AuthAPIClient *__instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
  
        NSURL *baseUrl = [NSURL URLWithString:appURL];
        __instance = [[AuthAPIClient alloc] initWithBaseURL:baseUrl];
    });
    return __instance;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [self setAuthTokenHeader];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(tokenChanged:)
                                                     name:@"token-changed"
                                                   object:nil];
    }
    return self;
}

- (void)setAuthTokenHeader {
    CredentialStore *store = [[CredentialStore alloc] init];
    NSString *authToken = [store authToken];
    [self setDefaultHeader:@"access_token" value:authToken];
}

- (void)tokenChanged:(NSNotification *)notification {
    [self setAuthTokenHeader];
}

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                      path:(NSString *)path
                                parameters:(NSDictionary *)parameters {
    
    CredentialStore *store = [[CredentialStore alloc] init];
    NSString *authToken = [store authToken];
    
    if (authToken && [method isEqualToString:@"GET"]) {
        NSMutableDictionary *temp = [[NSMutableDictionary alloc] initWithDictionary:parameters];
        [temp setObject:authToken forKey:@"access_token"];
        parameters  = temp;
    } else if (authToken && [method isEqualToString:@"POST"]) {
        path = [NSString stringWithFormat:@"%@?access_token=%@", path, authToken];
    }
    
    return [super requestWithMethod:method path:path parameters:parameters];
    
}

@end

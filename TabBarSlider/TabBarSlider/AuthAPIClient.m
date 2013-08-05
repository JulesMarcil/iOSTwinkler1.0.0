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

#define BASE_URL @"http://localhost:8888/Twinkler1.2.3/web/app_dev.php/"

@implementation AuthAPIClient

+ (id)sharedClient {
    static AuthAPIClient *__instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *baseUrl = [NSURL URLWithString:BASE_URL];
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

@end

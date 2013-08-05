//
//  AuthAPIClient.h
//  Twinkler_login
//
//  Created by Jules Marcilhacy on 03/08/13.
//  Copyright (c) 2013 Jules Marcilhacy. All rights reserved.
//

#import "AFHTTPClient.h"

@interface AuthAPIClient : AFHTTPClient

+(AuthAPIClient *)sharedClient;

@end

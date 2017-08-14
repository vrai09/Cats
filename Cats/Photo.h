//
//  Photo.h
//  Cats
//
//  Created by Livleen Rai on 2017-08-14.
//  Copyright © 2017 Livleen Rai. All rights reserved.
// server, farm, id, and secret

#import <Foundation/Foundation.h>

@interface Photo : NSObject

@property NSString *server;
@property NSString *farm;
@property NSString *ID;
@property NSString *secret;
@property NSURL *url;

- (instancetype)initWithServer:(NSString *)server farm:(NSString*)farm ID:(NSString*)ID secret:(NSString*)secret;

- (void)createURL;

@end

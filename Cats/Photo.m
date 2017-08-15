//
//  Photo.m
//  Cats
//
//  Created by Livleen Rai on 2017-08-14.
//  Copyright © 2017 Livleen Rai. All rights reserved.
//

#import "Photo.h"

@implementation Photo

-(instancetype)initWithServer:(NSString *)server farm:(NSString *)farm ID:(NSString *)ID secret:(NSString *)secret title:(NSString *)title {
    
    if(self = [super init]) {
        self.server = server;
        self.farm = farm;
        self.ID = ID;
        self.secret = secret;
        self.title = title;
    }
    return self;
}

- (void)createURL {
    self.url = [NSURL URLWithString:[NSString stringWithFormat:@"https://farm%d.staticflickr.com/%@/%@_%@.jpg", [self.farm intValue] , self.server, self.ID, self.secret]];
}
@end

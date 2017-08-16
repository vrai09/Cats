//
//  Photo.m
//  Cats
//
//  Created by Livleen Rai on 2017-08-14.
//  Copyright © 2017 Livleen Rai. All rights reserved.
//

#import "Photo.h"

@implementation Photo

-(instancetype)initWithID:(NSString *)ID title:(NSString *)title url:(NSURL *)url
{
    
    if(self = [super init]) {
        self.ID = ID;
        _title = title;
        self.url = url;
    }
    return self;
}

@end

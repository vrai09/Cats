//
//  Photo.h
//  Cats
//
//  Created by Livleen Rai on 2017-08-14.
//  Copyright © 2017 Livleen Rai. All rights reserved.
// server, farm, id, and secret

#import <Foundation/Foundation.h>
@import MapKit;
@import CoreLocation;
@interface Photo : NSObject <MKAnnotation>


@property(nonatomic) CLLocationCoordinate2D coordinate;
@property NSString *ID;
@property NSURL *url;
@property (nonatomic, copy)NSString *title;
@property NSURL *locationURL;


- (instancetype)initWithID:(NSString*)ID title:(NSString*)title url:(NSURL*)url;


@end

//
//  DetailViewController.h
//  Cats
//
//  Created by Livleen Rai on 2017-08-15.
//  Copyright © 2017 Livleen Rai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo.h"

@import MapKit;
@import CoreLocation;

@interface DetailViewController : UIViewController

@property Photo *photo;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

- (void)setUpMap;

@end

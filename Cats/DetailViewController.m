//
//  DetailViewController.m
//  Cats
//
//  Created by Livleen Rai on 2017-08-15.
//  Copyright © 2017 Livleen Rai. All rights reserved.
//

#import "DetailViewController.h"


@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setUpMap {
    
    MKCoordinateSpan span = MKCoordinateSpanMake(.5f, .5f);
    self.mapView.region = MKCoordinateRegionMake(self.photo.coordinate, span);
    
    [self.mapView addAnnotation:self.photo];
    
    self.navigationItem.title = self.photo.title;
}







@end

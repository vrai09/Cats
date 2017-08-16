//
//  ViewController.m
//  Cats
//
//  Created by Livleen Rai on 2017-08-14.
//  Copyright © 2017 Livleen Rai. All rights reserved.
//

#import "ViewController.h"
#import "Photo.h"
#import "CatCollectionViewCell.h"
#import "DetailViewController.h"
@import CoreLocation;

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property NSURLSession *session;
@property NSMutableArray *catArray;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.catArray = [[NSMutableArray alloc]init];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
    
        NSURL *url = [NSURL URLWithString:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=51fe506858b9869a0fb583d7f206ef60&tags=cats&has_geo=1%2C+2&extras=url_m&format=json&nojsoncallback=1"];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.session = [NSURLSession sessionWithConfiguration:configuration];
        
        
        
    
        NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:[NSURLRequest requestWithURL:[self generateURL:url]] completionHandler:^(NSData *_Nullable data, NSURLResponse *_Nullable response, NSError *_Nullable error) {
            
                error = nil;
                if(error) {
                    NSLog(@"Error:%@", error.localizedDescription);
                }
            
                NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            
                
                NSDictionary *photosDict = [jsonDict objectForKey:@"photos"];
                NSArray *photoArray = [photosDict objectForKey:@"photo"];
                for(NSDictionary *photoDict in photoArray) {
                    Photo *photo = [[Photo alloc]initWithID:[photoDict objectForKey:@"id"] title:[photoDict objectForKey:@"title"] url:[NSURL URLWithString:[photoDict objectForKey:@"url_m"]]];
                    [photo setLocationURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.geo.getLocation&api_key=51fe506858b9869a0fb583d7f206ef60&photo_id=%@&format=json&nojsoncallback=1", photo.ID]]];
                    
        
                    [self.catArray addObject:photo];
                }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.collectionView reloadData];
                
            });
        }];
    
    [dataTask resume];
        
    });

}


- (NSURL *)generateURL:(NSURL*)url {
    
    NSURLComponents *components = [[NSURLComponents alloc]initWithURL:url resolvingAgainstBaseURL:YES];
    return components.URL;
    
}

# pragma mark - Collection View


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.catArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CatCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"catCell" forIndexPath:indexPath];
    
    Photo *photo = self.catArray[indexPath.item];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:photo.url];
        cell.image = [UIImage imageWithData:imageData];
        cell.title = photo.title;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [cell setUpCell];
        });
    });
    
    return cell;
    
}

# pragma mark - segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"showDetail"]) {
        
        DetailViewController *detailVC = (DetailViewController *)segue.destinationViewController;
        
        NSIndexPath *indexPath = self.collectionView.indexPathsForSelectedItems[0];
        Photo *photo = self.catArray[indexPath.item];
        
        NSURLSessionDataTask *newDataTask = [self.session dataTaskWithRequest:[NSURLRequest requestWithURL:[self generateURL:photo.locationURL]] completionHandler:^(NSData *_Nullable data, NSURLResponse *_Nullable response, NSError *_Nullable error) {
            
            error = nil;
            if(error) {
                NSLog(@"Error: %@", error.localizedDescription);
            }
            
            NSDictionary *newJsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            NSDictionary *newPhotoDict = [newJsonDict objectForKey:@"photo"];
            NSDictionary *locationDict = [newPhotoDict objectForKey:@"location"];
            
            double lat = [[locationDict valueForKey:@"latitude"] doubleValue];
            double longitude = [[locationDict valueForKey:@"longitude"] doubleValue];
            
            photo.coordinate = CLLocationCoordinate2DMake(lat, longitude);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                detailVC.photo = photo;
                [detailVC setUpMap];
                
            });
        }];
        [newDataTask resume];
        
        
    }
    
    if([segue.identifier isEqualToString:@"showSearch"]) {
        
        SearchViewController *searchVC = (SearchViewController*)segue.destinationViewController;
        searchVC.delegate = self;
        
        
    }
}

#pragma mark - Delegate

- (void)getTags:(NSString *)tags {
    
    [self.catArray removeAllObjects];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=51fe506858b9869a0fb583d7f206ef60&tags=%@&has_geo=1%%2C+2&extras=url_m&format=json&nojsoncallback=1", tags]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:[NSURLRequest requestWithURL:[self generateURL:url]] completionHandler:^(NSData *_Nullable data, NSURLResponse *_Nullable response, NSError *_Nullable error) {
            
            error = nil;
            if(error) {
                NSLog(@"Error:%@", error.localizedDescription);
            }
            
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            
            NSDictionary *photosDict = [jsonDict objectForKey:@"photos"];
            NSArray *photoArray = [photosDict objectForKey:@"photo"];
            for(NSDictionary *photoDict in photoArray) {
                Photo *photo = [[Photo alloc]initWithID:[photoDict objectForKey:@"id"] title:[photoDict objectForKey:@"title"] url:[NSURL URLWithString:[photoDict objectForKey:@"url_m"]]];
                [photo setLocationURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.geo.getLocation&api_key=51fe506858b9869a0fb583d7f206ef60&photo_id=%@&format=json&nojsoncallback=1", photo.ID]]];
                
                
                [self.catArray addObject:photo];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.collectionView reloadData];
                
            });
        }];
        
        [dataTask resume];
        
    });
    

}

@end

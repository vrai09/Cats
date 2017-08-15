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

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property NSMutableArray *catArray;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.catArray = [[NSMutableArray alloc]init];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
    
    NSURL *url = [NSURL URLWithString:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&format=json&nojsoncallback=1&api_key=add1918e3bb8002f831ffccbb9625188&tags=cat"];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:url completionHandler: ^(NSURL *_Nullable location, NSURLResponse * _Nullable response, NSError *_Nullable error){
        
        error = nil;
        if(error) {
            NSLog(@"%@", error.localizedDescription);
            return;
        }
        
        NSData *data = [NSData dataWithContentsOfURL:location];
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        NSDictionary *photosDict = [jsonDict objectForKey:@"photos"];
                NSArray *photoArray = [photosDict objectForKey:@"photo"];
                for(NSDictionary *photoDict in photoArray) {
                
                    Photo *photo = [[Photo alloc]initWithServer:[photoDict objectForKey:@"server"] farm:[photoDict objectForKey:@"farm"] ID:[photoDict objectForKey:@"id"] secret:[photoDict objectForKey:@"secret"] title:[photoDict objectForKey:@"title"]];
                            [photo createURL];
                    
                    [self.catArray addObject:photo];
                }
        dispatch_async(dispatch_get_main_queue(), ^{

        [self.collectionView reloadData];
            
        });
    }];
        
    
    [downloadTask resume];
    });
    
}


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

@end

//
//  ViewController.m
//  Cats
//
//  Created by Livleen Rai on 2017-08-14.
//  Copyright © 2017 Livleen Rai. All rights reserved.
//

#import "ViewController.h"
#import "Photo.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
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
                
                    Photo *photo = [[Photo alloc]initWithServer:[photoDict objectForKey:@"server"] farm:[photoDict objectForKey:@"farm"] ID:[photoDict objectForKey:@"id"] secret:[photoDict objectForKey:@"secret"]];
                            [photo createURL];
                
                    //NSLog(@"%@", photo.url);
                }
        
        //NSLog(@"%@",jsonDict);
    }];
        
    
    [downloadTask resume];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

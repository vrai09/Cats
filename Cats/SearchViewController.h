//
//  SearchViewController.h
//  Cats
//
//  Created by Livleen Rai on 2017-08-15.
//  Copyright © 2017 Livleen Rai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchDelegate <NSObject>

- (void)getTags:(NSString *)tags;

@end

@interface SearchViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *tagTextField;
@property id<SearchDelegate>delegate;

@end

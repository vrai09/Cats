//
//  SearchViewController.m
//  Cats
//
//  Created by Livleen Rai on 2017-08-15.
//  Copyright © 2017 Livleen Rai. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)save:(id)sender {
    
    NSMutableString *tags = [[NSMutableString alloc]initWithString:self.tagTextField.text];
    NSString *tagsFixed = [tags stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    [self.delegate getTags:tagsFixed];
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

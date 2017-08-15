//
//  CatCollectionViewCell.m
//  Cats
//
//  Created by Livleen Rai on 2017-08-14.
//  Copyright © 2017 Livleen Rai. All rights reserved.
//

#import "CatCollectionViewCell.h"

@implementation CatCollectionViewCell


- (void)setUpCell {
    self.imageView.image = self.image;
    self.titleLabel.text = self.title;
}
@end

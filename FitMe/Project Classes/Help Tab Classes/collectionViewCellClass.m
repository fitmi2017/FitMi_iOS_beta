//
//  collectionViewCellClass.m
//  ShowUsU
//
//  Created by Dreamz Tech Solution on 22/09/14.
//  Copyright (c) 2014 DreamzTech. All rights reserved.
//

#import "collectionViewCellClass.h"

@implementation collectionViewCellClass
@synthesize cellLabel,cellImage;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
//- (void)setBounds:(CGRect)bounds {
//    [super setBounds:bounds];
//    self.contentView.frame = bounds;
//}

- (void)prepareForReuse {
    
    [super prepareForReuse];
    self.cellImage.image = nil;
     self.cellLabel.text = @"";
  }

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

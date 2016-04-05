//
//  CTTextRunModel.m
//  CTTextDisplayViewDemo
//
//  Created by LiYeBiao on 16/4/5.
//  Copyright © 2016年 Brown. All rights reserved.
//

#import "CTTextStyleModel.h"

@implementation CTTextStyleModel

- (id)init{
    self = [super init];
    if (self) {
        [self initData];
    }
    return self;
}

- (void)initData{
    self.font = [UIFont systemFontOfSize:17];
    self.numberOfLines = -1;
    self.faceOffset = 6;
    self.faceSize = CGSizeMake(25, 25);
//    self.styleColor = [UIColor blueColor];
    self.highlightBackgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    
    self.atColor = [UIColor blueColor];
    self.subjectColor = [UIColor blueColor];
    self.keyColor = [UIColor blueColor];
    self.urlColor = [UIColor blueColor];
    
    self.emailColor= [UIColor blueColor];
    self.phoneColor = [UIColor blueColor];
}


@end

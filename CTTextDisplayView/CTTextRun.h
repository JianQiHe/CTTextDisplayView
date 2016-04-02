//
//  CTTextRun.h
//  CoreTextDemo01
//
//  Created by LiYeBiao on 16/3/31.
//  Copyright © 2016年 LiYeBiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface CTTextRun : NSObject

@property (nonatomic,strong) UIFont * font;
@property (nonatomic,assign) CGSize faceSize;

- (void)runsWithAttString:(NSMutableAttributedString *)attString;

@end

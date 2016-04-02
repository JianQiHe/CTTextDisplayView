//
//  DisplayView.h
//  CoreTextDemo01
//
//  Created by LiYeBiao on 16/3/31.
//  Copyright © 2016年 LiYeBiao. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef enum {
//    CTDisplayRunTypeNone,
//    CTDisplayRunTypeUrl,
//    CTDisplayRunTypeAt,
//    CTDisplayRunTypeSubject,
//    CTDisplayRunTypeEmoji
//}CTDisplayRunType;

@class CTTextDisplayView;

@protocol CTTextDisplayViewDelegate <NSObject>

@optional
- (void)ct_textDisplayView:(CTTextDisplayView *)textDisplayView runObj:(id)runObj;

@end

@interface CTTextDisplayView : UIView

@property (nonatomic,assign) id<CTTextDisplayViewDelegate> delegate;

@property (nonatomic,assign) BOOL autoHeight;         //是否自动计算并调整高度()

@property (nonatomic,assign) CGSize faceSize;         //表情尺寸(长宽相等)
@property (nonatomic,assign) CGFloat faceOffset;      //表情偏移
@property (nonatomic,assign) NSInteger numberLines;   //默认为-1(<0为不限制行数)
@property (nonatomic,assign) CGFloat lineSpace;       //行间隔
@property (nonatomic,assign) CGFloat fontSpace;       //字间隔
@property (nonatomic,strong) UIFont * font;
@property (nonatomic,copy) NSString * text;

@property (nonatomic,assign) CGFloat highlightRadius;   //高亮圆角
@property (nonatomic,strong) UIColor * highlightColor;  //高亮背景颜色

//@property (nonatomic,strong) UIColor * keyColor;
//@property (nonatomic,strong) UIColor * atColor;
//@property (nonatomic,strong) UIColor * subjectColor;
//@property (nonatomic,strong) UIColor * urlColor;



+ (CGFloat)getRowHeightWithText:(NSString *)text rectSize:(CGSize)rectSize faceSize:(CGSize)faceSize font:(UIFont *)font lineSpace:(CGFloat)lineSpace fontSpace:(CGFloat)fontSpace numberOfLines:(NSInteger)numberOfLines;


@end




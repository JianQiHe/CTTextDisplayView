//
//  DisplayView.m
//  CoreTextDemo01
//
//  Created by LiYeBiao on 16/3/31.
//  Copyright © 2016年 LiYeBiao. All rights reserved.
//

#import "CTTextDisplayView.h"
#import <CoreText/CoreText.h>
#import "CTTextRun.h"


@interface CTTextDisplayView()

@property (nonatomic,strong) NSMutableDictionary * keyRectDict;
@property (nonatomic,strong) NSMutableDictionary * keyAttributeDict;
@property (nonatomic,strong) NSString * currentKey;
@property (nonatomic,strong) NSArray * currentKeyRectArray;

@property (nonatomic,assign) BOOL need_calc_height;
@property (nonatomic,assign) BOOL private_autoHeight;

@end

@implementation CTTextDisplayView


- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initData];
    }
    return self;
}

- (void)initData{
    self.keyRectDict = [NSMutableDictionary new];
    self.keyAttributeDict = [NSMutableDictionary new];
    self.font = [UIFont systemFontOfSize:17];
    self.numberLines = -1;
    self.faceOffset = 6;
    self.faceSize = CGSizeMake(25, 25);
    self.highlightColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
//    self.keyColor = [UIColor blueColor];
//    self.atColor = [UIColor blueColor];
//    self.subjectColor = [UIColor blueColor];
//    self.urlColor = [UIColor blueColor];
    
}

+ (NSMutableAttributedString *)createAttributedStringWithText:(NSString *)text font:(UIFont *)font lineSpace:(CGFloat)lineSpace fontSpace:(CGFloat)fontSpace
{
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:text];
    //    [self addGlobalAttributeWithContent:attString font:font lineSpace:lineSpace];
    //    return attString;
    
    //设置字体
    CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize, NULL);
    [attString addAttribute:(NSString*)kCTFontAttributeName value:(__bridge id)fontRef range:NSMakeRange(0,attString.length)];
    
    CFRelease(fontRef);
    
    [attString addAttribute:(NSString *)kCTKernAttributeName value:[NSNumber numberWithFloat:fontSpace] range:NSMakeRange(0, attString.length)];
    
    
    
    //添加换行模式
    CTParagraphStyleSetting lineBreakStyle;
    CTLineBreakMode lineBreakMode = kCTLineBreakByCharWrapping;
    lineBreakStyle.spec        = kCTParagraphStyleSpecifierLineBreakMode;
    lineBreakStyle.value       = &lineBreakMode;
    lineBreakStyle.valueSize   = sizeof(CTLineBreakMode);//sizeof(lineBreak);
    
    //行距
    CTParagraphStyleSetting lineSpaceStyle;
    lineSpaceStyle.spec = kCTParagraphStyleSpecifierLineSpacingAdjustment;//kCTParagraphStyleSpecifierLineSpacing;
    lineSpaceStyle.valueSize = sizeof(CGFloat);//sizeof(lineSpace);
    lineSpaceStyle.value =&lineSpace;
    
//    CTParagraphStyleSetting kernStyle;
//    kCTKernAttributeName
    
    //    const CFIndex kNumberOfSettings = 2;
    CTParagraphStyleSetting settings[] = {lineSpaceStyle,lineBreakStyle};
    
    CTParagraphStyleRef style = CTParagraphStyleCreate(settings, sizeof(settings)/sizeof(settings[0]));
    //    CTParagraphStyleRef style = CTParagraphStyleCreate(settings, kNumberOfSettings);
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithObject:(__bridge id)style forKey:(id)kCTParagraphStyleAttributeName ];
    CFRelease(style);
    
    [attString addAttributes:attributes range:NSMakeRange(0, [attString length])];
    
    return attString;
}

+ (CGFloat)getRowHeightWithText:(NSString *)text rectSize:(CGSize)rectSize faceSize:(CGSize)faceSize font:(UIFont *)font lineSpace:(CGFloat)lineSpace fontSpace:(CGFloat)fontSpace numberOfLines:(NSInteger)numberOfLines{
    if(!text){
        return 0;
    }
    NSMutableAttributedString *attString = [CTTextDisplayView createAttributedStringWithText:text font:font lineSpace:lineSpace fontSpace:fontSpace];
    CTTextRun * textRun = [[CTTextRun alloc] init];
    textRun.font = font;
    textRun.faceSize = faceSize;
    [textRun runsWithAttString:attString];
    
    CGRect viewRect = CGRectMake(0, 0, rectSize.width, rectSize.height);//CGRectGetHeight(self.bounds)
    
    //创建一个用来描画文字的路径，其区域为当前视图的bounds  CGPath
    CGMutablePathRef pathRef = CGPathCreateMutable();
    CGPathAddRect(pathRef, NULL, viewRect);
    CTFramesetterRef framesetterRef = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attString);
    
    //创建由framesetter管理的frame，是描画文字的一个视图范围  CTFrame
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetterRef, CFRangeMake(0, 0), pathRef, nil);
    
    CFArrayRef lines = CTFrameGetLines(frameRef);
    CFIndex lineCount = CFArrayGetCount(lines);
    
    CFRelease(pathRef);
    CFRelease(frameRef);
    CFRelease(framesetterRef);
    
    
    CGFloat frameHeight = 0;
    if(numberOfLines < 0){
        frameHeight = lineCount*(font.lineHeight+lineSpace)+lineSpace;
    }else{
        frameHeight = numberOfLines*(font.lineHeight+lineSpace)+lineSpace;
    }
    
    //四舍五入函数，否则可能会出现一条黑线
    return roundf(frameHeight);
}

- (void)setText:(NSString *)text{
    _text = text;
    _need_calc_height = YES;
    [self setNeedsDisplay];
}

- (void)setAutoHeight:(BOOL)autoHeight{
    _autoHeight = autoHeight;
    _private_autoHeight = autoHeight;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if(!self.text){
        return;
    }
    
//    NSLog(@"+++++++");
    
    [self.keyRectDict removeAllObjects];
    [self.keyAttributeDict removeAllObjects];
    
    NSMutableAttributedString *attString = [CTTextDisplayView createAttributedStringWithText:_text font:_font lineSpace:_lineSpace fontSpace:_fontSpace];
    
    CTTextRun * textRun = [[CTTextRun alloc] init];
    textRun.faceSize = _faceSize;
    textRun.font = _font;
    [textRun runsWithAttString:attString];
    
    //绘图上下文
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(contextRef, self.backgroundColor.CGColor);
    CGContextSetTextMatrix(contextRef, CGAffineTransformIdentity);
    CGContextTranslateCTM(contextRef, 0, CGRectGetHeight(self.bounds)); // 此处用计算出来的高度
    CGContextScaleCTM(contextRef, 1.0, -1.0);
    
    CGRect viewRect = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGFLOAT_MAX);//CGRectGetHeight(self.bounds)
    
    //创建一个用来描画文字的路径，其区域为当前视图的bounds  CGPath
    CGMutablePathRef pathRef = CGPathCreateMutable();
    CGPathAddRect(pathRef, NULL, viewRect);
    
    //创建一个framesetter用来管理描画文字的frame  CTFramesetter
    CTFramesetterRef framesetterRef = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attString);
    
    //创建由framesetter管理的frame，是描画文字的一个视图范围  CTFrame
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetterRef, CFRangeMake(0, 0), pathRef, nil);
    
    CFArrayRef lines = CTFrameGetLines(frameRef);
    CFIndex lineCount = CFArrayGetCount(lines);
    
//    NSLog(@"self.private_autoHeight:%d",_private_autoHeight);
    //自动计算高度(此处计算并得到高度后再重新绘制)
    if(_private_autoHeight && _need_calc_height){
        CFRelease(pathRef);
        CFRelease(frameRef);
        CFRelease(framesetterRef);
        
        _private_autoHeight = NO;
        __weak CTTextDisplayView * _weak_self = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [NSThread sleepForTimeInterval:0.01];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                CGRect frame = _weak_self.frame;
                frame.size.height = roundf(lineCount*(_weak_self.font.lineHeight+_weak_self.lineSpace)+_weak_self.lineSpace);
                _weak_self.frame = frame;
                [_weak_self setNeedsDisplay];
            });
        });
        return;
    }
//    NSLog(@"_private_autoHeight:%d",_private_autoHeight);
    _private_autoHeight = _autoHeight;
    
    CGPoint lineOrigins[lineCount];
    CTFrameGetLineOrigins(frameRef, CFRangeMake(0, 0), lineOrigins);
    
    //绘制高亮区域
    if(self.currentKeyRectArray){
        NSInteger a_count = _currentKeyRectArray.count;
        for(int i=0;i<a_count;i++){
            NSValue * rectValue =_currentKeyRectArray[i];
            CGRect rect = [rectValue CGRectValue];
            //CGRectMake(65.283691, 281.258789, 50.000000, 23.800001)
            CGPathRef path = [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:_highlightRadius] CGPath];
            CGContextSetFillColorWithColor(contextRef, _highlightColor.CGColor);
            CGContextAddPath(contextRef, path);
            CGContextFillPath(contextRef);
        }
    }
    
    
//    CGFloat totalHeight;
    
    CGFloat frameY = 0;
    for (int i = 0; i < lineCount; i++)
    {
        if(_numberLines >= 0 && !(i < _numberLines)){
            break;
        }
        CGFloat lineHeight = self.font.lineHeight+_lineSpace;
        
        CTLineRef lineRef= CFArrayGetValueAtIndex(lines, i);
        CGFloat lineAscent;
        CGFloat lineDescent;
        CGFloat lineLeading;
        CTLineGetTypographicBounds(lineRef, &lineAscent, &lineDescent, &lineLeading);
        
        
        CGPoint lineOrigin = lineOrigins[i];
        frameY = CGRectGetHeight(self.bounds) - (i + 1)*lineHeight - self.font.descender;
        lineOrigin.y = frameY;
//        NSLog(@"frameY: %f  lineHeight: %f",frameY,lineHeight);
        
        CGContextSetTextPosition(contextRef, lineOrigin.x, lineOrigin.y);
        CTLineDraw(lineRef, contextRef);
        
        
        CFArrayRef runs = CTLineGetGlyphRuns(lineRef);
        for (int j = 0; j < CFArrayGetCount(runs); j++)
        {
            CTRunRef runRef = CFArrayGetValueAtIndex(runs, j);
            CGFloat runAscent;
            CGFloat runDescent;
            CGRect runRect;
            
            runRect.size.width = CTRunGetTypographicBounds(runRef, CFRangeMake(0,0), &runAscent, &runDescent, NULL);
            runRect = CGRectMake(lineOrigin.x + CTLineGetOffsetForStringIndex(lineRef, CTRunGetStringRange(runRef).location, NULL),
                                 lineOrigin.y ,
                                 runRect.size.width,
                                 runAscent + runDescent);
            
            NSDictionary * attributes = (__bridge NSDictionary *)CTRunGetAttributes(runRef);
            NSString * keyAttribute = [attributes objectForKey:@"keyAttribute"];
            
            if (keyAttribute)
            {
                CGFloat runAscent,runDescent;
                CGFloat runWidth  = CTRunGetTypographicBounds(runRef, CFRangeMake(0,0), &runAscent, &runDescent, NULL);
//                CGFloat runHeight = (lineAscent + lineDescent );
                
                CGFloat runPointX = runRect.origin.x + lineOrigin.x;
                CGFloat runPointY = lineOrigin.y-_faceOffset;
                
                CGRect keyRect = CGRectZero;
//                NSLog(@"keyAttribute:   %@",keyAttribute);
                char firstCharAttribute = [keyAttribute characterAtIndex:0];
                
                if(firstCharAttribute == 'U' || firstCharAttribute == '@' || firstCharAttribute == '#' || firstCharAttribute == '$'){
                    keyRect = CGRectMake(runPointX, lineOrigin.y-(lineHeight-_lineSpace/2.0)/4, runWidth, lineHeight-_lineSpace/2.0);//CGRectMake(runPointX, runPointY, runWidth, runHeight);
                    NSMutableArray * obj = [self.keyAttributeDict objectForKey:keyAttribute];
                    if(obj == nil){
                        obj = [NSMutableArray new];
                    }
                    NSInteger objCount = obj.count;
                    BOOL rep = NO;
                    for(int rect_index=0;rect_index<objCount;rect_index++){
                        NSValue * rectValue = obj[rect_index];
                        CGRect rect_value = [rectValue CGRectValue];
                        if(rect_value.origin.y == keyRect.origin.y){
                            rect_value.size.width += keyRect.size.width;
                            [obj replaceObjectAtIndex:rect_index withObject:[NSValue valueWithCGRect:rect_value]];
                            rep = YES;
                            break;
                        }
                    }
                    if(!rep){
                        [obj addObject:[NSValue valueWithCGRect:keyRect]];
                    }
                    [self.keyAttributeDict setObject:obj forKey:keyAttribute];
                    [self.keyRectDict setObject:keyAttribute forKey:[NSValue valueWithCGRect:keyRect]];
                }else{
                    UIImage *image = [UIImage imageNamed:keyAttribute];
                    if (image) {
//                        CGRect runRectDraw = CGRectMake(runPointX, runPointY, _faceSize.width,_faceSize.height);
                        //runWidth, runHeight);
                        keyRect = CGRectMake(runPointX, runPointY, _faceSize.width,_faceSize.height);
                        CGContextDrawImage(contextRef, keyRect, image.CGImage);
                    }
                }
                
                
//                NSLog(@"keyAttribute: %@   x:%f  y:%f  w: %f  h:%f",keyAttribute,keyRect.origin.x,keyRect.origin.y,keyRect.size.width,keyRect.size.height);
            }
        }
    }
    
    //通过context在frame中描画文字内容
//    CTFrameDraw(frameRef, contextRef);
    CFRelease(pathRef);
    CFRelease(frameRef);
    CFRelease(framesetterRef);

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
//    NSLog(@"touchesBegan");
    _need_calc_height = NO;
    CGPoint location = [(UITouch *)[touches anyObject] locationInView:self];
    CGPoint runLocation = CGPointMake(location.x, self.frame.size.height - location.y);
    
    
    [self.keyRectDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
        
        CGRect rect = [((NSValue *)key) CGRectValue];
        if(CGRectContainsPoint(rect, runLocation))
        {
            NSArray * objArr = [self.keyAttributeDict objectForKey:obj];
            if(objArr){
                self.currentKeyRectArray = objArr;
                [self setNeedsDisplay];
            }
//            NSLog(@"obj: %@",obj);
        }
    }];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesCancelled:touches withEvent:event];
//    NSLog(@"touchesCancelled");
    _need_calc_height = NO;
    self.currentKey = nil;
    self.currentKeyRectArray = nil;
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
//    NSLog(@"touchesEnded");
    _need_calc_height = NO;
    CGPoint location = [(UITouch *)[touches anyObject] locationInView:self];
    CGPoint runLocation = CGPointMake(location.x, self.frame.size.height - location.y);
    
    [self.keyRectDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
        
        CGRect rect = [((NSValue *)key) CGRectValue];
        if(CGRectContainsPoint(rect, runLocation))
        {
//            NSLog(@"obj: %@",obj);
            __weak CTTextDisplayView * _weak_self = self;
            if(self.delegate && [self.delegate respondsToSelector:@selector(ct_textDisplayView: runObj:)]){
                char ch_key = [obj characterAtIndex:0];
                NSString * key = nil;
                if(ch_key == 'U'){
                    key = @"U";
                }else if(ch_key == '@'){
                    key = @"@";
                }else if(ch_key == '#'){
                    key = @"#";
                }else if(ch_key == '$'){
                    key = @"$";
                }
                NSRange endRange = [((NSString *)obj) rangeOfString:@"{"];
                NSDictionary * objDict = @{@"key":key,@"value":[obj substringWithRange:NSMakeRange(1, endRange.location-1)]};
                [_weak_self.delegate ct_textDisplayView:_weak_self runObj:objDict];
            }
        }
    }];
    self.currentKey = nil;
    self.currentKeyRectArray = nil;
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
    _need_calc_height = NO;
    
    CGPoint location = [(UITouch *)[touches anyObject] locationInView:self];
    CGPoint runLocation = CGPointMake(location.x, self.frame.size.height - location.y);
    
    [self.keyRectDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
        
        CGRect rect = [((NSValue *)key) CGRectValue];
        if(CGRectContainsPoint(rect, runLocation))
        {
            NSArray * objArr = [self.keyAttributeDict objectForKey:obj];
            if(objArr && (![self.currentKey isEqualToString:obj])){
                self.currentKey = obj;
//                NSLog(@"objArr:%p    curr: %p   obj: %@",objArr,_currentKeyRectArray,  obj);
                self.currentKeyRectArray = objArr;
                [self setNeedsDisplay];
            }
        }
    }];
}





@end

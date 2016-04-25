//
//  CTTextRun.m
//  CoreTextDemo01
//
//  Created by LiYeBiao on 16/3/31.
//  Copyright © 2016年 LiYeBiao. All rights reserved.
//

#import "CTTextRun.h"
#import <CoreText/CoreText.h>
#import "CTTextEmojiUtil.h"


void RunDelegateDeallocCallback(void *refCon)
{
    
}

//--上行高度
CGFloat RunDelegateGetAscentCallback(void *refCon)
{
    CTTextRun *run =(__bridge CTTextRun *) refCon;
    return run.styleModel.font.ascender;
}

//--下行高度
CGFloat RunDelegateGetDescentCallback(void *refCon)
{
    CTTextRun *run =(__bridge CTTextRun *) refCon;
    return run.styleModel.font.descender;
}

//-- 宽
CGFloat RunDelegateGetWidthCallback(void *refCon)
{
    CTTextRun *run =(__bridge CTTextRun *) refCon;
    return run.styleModel.faceSize.width;
}

CGFloat RunDelegateGetTagImgWidthCallback(void *refCon)
{
    CTTextRun *run =(__bridge CTTextRun *) refCon;
    return run.styleModel.tagImgSize.width;
}


@interface CTTextRun()

@property (nonatomic,strong) NSDictionary * emojis;

@property (nonatomic,strong) NSMutableArray * regularResult;

@end

@implementation CTTextRun

- (void)dealloc{
    //    NSLog(@"--- dealloc %@ ---",[self class]);
}

- (id)init{
    self = [super init];
    if (self) {
        [self initData];
    }
    return self;
}

- (void)initData{
    self.emojis = [CTTextEmojiUtil shareInstance].emojis;
    
    //存储能匹配表达式规则的字符串
    self.regularResult = [NSMutableArray new];
}

#pragma mark - phone
+ (void)runsPhoneWithAttString:(NSMutableAttributedString *)attString regularResults:(NSMutableArray *)regularResults  styleModel:(CTTextStyleModel *)styleModel{
    NSMutableString * attStr = attString.mutableString;
    NSError *error = nil;
    NSString *regulaStr = @"\\d{3}-\\d{8}|\\d{3}-\\d{7}|\\d{4}-\\d{8}|\\d{4}-\\d{7}|1+[358]+\\d{9}|\\d{8}|\\d{7}";
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    if (error == nil)
    {
        NSArray *arrayOfAllMatches = [regex matchesInString:attStr
                                                    options:0
                                                      range:NSMakeRange(0, [attStr length])];
        
        for (NSTextCheckingResult *match in arrayOfAllMatches){
            
            NSRange matchRange = match.range;
            
            BOOL isContinue = NO;
            for(NSValue * value in regularResults){
                if(NSMaxRange(NSIntersectionRange(matchRange, value.rangeValue)) > 0){
                    isContinue = YES;
                    break;
                }
            }
            if(isContinue){
                continue;
            }
            
            NSString* substringForMatch = [attStr substringWithRange:matchRange];
            NSValue * valueRange = [NSValue valueWithRange:matchRange];
            
            [attString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)styleModel.phoneColor.CGColor range:matchRange];
            [attString addAttribute:@"keyAttribute" value:[NSString stringWithFormat:@"P%@{%@}",substringForMatch,valueRange] range:matchRange];
            if(styleModel.phoneUnderLine){
                [attString addAttribute:(NSString *)kCTUnderlineStyleAttributeName value:(id)[NSNumber numberWithInt:kCTUnderlineStyleSingle] range:matchRange];
            }
            
        }
    }
}

#pragma mark - e-mail
// /([a-z0-9_\-\.]+)@(([a-z0-9]+[_\-]?)\.)+[a-z]{2,3}/i
// [A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}
+ (void)runsEmailWithAttString:(NSMutableAttributedString *)attString regularResults:(NSMutableArray *)regularResults styleModel:(CTTextStyleModel *)styleModel{// urlUnderLine:(BOOL)urlUnderLine color:(UIColor *)color{
    NSMutableString * attStr = attString.mutableString;
    NSError *error = nil;;
    NSString *regulaStr = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    
    if (error == nil)
    {
        NSArray *arrayOfAllMatches = [regex matchesInString:attStr
                                                    options:0
                                                      range:NSMakeRange(0, [attStr length])];
        
        for (NSTextCheckingResult *match in arrayOfAllMatches){
            NSRange matchRange = match.range;
            NSValue * valueRange = [NSValue valueWithRange:matchRange];
            
            NSString* substringForMatch = [attStr substringWithRange:matchRange];
            
            [attString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)styleModel.emailColor.CGColor range:matchRange];
            
            [attString addAttribute:@"keyAttribute" value:[NSString stringWithFormat:@"E%@{%@}",substringForMatch,valueRange] range:matchRange];
            if(styleModel.emailUnderLine){
                [attString addAttribute:(NSString *)kCTUnderlineStyleAttributeName value:(id)[NSNumber numberWithInt:kCTUnderlineStyleSingle] range:matchRange];
            }
            
            [regularResults addObject:valueRange];
        }
    }
}


#pragma mark - url
+ (void)runsRULWithAttString:(NSMutableAttributedString *)attString regularResults:(NSMutableArray *)regularResults urlUnderLine:(BOOL)urlUnderLine color:(UIColor *)color{
    
    NSMutableString * attStr = attString.mutableString;
    NSError *error = nil;;
    //<at>[a-zA-Z0-9_:\\u3400-\\u9FFF]{1,20}<\\/at>
    //    NSString * urlReg = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    //^((?!hede).)*$
    //    [a-zA-Z0-9_, \\u3400-\\u9FFF]*
    NSString *regulaStr = [NSString stringWithFormat:@"<a href='(((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%@^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%@^&*+?:_/=<>]*)?))'>((?!<\\/a>).)*<\\/a>|(((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%@^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%@^&*+?:_/=<>]*)?))",@"%",@"%",@"%",@"%"];//(<a href='%@'>[^<>]*</at>)
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSInteger forIndex = 0;
    NSInteger startIndex = -1;
    //    NSLog(@"o__str:  %@",attString.string);
    if (error == nil)
    {
        NSArray *arrayOfAllMatches = [regex matchesInString:attStr
                                                    options:0
                                                      range:NSMakeRange(0, [attStr length])];
        
        for (NSTextCheckingResult *match in arrayOfAllMatches){
            NSRange matchRange = match.range;
            
            if(startIndex == -1){
                startIndex = matchRange.location;
            }else{
                startIndex = matchRange.location-forIndex;
            }
            
            NSString* substringForMatch = [attStr substringWithRange:NSMakeRange(startIndex, matchRange.length)];
            
            //            NSLog(@"URL: %@",substringForMatch);
            
            NSString * contentStr = nil;
            NSString * replaceStr = nil;
            
            if([substringForMatch hasPrefix:@"<a"]){
                
                NSArray * contentArr = [substringForMatch componentsSeparatedByString:@"'"];
                contentStr = contentArr[1];
                
                NSString * t_str = contentArr[2];
                
                NSString * url_pre = @"[link]";
                //                NSLog(@"url_p: %lu",(unsigned long)url_pre.length);
                
                replaceStr = [NSString stringWithFormat:@"%@%@",url_pre,[t_str substringWithRange:NSMakeRange(1, t_str.length-5)]];
                //[NSString stringWithFormat:@"[链接]%@",
                
                //                 NSLog(@"url: %lu     %@",replaceStr.length,replaceStr);
                
                [attString replaceCharactersInRange:NSMakeRange(startIndex, matchRange.length) withString:replaceStr];
                
                NSRange range = NSMakeRange(startIndex, replaceStr.length);
                
                [attString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)color.CGColor range:range];
                [attString addAttribute:@"keyAttribute" value:[NSString stringWithFormat:@"H%@{%@}",contentStr,[NSValue valueWithRange:range]] range:range];
                
                [regularResults addObject:[NSValue valueWithRange:range]];
                
                forIndex += substringForMatch.length-replaceStr.length;
            }else{
                
                replaceStr = [NSString stringWithFormat:@"%@",substringForMatch];
                
                [attString replaceCharactersInRange:NSMakeRange(startIndex, matchRange.length) withString:replaceStr];
                
                NSRange range = NSMakeRange(startIndex, replaceStr.length);
                
                [attString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)color.CGColor range:range];
                
                [attString addAttribute:@"keyAttribute" value:[NSString stringWithFormat:@"U%@{%@}",substringForMatch,[NSValue valueWithRange:range]] range:range];
                
                if(urlUnderLine){
                    [attString addAttribute:(NSString *)kCTUnderlineStyleAttributeName value:(id)[NSNumber numberWithInt:kCTUnderlineStyleSingle] range:range];
                }
                
                [regularResults addObject:[NSValue valueWithRange:range]];
                
                //                forIndex -= 4;
                forIndex += substringForMatch.length-replaceStr.length;
            }
        }
    }
}

#pragma mark - Other
+ (void)runsOtherWithAttString:(NSMutableAttributedString *)attString regularResults:(NSMutableArray *)regularResults styleModel:(CTTextStyleModel *)styleModel emojis:(NSDictionary *)emojis emojisDelegate:(id)emojisDelegate{
    NSMutableString * attStr = attString.mutableString;
    
    NSError *error = nil;//@"[\\$#@]\\{[a-zA-Z0-9_:\\u3400-\\u9FFF]{1,20}\\}|\\[[a-zA-Z0-9_\\u3400-\\u9FFF]+\\]";
    NSString *regulaStr = @"<key>[a-zA-Z0-9_:\\u3400-\\u9FFF]{1,20}<\\/key>|<sub>[a-zA-Z0-9_:\\u3400-\\u9FFF]{1,20}<\\/sub>|<at>[a-zA-Z0-9_:\\u3400-\\u9FFF]{1,20}<\\/at>|[\\$#@]\\{[a-zA-Z0-9_:\\u3400-\\u9FFF]{1,20}\\}|\\[[a-zA-Z0-9_\\u3400-\\u9FFF]+\\]";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    if (error == nil)
    {
        NSArray *arrayOfAllMatches = [regex matchesInString:attStr
                                                    options:0
                                                      range:NSMakeRange(0, [attStr length])];
        
        NSInteger forIndex = 0;
        NSInteger startIndex = -1;
        
        for (NSTextCheckingResult *match in arrayOfAllMatches){
            NSRange matchRange = match.range;
            
            if(startIndex == -1){
                startIndex = matchRange.location;
            }else{
                startIndex = matchRange.location-forIndex;
            }
            
            NSString* substringForMatch = [attStr substringWithRange:NSMakeRange(startIndex, matchRange.length)];
            //            NSLog(@"substringForMatch: %@",substringForMatch);
            
            NSString * contentStr = nil;
            NSString * replaceStr = nil;
            
            if([substringForMatch hasPrefix:@"<at>"]){
                contentStr = [substringForMatch substringWithRange:NSMakeRange(4, substringForMatch.length-9)];
                
                replaceStr = [NSString stringWithFormat:@"@%@",contentStr];
                
                [attString replaceCharactersInRange:NSMakeRange(startIndex, matchRange.length) withString:replaceStr];
                
                NSRange range = NSMakeRange(startIndex, matchRange.length-8);
                
                [attString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)styleModel.atColor.CGColor range:range];
                
                [attString addAttribute:@"keyAttribute" value:[NSString stringWithFormat:@"@%@{%@}",contentStr,[NSValue valueWithRange:range]] range:range];
                
                forIndex += 8;
                continue;
            }else if ([substringForMatch hasPrefix:@"<sub>"]){
                
                contentStr = [substringForMatch substringWithRange:NSMakeRange(5, substringForMatch.length-11)];
                
                replaceStr = [NSString stringWithFormat:@"#%@#",contentStr];
                
                [attString replaceCharactersInRange:NSMakeRange(startIndex, matchRange.length) withString:replaceStr];
                
                NSRange range = NSMakeRange(startIndex, matchRange.length-9);
                
                [attString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)styleModel.subjectColor.CGColor range:range];
                [attString addAttribute:@"keyAttribute" value:[NSString stringWithFormat:@"#%@{%@}",contentStr,[NSValue valueWithRange:range]] range:range];
                
                forIndex += 9;
                
                continue;
            }else if ([substringForMatch hasPrefix:@"<key>"]){
                
                contentStr = [substringForMatch substringWithRange:NSMakeRange(5, substringForMatch.length-11)];
                
                replaceStr = [NSString stringWithFormat:@"%@",contentStr];
                
                [attString replaceCharactersInRange:NSMakeRange(startIndex, matchRange.length) withString:replaceStr];
                
                NSRange range = NSMakeRange(startIndex, matchRange.length-11);
                
                [attString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)styleModel.keyColor.CGColor range:range];
                [attString addAttribute:@"keyAttribute" value:[NSString stringWithFormat:@"$%@{%@}",contentStr,[NSValue valueWithRange:range]] range:range];
                
                forIndex += 11;
                
                continue;
            }
            
            char flagChar = [substringForMatch characterAtIndex:0];
            switch (flagChar) {
                    
                case '@':
                {
                    contentStr = [substringForMatch substringWithRange:NSMakeRange(2, substringForMatch.length-3)];
                    
                    NSArray * contentArr = [contentStr componentsSeparatedByString:@":"];
                    NSInteger tempLength = 0;
                    if(contentArr.count > 1){
                        replaceStr = [NSString stringWithFormat:@"@%@",contentArr[0]];
                        tempLength = ((NSString *)contentArr[1]).length+1;
                        forIndex += tempLength;
                    }else{
                        replaceStr = [NSString stringWithFormat:@"@%@",contentStr];
                    }
                    [attString replaceCharactersInRange:NSMakeRange(startIndex, matchRange.length) withString:replaceStr];
                    
                    //                    NSLog(@"str: %@",attString.string);
                    
                    NSRange range = NSMakeRange(startIndex, matchRange.length-2-tempLength);
                    
                    [attString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)styleModel.atColor.CGColor range:range];
                    [attString addAttribute:@"keyAttribute" value:[NSString stringWithFormat:@"@%@{%@}",contentStr,[NSValue valueWithRange:range]] range:range];
                    
                    forIndex += 2;
                }
                    break;
                case '$':
                {
                    contentStr = [substringForMatch substringWithRange:NSMakeRange(2, substringForMatch.length-3)];
                    
                    NSArray * contentArr = [contentStr componentsSeparatedByString:@":"];
                    NSInteger tempLength = 0;
                    if(contentArr.count > 1){
                        replaceStr = [NSString stringWithFormat:@"%@",contentArr[0]];
                        tempLength = ((NSString *)contentArr[1]).length+1;
                        forIndex += tempLength;
                    }else{
                        replaceStr = [NSString stringWithFormat:@"%@",contentStr];
                    }
                    [attString replaceCharactersInRange:NSMakeRange(startIndex, matchRange.length) withString:replaceStr];
                    
                    NSRange range = NSMakeRange(startIndex, matchRange.length-3-tempLength);
                    
                    [attString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)styleModel.keyColor.CGColor range:range];
                    [attString addAttribute:@"keyAttribute" value:[NSString stringWithFormat:@"$%@{%@}",contentStr,[NSValue valueWithRange:range]] range:range];
                    
                    forIndex += 3;
                    
                }
                    break;
                case '#':
                {
                    contentStr = [substringForMatch substringWithRange:NSMakeRange(2, substringForMatch.length-3)];
                    
                    NSArray * contentArr = [contentStr componentsSeparatedByString:@":"];
                    NSInteger tempLength = 0;
                    if(contentArr.count > 1){
                        replaceStr = [NSString stringWithFormat:@"#%@#",contentArr[0]];
                        tempLength = ((NSString *)contentArr[1]).length+1;
                        forIndex += tempLength;
                    }else{
                        replaceStr = [NSString stringWithFormat:@"#%@#",contentStr];
                    }
                    [attString replaceCharactersInRange:NSMakeRange(startIndex, matchRange.length) withString:replaceStr];
                    
                    NSRange range = NSMakeRange(startIndex, matchRange.length-1-tempLength);
                    
                    [attString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)styleModel.subjectColor.CGColor range:range];
                    [attString addAttribute:@"keyAttribute" value:[NSString stringWithFormat:@"#%@{%@}",contentStr,[NSValue valueWithRange:range]] range:range];
                    
                    forIndex += 1;
                    
                    
                }
                    break;
                case '[':
                {
                    
                    NSString * imageName = emojis[substringForMatch];
                    
                    if(!imageName || [imageName isEqualToString:@""]){
                        continue;
                    }
                    
                    CTRunDelegateCallbacks imageCallbacks;
                    imageCallbacks.version = kCTRunDelegateVersion1;
                    imageCallbacks.dealloc = RunDelegateDeallocCallback;
                    imageCallbacks.getAscent = RunDelegateGetAscentCallback;
                    imageCallbacks.getDescent = RunDelegateGetDescentCallback;
                    if([substringForMatch characterAtIndex:1] == 'l'){
                        imageCallbacks.getWidth = RunDelegateGetTagImgWidthCallback;
                        //                        [attString addAttribute:@"keyAttribute" value:[NSString stringWithFormat:@"%@",imageName] range:NSMakeRange(startIndex, 1)];
                    }else{
                        imageCallbacks.getWidth = RunDelegateGetWidthCallback;
                        //                        [attString addAttribute:@"keyAttribute" value:[NSString stringWithFormat:@"%@",imageName] range:NSMakeRange(startIndex, 1)];
                    }
                    
                    [attString replaceCharactersInRange:NSMakeRange(startIndex, matchRange.length) withString:@" "];
                    
                    CTRunDelegateRef runDelegate = CTRunDelegateCreate(&imageCallbacks, (__bridge void *)(emojisDelegate));
                    
                    [attString addAttribute:(NSString *)kCTRunDelegateAttributeName value:(__bridge id)runDelegate range:NSMakeRange(startIndex, 1)];
                    CFRelease(runDelegate);
                    
                    [attString addAttribute:@"keyAttribute" value:[NSString stringWithFormat:@"F:%@(%ld,%lu)",imageName,(long)startIndex, (unsigned long)matchRange.length] range:NSMakeRange(startIndex, 1)];
                    
                    
                    forIndex += substringForMatch.length-1;
                }
                    break;
                    
                default:
                    break;
            }
            
            
        }
    }
    
}


#pragma mark - runs
- (void)runsWithAttString:(NSMutableAttributedString *)attString {
    
    //清除存储能匹配表达式规则的字符串
    [_regularResult removeAllObjects];
    
    [CTTextRun runsRULWithAttString:attString regularResults:_regularResult urlUnderLine:_styleModel.urlUnderLine color:_styleModel.urlColor];
    
    //emojis
    [CTTextRun runsEmailWithAttString:attString regularResults:_regularResult styleModel:_styleModel];
    
    //电话号码比较特殊，有可能是URL、Email的一部分，所以放在URL、Email后面匹配，在URL Email中把匹配表达式的字符串存起来，而在电话规则里面不用存储
    [CTTextRun runsPhoneWithAttString:attString regularResults:_regularResult styleModel:_styleModel];
    
    //@#$...
    [CTTextRun runsOtherWithAttString:attString regularResults:_regularResult styleModel:_styleModel emojis:_emojis emojisDelegate:self];
    
}


@end

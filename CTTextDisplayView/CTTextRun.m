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

//e-mail:@"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}"
//phone: @"\\d{3}-\\d{8}|\\d{3}-\\d{7}|\\d{4}-\\d{8}|\\d{4}-\\d{7}|1+[358]+\\d{9}|\\d{8}|\\d{7}"
#pragma mark - phone
+ (void)runsPhoneWithAttString:(NSMutableAttributedString *)attString regularResults:(NSMutableArray *)regularResults  urlUnderLine:(BOOL)urlUnderLine color:(UIColor *)color{
    NSMutableString * attStr = attString.mutableString;
    NSError *error = nil;
    NSString *regulaStr = @"\\d{3}-\\d{8}|\\d{3}-\\d{7}|\\d{4}-\\d{8}|\\d{4}-\\d{7}|1+[358]+\\d{9}|\\d{8}|\\d{7}";
    //@"((\\d{11})|^((\\d{7,8})|(\\d{4}|\\d{3})-(\\d{7,8})|(\\d{4}|\\d{3})-(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1})|(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1}))$)";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    if (error == nil)
    {
        NSArray *arrayOfAllMatches = [regex matchesInString:attStr
                                                    options:0
                                                      range:NSMakeRange(0, [attStr length])];
        //        NSLog(@"regularResults: %@",regularResults);
        
        
        
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
            
            [attString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)color.CGColor range:matchRange];
            [attString addAttribute:@"keyAttribute" value:[NSString stringWithFormat:@"P%@{%@}",substringForMatch,valueRange] range:matchRange];
            if(urlUnderLine){
                [attString addAttribute:(NSString *)kCTUnderlineStyleAttributeName value:(id)[NSNumber numberWithInt:kCTUnderlineStyleSingle] range:matchRange];
            }
            
            //            [regularResults addObject:substringForMatch];
            
        }
    }
}

#pragma mark - e-mail
// /([a-z0-9_\-\.]+)@(([a-z0-9]+[_\-]?)\.)+[a-z]{2,3}/i
// [A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}
+ (void)runsEmailWithAttString:(NSMutableAttributedString *)attString regularResults:(NSMutableArray *)regularResults  urlUnderLine:(BOOL)urlUnderLine color:(UIColor *)color{
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
            
            //            NSLog(@"EMAIL:  %@    (%lu,%lu)",substringForMatch,(unsigned long)matchRange.location,(unsigned long)matchRange.length);
            
            
            [attString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)color.CGColor range:matchRange];
            
            [attString addAttribute:@"keyAttribute" value:[NSString stringWithFormat:@"E%@{%@}",substringForMatch,valueRange] range:matchRange];
            if(urlUnderLine){
                [attString addAttribute:(NSString *)kCTUnderlineStyleAttributeName value:(id)[NSNumber numberWithInt:kCTUnderlineStyleSingle] range:matchRange];
            }
            
            [regularResults addObject:valueRange];
            //            NSLog(@"substringForMatch:%@",substringForMatch);
        }
    }
}


#pragma mark - url
+ (void)runsRULWithAttString:(NSMutableAttributedString *)attString regularResults:(NSMutableArray *)regularResults urlUnderLine:(BOOL)urlUnderLine color:(UIColor *)color{
    NSMutableString * attStr = attString.mutableString;
    NSError *error = nil;;
    NSString *regulaStr = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
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
            
            [attString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)color.CGColor range:matchRange];
            
            
            [attString addAttribute:@"keyAttribute" value:[NSString stringWithFormat:@"U%@{%@}",substringForMatch,valueRange] range:matchRange];
            if(urlUnderLine){
                [attString addAttribute:(NSString *)kCTUnderlineStyleAttributeName value:(id)[NSNumber numberWithInt:kCTUnderlineStyleSingle] range:matchRange];
            }
            [regularResults addObject:valueRange];
        }
    }
}

#pragma mark - at
+ (void)runsAtWithAttString:(NSMutableAttributedString *)attString attStr:(NSMutableString *)attStr  startIndex:(NSInteger)startIndex forIndex:(NSInteger *)forIndex  color:(UIColor *)color{
    
    NSInteger length = *forIndex-startIndex+1;
    if(length > 2 && length < 20){
        NSRange range = NSMakeRange(startIndex, length);
        NSString * atStr = [attStr substringWithRange:range];
        
        NSString * contentStr = [atStr substringWithRange:NSMakeRange(1, atStr.length-2)];
        NSArray * atArr = [contentStr componentsSeparatedByString:@":"];
        NSString * replaceStr = nil;
        
        if(atArr.count > 1){
            replaceStr = atArr[0];
            length += ((NSString *)atArr[1]).length-1;
        }else{
            replaceStr = [NSString stringWithFormat:@"%@",[atStr substringWithRange:NSMakeRange(1,atStr.length-2)]];
        }
        
        [attString replaceCharactersInRange:NSMakeRange(range.location, range.length) withString:replaceStr];
        
        NSRange atRange = NSMakeRange(range.location-1, replaceStr.length+1);//atStr.length-1);
        [attString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)color.CGColor range:atRange];
        [attString addAttribute:@"keyAttribute" value:[NSString stringWithFormat:@"@%@{%@}",contentStr,[NSValue valueWithRange:atRange]] range:atRange];
        *forIndex -= length-1;
    }
    
}

#pragma mark - subject
+ (void)runsSubjectWithAttString:(NSMutableAttributedString *)attString attStr:(NSMutableString *)attStr  startIndex:(NSInteger)startIndex forIndex:(NSInteger *)forIndex color:(UIColor *)color{
    NSInteger length = *forIndex-startIndex+1;
    if(length > 2 && length < 20){
        NSRange range = NSMakeRange(startIndex, length);
        NSString * subjectStr = [attStr substringWithRange:range];
        
        NSString * contentStr = [subjectStr substringWithRange:NSMakeRange(1, subjectStr.length-2)];
        
        NSArray * atArr = [contentStr componentsSeparatedByString:@":"];
        NSString * replaceStr = nil;
        
        if(atArr.count > 1){
            replaceStr = [NSString stringWithFormat:@"%@#",atArr[0]];
            length += ((NSString *)atArr[1]).length-1;
        }else{
            replaceStr = [NSString stringWithFormat:@"%@#",[subjectStr substringWithRange:NSMakeRange(1,subjectStr.length-2)]];
        }
        
        [attString replaceCharactersInRange:NSMakeRange(range.location, range.length) withString:replaceStr];
        
        NSRange subjectRange = NSMakeRange(range.location-1, replaceStr.length+1);
        
        [attString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)color.CGColor range:subjectRange];
        [attString addAttribute:@"keyAttribute" value:[NSString stringWithFormat:@"#%@{%@}",contentStr,[NSValue valueWithRange:subjectRange]] range:subjectRange];
        *forIndex -= length-1;
    }
}

#pragma mark - key
+ (void)runsKeyWithAttString:(NSMutableAttributedString *)attString attStr:(NSMutableString *)attStr  startIndex:(NSInteger)startIndex forIndex:(NSInteger *)forIndex color:(UIColor *)color{
    NSInteger length = *forIndex-startIndex+1;
    if(length > 2 && length < 20){
        NSRange range = NSMakeRange(startIndex, length);
        NSString * keyStr = [attStr substringWithRange:range];
        
        NSString * contentStr = [keyStr substringWithRange:NSMakeRange(1, keyStr.length-2)];
        
        
        NSArray * atArr = [contentStr componentsSeparatedByString:@":"];
        NSString * replaceStr = nil;
        
        if(atArr.count > 1){
            replaceStr = atArr[0];
            length += ((NSString *)atArr[1]).length-1;
        }else{
            replaceStr = [NSString stringWithFormat:@"%@",[keyStr substringWithRange:NSMakeRange(1,keyStr.length-2)]];
        }
        
        [attString replaceCharactersInRange:NSMakeRange(range.location-1, range.length+1) withString:replaceStr];
        
        NSRange keyRange = NSMakeRange(range.location-1, replaceStr.length);//atStr.length-1);
        [attString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)color.CGColor range:keyRange];
        [attString addAttribute:@"keyAttribute" value:[NSString stringWithFormat:@"$%@{%@}",contentStr,[NSValue valueWithRange:keyRange]] range:keyRange];
        *forIndex -= length-1;
    }
}

#pragma mark - image
+ (BOOL)runsImgWithAttString:(NSMutableAttributedString *)attString attStr:(NSMutableString *)attStr emojis:(NSDictionary *)emojis startIndex:(NSInteger)startIndex forIndex:(NSInteger *)forIndex delegate:(id)delegate{
    
    NSInteger length = *forIndex-startIndex+1;
    
    NSRange range = NSMakeRange(startIndex, length);
    
    NSString * faceStr = [attStr substringWithRange:range];
    //                    NSLog(@"faceStr: %@    %@",faceStr,self.emojis[faceStr]);
    
    NSString * imageName = emojis[faceStr];
    
    if(!imageName || [imageName isEqualToString:@""]){
        return YES;
    }
    
    CTRunDelegateCallbacks imageCallbacks;
    imageCallbacks.version = kCTRunDelegateVersion1;
    imageCallbacks.dealloc = RunDelegateDeallocCallback;
    imageCallbacks.getAscent = RunDelegateGetAscentCallback;
    imageCallbacks.getDescent = RunDelegateGetDescentCallback;
    imageCallbacks.getWidth = RunDelegateGetWidthCallback;
    
    [attString replaceCharactersInRange:NSMakeRange(range.location, range.length) withString:@" "];
    
    CTRunDelegateRef runDelegate = CTRunDelegateCreate(&imageCallbacks, (__bridge void *)(delegate));
    
    [attString addAttribute:(NSString *)kCTRunDelegateAttributeName value:(__bridge id)runDelegate range:NSMakeRange(range.location, 1)];
    CFRelease(runDelegate);
    
    [attString addAttribute:@"keyAttribute" value:[NSString stringWithFormat:@"F:%@",imageName] range:NSMakeRange(range.location, 1)];
    *forIndex-=length-1;
    return NO;
}

#pragma mark - runs
- (void)runsWithAttString:(NSMutableAttributedString *)attString {
    
    //清除存储能匹配表达式规则的字符串
    [_regularResult removeAllObjects];
    
    [CTTextRun runsRULWithAttString:attString regularResults:_regularResult urlUnderLine:_styleModel.urlUnderLine color:_styleModel.urlColor];
    [CTTextRun runsEmailWithAttString:attString regularResults:_regularResult urlUnderLine:_styleModel.emailUnderLine color:_styleModel.emailColor];
    
    //电话号码比较特殊，有可能是URL、Email的一部分，所以放在URL、Email后面匹配，在URL Email中把匹配表达式的字符串存起来，而在电话规则里面不用存储
    [CTTextRun runsPhoneWithAttString:attString regularResults:_regularResult urlUnderLine:_styleModel.phoneUnderLine color:_styleModel.phoneColor];
    
    
    NSMutableString * attStr = attString.mutableString;
    
    NSInteger faceStartIndex = -1;
    
    BOOL atStart = NO;
    NSInteger atStartIndex = -1;
    
    BOOL subjectStart = NO;
    NSInteger subjectStartIndex = -1;
    
    BOOL keyStart = NO;
    NSInteger keyStartIndex = -1;
    
    //    NSLog(@"-----------------------------------------");
    
    for(NSInteger i=0;i<attStr.length;i++){
        NSString * ch = [attStr substringWithRange:NSMakeRange(i, 1)];
        //        NSLog(@"ch: %@       %d",ch,i);
        if([ch isEqualToString:@"@"]){
            atStart = YES;
            subjectStart = NO;
            keyStart = NO;
            
            subjectStartIndex = -1;
            keyStartIndex = -1;
            faceStartIndex = -1;
        }else if ([ch isEqualToString:@"#"]){
            atStart = NO;
            subjectStart = YES;
            keyStart = NO;
            
            atStartIndex = -1;
            keyStartIndex = -1;
            faceStartIndex = -1;
        }else if ([ch isEqualToString:@"$"]){
            atStart = NO;
            subjectStart = NO;
            keyStart = YES;
            
            atStartIndex = -1;
            subjectStartIndex = -1;
            faceStartIndex = -1;
        }else if([ch isEqualToString:@"{"]){
            if(atStart){
                atStartIndex = i;
            }
            if(subjectStart){
                subjectStartIndex = i;
            }
            if(keyStart){
                keyStartIndex = i;
            }
        }else if ([ch isEqualToString:@"}"]){
            
            if(atStartIndex >= 0){
                [CTTextRun runsAtWithAttString:attString attStr:attStr startIndex:atStartIndex forIndex:&i color:_styleModel.atColor];
                
            }else if (subjectStartIndex >= 0){
                [CTTextRun runsSubjectWithAttString:attString attStr:attStr startIndex:subjectStartIndex forIndex:&i color:_styleModel.subjectColor];
            }if(keyStartIndex >= 0){
                [CTTextRun runsKeyWithAttString:attString attStr:attStr startIndex:keyStartIndex forIndex:&i color:_styleModel.keyColor];
            }
            
            atStartIndex = -1;
            subjectStartIndex = -1;
            keyStartIndex = -1;
        }else{
            atStart = NO;
            subjectStart = NO;
            keyStart = NO;
            if([ch isEqualToString:@"["]){
                atStartIndex = -1;
                subjectStartIndex = -1;
                keyStartIndex = -1;
                
                faceStartIndex = i;
            }else if ([ch isEqualToString:@"]"]){
                atStartIndex = -1;
                subjectStartIndex = -1;
                keyStartIndex = -1;
                
                if(faceStartIndex >= 0){
                    BOOL isContinue = [CTTextRun runsImgWithAttString:attString attStr:attStr emojis:_emojis startIndex:faceStartIndex forIndex:&i delegate:self];
                    if(isContinue){
                        continue;
                    }
                }
                faceStartIndex = -1;
            }
        }
        
        
    }
}


@end

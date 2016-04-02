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

#define CT_Style_Color [UIColor blueColor]

void RunDelegateDeallocCallback(void *refCon)
{
    
}

//--上行高度
CGFloat RunDelegateGetAscentCallback(void *refCon)
{
    CTTextRun *run =(__bridge CTTextRun *) refCon;
    return run.font.ascender;
}

//--下行高度
CGFloat RunDelegateGetDescentCallback(void *refCon)
{
    CTTextRun *run =(__bridge CTTextRun *) refCon;
    return run.font.descender;
}

//-- 宽
CGFloat RunDelegateGetWidthCallback(void *refCon)
{
    CTTextRun *run =(__bridge CTTextRun *) refCon;
    return run.faceSize.width;
}

@interface CTTextRun()

@property (nonatomic,strong) NSDictionary * emojis;

@end

@implementation CTTextRun

- (id)init{
    self = [super init];
    if (self) {
        [self initData];
    }
    return self;
}

- (void)initData{
    self.emojis = [CTTextEmojiUtil shareInstance].emojis;
}

+ (void)runsRULWithAttString:(NSMutableAttributedString *)attString{
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
            NSString* substringForMatch = [attStr substringWithRange:match.range];
            [attString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)CT_Style_Color.CGColor range:match.range];
            [attString addAttribute:@"keyAttribute" value:[NSString stringWithFormat:@"U%@{%@}",substringForMatch,[NSValue valueWithRange:match.range]] range:match.range];
        }
    }
}




- (void)runsWithAttString:(NSMutableAttributedString *)attString{
    
    //- (NSArray *)createTextRunsWithAttString:(NSMutableAttributedString *)attString {
    //    我@{张三} 自[鄙
    
    [[self class] runsRULWithAttString:attString];
    
    NSMutableString * attStr = attString.mutableString;
    
    NSInteger faceStartIndex = -1;
    
    BOOL atStart = NO;
    NSInteger atStartIndex = -1;
    
    BOOL subjectStart = NO;
    NSInteger subjectStartIndex = -1;
    
    BOOL keyStart = NO;
    NSInteger keyStartIndex = -1;
    
    for(NSInteger i=0;i<attStr.length;i++){
        NSString * ch = [attStr substringWithRange:NSMakeRange(i, 1)];
//        NSLog(@"ch: %@       %d",ch,i);
        if([ch isEqualToString:@"@"]){
            atStart = YES;
            subjectStart = NO;
            keyStart = NO;
            
//            atStartIndex = -1;
            subjectStartIndex = -1;
            keyStartIndex = -1;
            faceStartIndex = -1;
        }else if ([ch isEqualToString:@"#"]){
            atStart = NO;
            subjectStart = YES;
            keyStart = NO;
            
            atStartIndex = -1;
//            subjectStartIndex = -1;
            keyStartIndex = -1;
            faceStartIndex = -1;
        }else if ([ch isEqualToString:@"$"]){
            atStart = NO;
            subjectStart = NO;
            keyStart = YES;
            
            atStartIndex = -1;
            subjectStartIndex = -1;
//            keyStartIndex = -1;
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
                NSInteger length = i-atStartIndex+1;
                if(length < 20){
                    NSRange range = NSMakeRange(atStartIndex, length);
                    NSString * atStr = [attStr substringWithRange:range];
                    
                    NSString * contentStr = [atStr substringWithRange:NSMakeRange(1, atStr.length-2)];
                    NSArray * atArr = [contentStr componentsSeparatedByString:@":"];
                    NSString * replaceStr = nil;
                    
//                    int sp_length = 0;
                    if(atArr.count > 1){
                        replaceStr = atArr[0];
//                        sp_length = 0;
                    }else{
                        replaceStr = [NSString stringWithFormat:@"%@",[atStr substringWithRange:NSMakeRange(1,atStr.length-2)]];
                    }
                    
                    [attString replaceCharactersInRange:NSMakeRange(range.location, range.length) withString:replaceStr];
                    
                    NSRange atRange = NSMakeRange(range.location-1, replaceStr.length+1);//atStr.length-1);
                    [attString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)CT_Style_Color.CGColor range:atRange];
                    [attString addAttribute:@"keyAttribute" value:[NSString stringWithFormat:@"@%@{%@}",contentStr,[NSValue valueWithRange:atRange]] range:atRange];
                    i -= length-1;
                }
            }else if (subjectStartIndex >= 0){
                NSInteger length = i-subjectStartIndex+1;
                if(length < 20){
                    NSRange range = NSMakeRange(subjectStartIndex, length);
                    NSString * subjectStr = [attStr substringWithRange:range];
                    
                    NSString * contentStr = [subjectStr substringWithRange:NSMakeRange(1, subjectStr.length-2)];
                    
                    NSArray * atArr = [contentStr componentsSeparatedByString:@":"];
                    NSString * replaceStr = nil;
                    
                    if(atArr.count > 1){
                        replaceStr = [NSString stringWithFormat:@"%@#",atArr[0]];
                    }else{
                        replaceStr = [NSString stringWithFormat:@"%@#",[subjectStr substringWithRange:NSMakeRange(1,subjectStr.length-2)]];
                    }
                    
                    [attString replaceCharactersInRange:NSMakeRange(range.location, range.length) withString:replaceStr];
                    
                    NSRange atRange = NSMakeRange(range.location-1, replaceStr.length+1);
                    
                    [attString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)CT_Style_Color.CGColor range:atRange];
                    [attString addAttribute:@"keyAttribute" value:[NSString stringWithFormat:@"#%@{%@}",contentStr,[NSValue valueWithRange:atRange]] range:atRange];
                    i -= length-1;
                }
            }if(keyStartIndex >= 0){
                NSInteger length = i-keyStartIndex+1;
                if(length < 20){
                    NSRange range = NSMakeRange(keyStartIndex, length);
                    NSString * keyStr = [attStr substringWithRange:range];
                    
                    NSString * contentStr = [keyStr substringWithRange:NSMakeRange(1, keyStr.length-2)];
                    
                    
                    NSArray * atArr = [contentStr componentsSeparatedByString:@":"];
                    NSString * replaceStr = nil;
                    
                    if(atArr.count > 1){
                        replaceStr = atArr[0];
                    }else{
                        replaceStr = [NSString stringWithFormat:@"%@",[keyStr substringWithRange:NSMakeRange(1,keyStr.length-2)]];
                    }
                    
                    [attString replaceCharactersInRange:NSMakeRange(range.location-1, range.length+1) withString:replaceStr];
                    
                    NSRange keyRange = NSMakeRange(range.location-1, replaceStr.length);//atStr.length-1);
                    [attString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)CT_Style_Color.CGColor range:keyRange];
                    [attString addAttribute:@"keyAttribute" value:[NSString stringWithFormat:@"$%@{%@}",contentStr,[NSValue valueWithRange:keyRange]] range:keyRange];
                    i -= length-1;
                }
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
                    
                    NSInteger length = i-faceStartIndex+1;
                    
                    NSRange range = NSMakeRange(faceStartIndex, length);
                    
                    NSString * faceStr = [attStr substringWithRange:range];
                    //                    NSLog(@"faceStr: %@    %@",faceStr,self.emojis[faceStr]);
                    
                    NSString * imageName = _emojis[faceStr];
                    
                    if(!imageName){
                        return;
                    }
                    
                    CTRunDelegateCallbacks imageCallbacks;
                    imageCallbacks.version = kCTRunDelegateVersion1;
                    imageCallbacks.dealloc = RunDelegateDeallocCallback;
                    imageCallbacks.getAscent = RunDelegateGetAscentCallback;
                    imageCallbacks.getDescent = RunDelegateGetDescentCallback;
                    imageCallbacks.getWidth = RunDelegateGetWidthCallback;
                    
                    [attString replaceCharactersInRange:NSMakeRange(range.location, range.length) withString:@" "];
                    
                    CTRunDelegateRef runDelegate = CTRunDelegateCreate(&imageCallbacks, (__bridge void *)(self));
                    
                    [attString addAttribute:(NSString *)kCTRunDelegateAttributeName value:(__bridge id)runDelegate range:NSMakeRange(range.location, 1)];
                    CFRelease(runDelegate);
                    
                    [attString addAttribute:@"keyAttribute" value:[NSString stringWithFormat:@"F:%@",imageName] range:NSMakeRange(range.location, 1)];
                    i-=length-1;
                }
                faceStartIndex = -1;
            }
        }
        
        
    }
}


@end

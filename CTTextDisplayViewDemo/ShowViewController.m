//
//  ShowViewController.m
//  CoreTextDemo01
//
//  Created by LiYeBiao on 16/4/1.
//  Copyright © 2016年 LiYeBiao. All rights reserved.
//

#import "ShowViewController.h"
#import "CTTextDisplayView.h"

@interface ShowViewController ()<CTTextDisplayViewDelegate>

@end

@implementation ShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    //@"李四回@{WEcx}东西南#{58旅游}北苛茜@{张三}伟业${李四} 回@{WEcx}[][ha@{张三}ep]复";//@"李四回@{WEcx:2345}东西人东人西有南北工的要经南@{58旅游}北苛茜@{张三}伟业${李四}";
    NSString * text = @"${李四} <a href='ftp://www.baidu.com'>FTP百度</a>回http://www.3452324.com右<a href='www.baidu.com'>WWW百度</a>复<a href='https://www.google.com'>Google</a>${张三} <sub>周杰伦</sub><key>李四</key><at>猪八戒</at>1233回工WEcx回上张三复face halo ha 王麻子:90 想人们回家78356655@qq.com[拜拜][鄙视]78356655 0755-78356655http://www.3452324.com[鄙视]34567823 #{旅游节DD} 13456890000 [拜拜][鄙视]13456890000四:32}And@{王麻子:12}\ue056宝https://www.google.com/贵的@时间[拜拜]视我 自鄙www.baidu.com[拜<at>想回家</at>拜[悲伤]视]横[悲伤]刀[拜拜]向天@{王麻子:12}笑[拜拜]，@{去留肝胆两昆}仑。 This is my first CoreText #${王麻子}{张家#{北京奥运会}界旅游}#{周杰伦:23}[拜拜]独往来[拜拜]独往来[鄙视]独往来[悲伤]。";//独往来
    
    CTTextStyleModel * styleModel = [CTTextStyleModel new];
    styleModel.font = [UIFont systemFontOfSize:19];//[UIFont fontWithName:@"Menlo-Regular" size:25];//[UIFont systemFontOfSize:25];
    styleModel.faceSize = CGSizeMake(30, 30);
    styleModel.faceOffset = 8;
    styleModel.lineSpace = 6.0f;
    styleModel.numberOfLines = -1;
    styleModel.highlightBackgroundRadius = 0;//10;
    styleModel.emailColor = [UIColor orangeColor];
    styleModel.phoneColor = [UIColor redColor];
    styleModel.subjectColor = [UIColor greenColor];
    styleModel.urlColor = [UIColor purpleColor];
    styleModel.urlUnderLine = YES;
    styleModel.emailUnderLine = YES;
    styleModel.phoneUnderLine = YES;
    //    styleModel.autoHeight = YES;
    //    styleModel.textColor = [UIColor grayColor];
    
    //    CGFloat rowHeight = [CTTextDisplayView getRowHeightWithText:text rectSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-10, CGFLOAT_MAX) styleModel:styleModel];
    
    CTTextDisplayView * textDisplayView = [[CTTextDisplayView alloc] initWithFrame:CGRectMake(5, 70, [UIScreen mainScreen].bounds.size.width-10, 1000)];
    textDisplayView.delegate = self;
    textDisplayView.styleModel = styleModel;
    textDisplayView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:textDisplayView];
    
    textDisplayView.text = text;
    
    
    //    CTTextStyleModel * styleModel2 = [CTTextStyleModel new];
    //    styleModel2.font = [UIFont systemFontOfSize:12];//[UIFont fontWithName:@"Menlo-Regular" size:17];//[UIFont systemFontOfSize:17];
    //    styleModel2.faceSize = CGSizeMake(16,16);
    //    styleModel2.faceOffset = 4.0f;
    //    styleModel2.lineSpace = 3.0f;
    //    styleModel2.numberOfLines = -1;
    //    styleModel2.highlightBackgroundRadius = 0;
    //    styleModel2.autoHeight = YES;    //自动调整高度会慢一点
    //    styleModel2.urlUnderLine = YES;
    //    styleModel2.emailUnderLine = YES;
    //    styleModel2.phoneUnderLine = YES;
    //
    //    styleModel2.urlColor = [UIColor redColor];
    //
    //    CTTextDisplayView * textDisplayView2 = [[CTTextDisplayView alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(textDisplayView.frame)+10, [UIScreen mainScreen].bounds.size.width-10, 1)];
    //    textDisplayView2.delegate = self;
    //    textDisplayView2.styleModel = styleModel2;
    //    textDisplayView2.backgroundColor = [UIColor whiteColor];
    //    [self.view addSubview:textDisplayView2];
    //
    //    textDisplayView2.text = @"ReDex is ${王麻子} concept@{张三:12}ually 0755-78356655similar to ProGuard, in that both optimize bytecode. however, optimizes#{ReDex} .dex byte${李四}code, while78356655@qq.com ProGuard [悲伤][拜拜][鄙视]optimizes[悲伤] .class https://github.com/facebook/redex bytecode before it is lowered to .dex. ";
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void)ct_textDisplayView:(CTTextDisplayView *)textDisplayView obj:(id)obj{
    NSLog(@"key: %@          value: %@",obj[@"key"],obj[@"value"]);
    self.title = obj[@"value"];
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

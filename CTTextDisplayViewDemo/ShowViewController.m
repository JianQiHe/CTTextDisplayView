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
    
    /**
     * 所有标签的用法
     * <tag type='image' value='img001'>这是一张图片</tag>  (type='image/video/link')
     * <a href='https://www.xxx.com/'>XXX</a>    链接XXX
     * <at>猪八戒</at>                            @猪八戒
     * <subject>旅游节</subject>                  #旅游节#
     * <key>张三</key>                            张三
     * @{张三}                                    @张三
     * #{旅游节}                                  #旅游节#
     * ${李四}                                    李四
     * @{张三:0012}                               @张三
     * #{过年了:0011}                             #过年了#
     * ${李四:00013}                              李四
     */
    
    NSString * text = @"<a href='https://xjasesffdf.jp/iji'>高中学霸</a>的体系${素质}供${素质:234}评撒人http://www.34523.com体系<tag type='link' value='www.guichuideng.com'>鬼吹灯</tag>的重<tag type='video' value='video001'>鬼吹灯</tag>要内重要内重要<tag type='image' value='photo001'>鬼吹灯</tag>容，将78356655为公高学素质供衡和指导。有条<a href='https://xjasesffdf.jp/iji'>基準に対して同</a>的科学精神了解的知识、具备的能力[悲伤][拜拜][拜拜][悲伤]<tag type='image' value='0002'>鬼吹灯</tag>[拜拜][鄙视][鄙视][鄙视][鄙视][悲伤][鄙视][鄙视][鄙视][鄙视][鄙视]每条基准下列出了相应的点<a href='https://www.erssffd.com/mo'>그래, 기준 을 위해 같은 对基准进行了进行了同위해 같은 </a>不需要。<a href='https://www.google.com'>Google</a>回http://www.3452324.com右<a href='www.baidu.com'>Baidu百度</a>复[拜拜]lkm要标准${张三} <subject>周杰伦</subject><key>李四，张三</key><at>猪八戒</at>1233回工WEcx回上张三复想人们回家78356655@qq.com[拜拜][鄙视] 0755-78356655[鄙视]#{旅游节DD}[拜拜][鄙视]13456890000四:32}And@{王麻子:12}\ue056宝贵的@时间[拜拜]视我 自鄙[拜<at>想回家</at>拜[悲伤]视]横[悲伤]刀[拜拜]向天@{王麻子:12}笑[拜拜]，@{去留肝胆两昆}仑。@{王麻子}张家#{北京奥运会}界旅游#{周杰伦:23}[拜拜]独往来[拜拜]独往来[鄙视]独往来[悲伤]。";
    
    CTTextStyleModel * styleModel = [CTTextStyleModel new];
    styleModel.font = [UIFont systemFontOfSize:17];//[UIFont fontWithName:@"Menlo-Regular" size:25];//[UIFont systemFontOfSize:25];
    styleModel.faceSize = CGSizeMake(22, 22);
    styleModel.tagImgSize = CGSizeMake(14, 14);
    styleModel.faceOffset = 5;
    styleModel.lineSpace = 4.0f;
    styleModel.numberOfLines = -1;
    styleModel.highlightBackgroundRadius = 4;//10;
    styleModel.highlightBackgroundAdjustHeight = 3;
    styleModel.highlightBackgroundOffset = 2.5;
    styleModel.highlightBackgroundColor = [UIColor colorWithRed:201/255.0 green:229/255.0 blue:242/255.0 alpha:1];
    styleModel.atColor = [UIColor colorWithRed:62/255.0 green:104/255.0 blue:162/255.0 alpha:1];
    styleModel.keyColor = [UIColor colorWithRed:62/255.0 green:104/255.0 blue:162/255.0 alpha:1];
    
    styleModel.emailColor = [UIColor colorWithRed:62/255.0 green:104/255.0 blue:162/255.0 alpha:1];
    
    styleModel.phoneColor = [UIColor colorWithRed:62/255.0 green:104/255.0 blue:162/255.0 alpha:1];
    styleModel.subjectColor = [UIColor colorWithRed:62/255.0 green:104/255.0 blue:162/255.0 alpha:1];
    styleModel.urlColor = [UIColor colorWithRed:62/255.0 green:104/255.0 blue:162/255.0 alpha:1];
    styleModel.textColor =[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    styleModel.urlUnderLine = YES;
    styleModel.emailUnderLine = YES;
    styleModel.phoneUnderLine = YES;
    //    styleModel.autoHeight = YES;      //
    //    styleModel.textColor = [UIColor grayColor];
    
    CGFloat rowHeight = [CTTextDisplayView getRowHeightWithText:text rectSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-10, CGFLOAT_MAX) styleModel:styleModel];
    
    CTTextDisplayView * textDisplayView = [[CTTextDisplayView alloc] initWithFrame:CGRectMake(5, 70, [UIScreen mainScreen].bounds.size.width-10, rowHeight)];
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

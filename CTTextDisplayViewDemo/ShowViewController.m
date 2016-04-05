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
    
    NSString * text = @"${李四} 回复 ${王麻子:90} 想回家347991555@qq.com 13456890000 #{旅游节}[拜拜][鄙视]13456890000四:32}And@{王麻子:12}\ue056宝https://www.google.com/贵的@时间[拜拜]视]@{W}@{}我@{张三:12} 自[鄙www.baidu.com[拜@{ABC}拜][悲伤]视]横[悲伤]刀[拜拜]向天@{王麻子:12}笑[拜拜]，@{去留肝胆两昆}仑。 This is my first CoreText #${王麻子}{张家#{北京奥运会}界旅游}#{周杰伦:23} https://www.google.com/ demo,how are you ?I [拜拜] love three [@{[拜拜]独往来[鄙视][悲伤],.说愁。[悲伤]@{王麻子:12}笑[拜拜]，@{去留肝胆两昆}仑。";
    
    CTTextStyleModel * styleModel = [CTTextStyleModel new];
    styleModel.font = [UIFont systemFontOfSize:25];
    styleModel.faceSize = CGSizeMake(40, 40);
    styleModel.faceOffset = 11;
    styleModel.lineSpace = 8.0f;
    styleModel.numberOfLines = 4;
    styleModel.highlightBackgroundRadius = 5;
    styleModel.emailColor = [UIColor orangeColor];
    styleModel.phoneColor = [UIColor redColor];
    styleModel.subjectColor = [UIColor greenColor];
    
    CGFloat rowHeight = [CTTextDisplayView getRowHeightWithText:text rectSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, CGFLOAT_MAX) styleModel:styleModel];
    
    CTTextDisplayView * textDisplayView = [[CTTextDisplayView alloc] initWithFrame:CGRectMake(5, 70, [UIScreen mainScreen].bounds.size.width-10, rowHeight)];
    textDisplayView.delegate = self;
    textDisplayView.styleModel = styleModel;
    
    textDisplayView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:textDisplayView];
    
    textDisplayView.text = text;
    

    
    CTTextStyleModel * styleModel2 = [CTTextStyleModel new];
    styleModel2.font = [UIFont systemFontOfSize:17];
    styleModel2.faceSize = CGSizeMake(25,25);
    styleModel2.faceOffset = 6.0f;
    styleModel2.lineSpace = 6.0f;
    styleModel2.numberOfLines = -1;
    styleModel2.highlightBackgroundRadius = 0;
    styleModel2.autoHeight = YES;    //自动调整高度会慢一点
    styleModel2.urlUnderLine = YES;
    styleModel2.emailUnderLine = YES;
    styleModel2.phoneUnderLine = YES;
    
    styleModel2.urlColor = [UIColor redColor];
    
    CTTextDisplayView * textDisplayView2 = [[CTTextDisplayView alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(textDisplayView.frame)+10, [UIScreen mainScreen].bounds.size.width-10, 1)];
    textDisplayView2.delegate = self;
    textDisplayView2.styleModel = styleModel2;
    textDisplayView2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:textDisplayView2];
    
    textDisplayView2.text = text;
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    }

- (void)ct_textDisplayView:(CTTextDisplayView *)textDisplayView obj:(id)obj{
        NSLog(@"key: %@          value: %@",obj[@"key"],obj[@"value"]);
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

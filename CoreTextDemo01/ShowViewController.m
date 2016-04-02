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
    
    NSString * text = @"${李四} 回复 ${王麻子:90} 想回家@{李[鄙视]四:32}And@{王麻子:12}\ue056宝https://www.google.com/贵的时间[拜拜]视]我@{张三:12} 自[鄙www.baidu.com[拜@{ABC}拜][悲伤]视]横[悲伤]刀[拜拜]向天@{王麻子:12}笑[拜拜]，@{去留肝胆两昆}仑。This is my first CoreText #${王麻子}{张家#{北京奥运会}界旅游}#{周杰伦:23} https://www.google.com/ demo,how are you ?I [拜拜] love three [@{[拜拜]独往来[鄙视][悲伤],.说愁。[悲伤]视]横[悲伤]刀[拜拜]向天@{王麻子:12}笑[拜拜]，@{去留肝胆两昆}仑。";
    
    UIFont * font = [UIFont systemFontOfSize:25];
    CGSize faceSize = CGSizeMake(40, 40);
    CGFloat lineSpace = 8.0f;
    
    CGFloat rowHeight = [CTTextDisplayView getRowHeightWithText:text rectSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, CGFLOAT_MAX) faceSize:faceSize font:font lineSpace:lineSpace fontSpace:0 numberOfLines:4 ];
    
//    NSLog(@"rowHeight: %f",rowHeight);

    CTTextDisplayView * textDisplayView = [[CTTextDisplayView alloc] initWithFrame:CGRectMake(5, 70, [UIScreen mainScreen].bounds.size.width-10, rowHeight)];
    textDisplayView.tag = 1000;
    textDisplayView.autoHeight = NO;
    textDisplayView.delegate = self;
    textDisplayView.faceOffset = 11;
    textDisplayView.faceSize = faceSize;
    textDisplayView.font = font;
    textDisplayView.lineSpace = lineSpace;
    textDisplayView.fontSpace = 0;
    textDisplayView.numberLines = 4;//
    textDisplayView.highlightRadius = 5;
    textDisplayView.clipsToBounds = YES;
    textDisplayView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:textDisplayView];
    
    textDisplayView.text = text;
    
    
    UIFont * font2 = [UIFont systemFontOfSize:17];
    CGSize faceSize2 = CGSizeMake(25, 25);
    CGFloat lineSpace2 = 6.0f;
    CTTextDisplayView * textDisplayView2 = [[CTTextDisplayView alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(textDisplayView.frame)+10, [UIScreen mainScreen].bounds.size.width-10, 1)];
    textDisplayView2.tag = 1000;
    textDisplayView2.autoHeight = YES;
    textDisplayView2.delegate = self;
    textDisplayView2.faceOffset = 6;
    textDisplayView2.faceSize = faceSize2;
    textDisplayView2.font = font2;
    textDisplayView2.lineSpace = lineSpace2;
    textDisplayView2.fontSpace = 0;
    textDisplayView2.numberLines = -1;//
    textDisplayView2.highlightRadius = 3;
    textDisplayView2.clipsToBounds = YES;
    textDisplayView2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:textDisplayView2];
    
    textDisplayView2.text = text;
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    }

- (void)ct_textDisplayView:(CTTextDisplayView *)textDisplayView runObj:(id)runObj{
        NSLog(@"key: %@          value: %@",runObj[@"key"],runObj[@"value"]);
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

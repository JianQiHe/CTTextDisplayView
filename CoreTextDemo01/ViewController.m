//
//  ViewController.m
//  CoreTextDemo01
//
//  Created by LiYeBiao on 16/3/31.
//  Copyright © 2016年 LiYeBiao. All rights reserved.
//

#import "ViewController.h"
#import "CTTextDisplayView.h"

@interface ViewController ()<CTTextDisplayViewDelegate>

@property (strong, nonatomic) CTTextDisplayView *displayView;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *marginBottom;

@property (nonatomic,strong) UITableView * tableView;

@end

@implementation ViewController
//- (IBAction)showView:(id)sender {
//}
//- (IBAction)showTableView:(id)sender {
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    NSString * text = @"[拜拜]视]我@{张三:12}自[鄙www.baidu.com[拜拜][悲伤]视]横[悲伤]刀[拜拜]向天笑[拜拜]，@{去留肝胆两昆}仑。--谭嗣同同学你好啊。This is my first CoreText #{周杰伦:23} https://www.google.com/ demo,how are you ?I [拜拜] love three thi \ue056 n[拜拜]gs,the sun,the moon,and you.the sun for the day,themoon for the night,and you forever.去[拜拜]年今年今年今@{张三人asdf面桃花}相映红人面桃花相映红日此门中，人面桃花相映红。头，有恨无人省。捡尽寒枝不肯栖，寂寞沙洲冷。[拜拜]独往来[鄙视][悲伤],.说愁。";
//    
//    UIFont * font = [UIFont systemFontOfSize:22];
//    CGSize faceSize = CGSizeMake(30, 30);
//    CGFloat lineSpace = 5.0f;
//    
//    CGFloat rowHeight = 1;//[UIScreen mainScreen].bounds.size.height;
////    [CTTextDisplayView getRowHeightWithText:text rectSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, CGFLOAT_MAX) faceSize:faceSize font:font lineSpace:lineSpace numberOfLines:-1];
//    
//    self.displayView = [[CTTextDisplayView alloc] initWithFrame:CGRectMake(5, 20, [UIScreen mainScreen].bounds.size.width-10, rowHeight)];
//    _displayView.autoHeight = YES;
//    _displayView.delegate = self;
//    _displayView.faceOffset = 7;
//    _displayView.faceSize = faceSize;
//    _displayView.font = font;
//    _displayView.lineSpace = lineSpace;
////    _displayView.numberLines = 7;//
////    _displayView.highlightRadius = 7;
//    _displayView.backgroundColor = [UIColor whiteColor];
//    
//    [self.view addSubview:_displayView];
//    _displayView.text = text;
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end

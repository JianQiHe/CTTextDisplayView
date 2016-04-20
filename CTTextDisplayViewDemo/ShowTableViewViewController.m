//
//  ShowTableViewViewController.m
//  CoreTextDemo01
//
//  Created by LiYeBiao on 16/4/1.
//  Copyright © 2016年 LiYeBiao. All rights reserved.
//

#import "ShowTableViewViewController.h"
#import "CTTextDisplayView.h"

@interface ShowTableViewViewController ()<CTTextDisplayViewDelegate>

@property (nonatomic,strong) NSMutableArray * rowHeightArray;
@property (nonatomic,strong) NSMutableArray * dataArray;


@end

@implementation ShowTableViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)initData{
    self.rowHeightArray = [NSMutableArray new];
    self.dataArray = [NSMutableArray new];
    NSString * text = @"${李四} 回复 ${张三} <sub>周杰伦</sub><key>李四</key><at>猪八戒</at>@{1233}回工@{WEcx}回上@{张三}复[face] halo ha ${王麻子:90} 想${人们}回家78356655@qq.com[拜拜][鄙视]78356655 0755-78356655http://www.3452324.com[鄙视]34567823 #{旅游节DD} 13456890000 [拜拜][鄙视]13456890000四:32}And@{王麻子:12}\ue056宝https://www.google.com/贵的@时间[拜拜]视]@{W}@{}我@{张三:12} 自[鄙www.baidu.com[拜<at>想回家</at>拜][悲伤]视]横[悲伤]刀[拜拜]向天@{王麻子:12}笑[拜拜]，@{去留肝胆两昆}仑。 This is my first CoreText #${王麻子}{张家#{北京奥运会}界旅游}#{周杰伦:23}[拜拜]独往来[拜拜]独往来[鄙视]独往来[悲伤]。";
    
    
    CTTextStyleModel * styleModel2 = [CTTextStyleModel new];
    styleModel2.font = [UIFont systemFontOfSize:15];
    styleModel2.faceSize = CGSizeMake(25,25);
    styleModel2.faceOffset = 4.0f;
    styleModel2.lineSpace = 6.0f;
    styleModel2.numberOfLines = -1;
    styleModel2.highlightBackgroundRadius = 3;
    //    styleModel2.autoHeight = YES;
    
    
    for(int i=text.length;i>0;i-=5){
        NSString * temp_text = [text substringWithRange:NSMakeRange(0, text.length-i)];
        [self.dataArray addObject:temp_text];
        
        CGFloat rowHeight = [CTTextDisplayView getRowHeightWithText:temp_text rectSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-10, CGFLOAT_MAX) styleModel:styleModel2];
        [self.rowHeightArray addObject:[NSNumber numberWithFloat:rowHeight]];
        
    }
}

#pragma mark -  CTTextDisplayViewDelegate
- (void)ct_textDisplayView:(CTTextDisplayView *)textDisplayView obj:(id)obj{
    NSLog(@"key: %@          value: %@",obj[@"key"],obj[@"value"]);
    self.title = obj[@"value"];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _rowHeightArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return ((NSNumber *)[_rowHeightArray objectAtIndex:indexPath.row]).floatValue+10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"cellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        
        
        CTTextStyleModel * styleModel2 = [CTTextStyleModel new];
        styleModel2.font = [UIFont systemFontOfSize:15];
        styleModel2.faceSize = CGSizeMake(25,25);
        styleModel2.faceOffset = 8.0f;
        styleModel2.lineSpace = 6.0f;
        styleModel2.numberOfLines = -1;
        styleModel2.highlightBackgroundRadius = 0;
        styleModel2.autoHeight = NO;
        styleModel2.urlUnderLine = YES;
        styleModel2.emailUnderLine = YES;
        styleModel2.phoneUnderLine = YES;
        styleModel2.emailColor = [UIColor orangeColor];
        styleModel2.phoneColor = [UIColor redColor];
        styleModel2.subjectColor = [UIColor purpleColor];
        
        CTTextDisplayView * textDisplayView = [[CTTextDisplayView alloc] initWithFrame:CGRectMake(5, 5, [UIScreen mainScreen].bounds.size.width-10, 1)];
        textDisplayView.tag = 100;
        textDisplayView.delegate = self;
        
        textDisplayView.styleModel = styleModel2;
        
        textDisplayView.backgroundColor = [UIColor whiteColor];
        
        [cell.contentView addSubview:textDisplayView];
    }
    CTTextDisplayView * textDisplayView = [cell.contentView viewWithTag:100];
    CGRect textViewFrame = textDisplayView.frame;
    textViewFrame.size.height = ((NSNumber *)[_rowHeightArray objectAtIndex:indexPath.row]).floatValue;
    textDisplayView.frame = textViewFrame;
    textDisplayView.text = _dataArray[indexPath.row];
    //    [textDisplayView setNeedsDisplay];
    //    cell.textLabel.text = @"text";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

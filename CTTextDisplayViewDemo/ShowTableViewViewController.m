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
    NSString * text = @"${李四} 回复 ${张三} <a href='https://xjasesffdf.jp/iji'>高中学霸</a>的体系${素质}供${素质:234}评撒人http://www.34523.com体系<tag type='link' value='www.guichuideng.com'>鬼吹灯</tag>的重<tag type='video' value='video001'>鬼吹灯</tag>要内重要内重要<tag type='image' value='photo001'>鬼吹灯</tag>容，将78356655为公高学素质供衡和指导。有条<a href='https://xjasesffdf.jp/iji'>基準に対して同</a>的科学精神了解的知识、具备的能力[悲伤][拜拜][拜拜][悲伤]<tag type='image' value='0002'>鬼吹灯</tag>[拜拜]每条基准下列出了相应的点<a href='https://www.erssffd.com/mo'>그래, 기준 을 위해 같은 对基准进行了进行了同위해 같은 </a>不需要。<a href='https://www.google.com'>Google</a>回http://www.3452324.com右<a href='www.baidu.com'>Baidu百度</a>复[拜拜]lkm要标准${张三} <subject>周杰伦</subject><key>李四，张三</key><at>猪八戒</at>枯燥无味煤村我诶工<subject>周杰伦</subject><key>李四</key><at>猪八戒</at>@{1233}回工@{WEcx}回上@{张三}复[face] halo ha ${王麻子:90} 想${人们}回家78356655@qq.com[拜拜][鄙视]78356655 0755-78356655http://www.3452324.com[鄙视]34567823 #{旅游节DD} 13456890000 [拜拜][鄙视]13456890000四:32}And@{王麻子:12}\ue056宝https://www.google.com/贵的@时间[拜拜]视]@{W}@{}我@{张三:12} 自[鄙www.baidu.com[拜<at>想回家</at>拜][悲伤]视]横[悲伤]刀[拜拜]向天@{王麻子:12}笑[拜拜]，@{去留肝胆两昆}仑。 This is my first CoreText #${王麻子}{张家#{北京奥运会}界旅游}#{周杰伦:23}[拜拜]独往来[拜拜]独往来[鄙视]独往来[悲伤]。";
    
    
    CTTextStyleModel * styleModel2 = [CTTextStyleModel new];
    styleModel2.font = [UIFont systemFontOfSize:20];
    styleModel2.faceSize = CGSizeMake(28,28);
    styleModel2.tagImgSize = CGSizeMake(14, 14);
    styleModel2.faceOffset = 4.0f;
    styleModel2.lineSpace = 6.0f;
    styleModel2.numberOfLines = -1;
    styleModel2.highlightBackgroundRadius = 3;
    //    styleModel2.autoHeight = YES;
    styleModel2.highlightBackgroundAdjustHeight = 2;
    styleModel2.highlightBackgroundOffset = 3;
    
    for(int i=text.length;i>0;i-=5){
        NSString * temp_text = [text substringWithRange:NSMakeRange(0, random()%text.length)];
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
        styleModel2.font = [UIFont systemFontOfSize:20];
        styleModel2.faceSize = CGSizeMake(28,28);
        styleModel2.tagImgSize = CGSizeMake(14, 14);
        styleModel2.faceOffset = 8.0f;
        styleModel2.lineSpace = 6.0f;
        styleModel2.numberOfLines = -1;
        styleModel2.highlightBackgroundRadius = 10;
        styleModel2.highlightBackgroundAdjustHeight = 2;
        styleModel2.highlightBackgroundOffset = 3;
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
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSLog(@"indexPath:%@",indexPath);
}

@end

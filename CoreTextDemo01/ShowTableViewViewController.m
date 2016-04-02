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
    NSString * text = @"${李四} 回复 ${王麻子}[拜拜]视]我@{张三:12}自[鄙www.baidu.com[拜拜][悲伤]视]横[悲伤]刀[拜拜]向天笑[拜拜]，@{去留肝胆两昆}仑。This is my first CoreText #{周杰伦:23} https://www.google.com/ demo,how are you ?I [拜拜] love three thi \ue056 n[拜拜]gs,the sun,the moon,and you.the sun for the day,themoon for the night,and you forever.去[拜拜]年今年今年今@{张三人asdf面桃花}相映红人面桃花相映红日此门中，人面桃花相映红。头，有恨无人省。捡尽寒枝不肯栖，寂寞沙洲冷。[拜拜]独往来[鄙视][悲伤],.说愁";
    UIFont * font = [UIFont systemFontOfSize:16];
    CGSize faceSize = CGSizeMake(25, 25);
    CGFloat lineSpace = 5.0f;
    
    
    for(int i=100;i>0;i-=5){
        NSString * temp_text = [text substringWithRange:NSMakeRange(0, text.length-i)];
        [self.dataArray addObject:temp_text];
        
        CGFloat rowHeight = [CTTextDisplayView getRowHeightWithText:temp_text rectSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-10, CGFLOAT_MAX) faceSize:faceSize font:font lineSpace:lineSpace fontSpace:0 numberOfLines:-1 ];
        [self.rowHeightArray addObject:[NSNumber numberWithFloat:rowHeight]];
        
    }
}

#pragma mark -  CTTextDisplayViewDelegate
- (void)ct_textDisplayView:(CTTextDisplayView *)textDisplayView runObj:(id)runObj{
    NSLog(@"key: %@          value: %@",runObj[@"key"],runObj[@"value"]);
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
        
        UIFont * font = [UIFont systemFontOfSize:16];
        CGSize faceSize = CGSizeMake(25, 25);
        CGFloat lineSpace = 5.0f;
        
        CGFloat rowHeight = 1;//[UIScreen mainScreen].bounds.size.height;
        //    [CTTextDisplayView getRowHeightWithText:text rectSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, CGFLOAT_MAX) faceSize:faceSize font:font lineSpace:lineSpace numberOfLines:-1];
        
        CTTextDisplayView * textDisplayView = [[CTTextDisplayView alloc] initWithFrame:CGRectMake(5, 5, [UIScreen mainScreen].bounds.size.width-10, rowHeight)];
        textDisplayView.tag = 100;
        textDisplayView.autoHeight = NO;
        textDisplayView.delegate = self;
        textDisplayView.faceOffset = 6;
        textDisplayView.faceSize = faceSize;
        textDisplayView.font = font;
        textDisplayView.lineSpace = lineSpace;
        //    _displayView.numberLines = 7;//
        //    _displayView.highlightRadius = 7;
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

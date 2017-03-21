//
//  ViewController.m
//  TableViewLink
//
//  Created by YOUNG on 2017/3/21.
//  Copyright © 2017年 Young. All rights reserved.
//

#import "ViewController.h"
#import "Model.h"
#import "NSObject+Property.h"
#import "RightTableViewCell.h"
#import "LeftTableViewCell.h"
#import "TableHeaderView.h"

#define ScreenHeight  [UIScreen mainScreen].bounds.size.height

#define ScreenWeight   [UIScreen mainScreen].bounds.size.width

#define leftCellId   @"left"

#define rightCellId  @"right"


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSMutableArray *categoryData;

@property(nonatomic,strong)NSMutableArray *foodData;

@property(nonatomic,strong)UITableView *leftTableView;

@property(nonatomic,strong)UITableView *rightTableView;

@end

@implementation ViewController
{
    NSInteger _selectIndex;
    BOOL _isScrollDown;
}
#pragma mark -- getter

-(NSMutableArray *)categoryData{
    if (!_categoryData) {
        _categoryData = [NSMutableArray array];
    }
    return _categoryData;
}

-(NSMutableArray *)foodData{
    if (!_foodData) {
        _foodData = [NSMutableArray array];
        
    }
    return _foodData ;
}

-(UITableView *)leftTableView{
    if (!_leftTableView) {
        _leftTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 80, ScreenHeight)];
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        _leftTableView.rowHeight = 55;
        _leftTableView.tableFooterView = [UIView new];
        _leftTableView.showsVerticalScrollIndicator = NO;
        _leftTableView.separatorColor = [UIColor clearColor];
        [_leftTableView registerClass:[LeftTableViewCell class] forCellReuseIdentifier:leftCellId];
    }
    return _leftTableView;
}

-(UITableView *)rightTableView{
    if (!_rightTableView) {
        _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(80, 64, ScreenWeight - 80, ScreenHeight - 64)];
        _rightTableView.delegate = self;
        _rightTableView.dataSource = self;
        _rightTableView.rowHeight = 80;
        _rightTableView.showsVerticalScrollIndicator = NO;
        [_rightTableView registerClass:[RightTableViewCell class] forCellReuseIdentifier:rightCellId];
    }
    return _rightTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _selectIndex = 0;
    _isScrollDown = YES;
    [self.view addSubview:self.leftTableView];
    [self.view addSubview:self.rightTableView];
    [self fetchDataFromFile];
    [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
}

#pragma mark -- fetch data from json
-(void)fetchDataFromFile{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"meituan" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSArray *foods = dict[@"data"][@"food_spu_tags"];
    
    for (NSDictionary *dict in foods)
    {
        CateGoryModel *model = [CateGoryModel objectWithDictionary:dict];
        [self.categoryData addObject:model];
        
        NSMutableArray *datas = [NSMutableArray array];
        for (FoodModel *foodmodel in model.spus)
        {
            [datas addObject:foodmodel];
        }
        [self.foodData addObject:datas];
    }
}


#pragma mark --- data source delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.leftTableView == tableView) {
        return 1;
    }else{
        return self.categoryData.count;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.leftTableView == tableView) {
        return  self.categoryData.count;
    }else{
        return [self.foodData[section] count];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.leftTableView == tableView)
    {
        LeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:leftCellId forIndexPath:indexPath];
        if(nil == cell){
            cell = [[LeftTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:leftCellId];
        }
        FoodModel *model = self.categoryData[indexPath.row];
        cell.name.text = model.name;
        return cell;
    }
    else
    {
        RightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:rightCellId forIndexPath:indexPath];
        if(nil == cell){
            cell = [[RightTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rightCellId];
        }
        FoodModel *model = self.foodData[indexPath.section][indexPath.row];
        cell.model = model;
        return cell;
    }
}
#pragma mark -- headerView

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_rightTableView == tableView)
    {
        return 20;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (_rightTableView == tableView)
    {
        TableHeaderView *view = [[TableHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWeight, 20)];
        FoodModel *model = self.categoryData[section];
        view.name.text = model.name;
        return view;
    }
    return nil;
}

#pragma mark -- 联动的业务逻辑

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_leftTableView == tableView) {
        _selectIndex = indexPath.row;
        [_rightTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:_selectIndex] atScrollPosition:UITableViewScrollPositionTop animated:YES];

    }else{
        
    }
}

// 标记一下 RightTableView 的滚动方向，是向上还是向下
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    static CGFloat lastOffsetY = 0;
    
    UITableView *tableView = (UITableView *) scrollView;
    if (_rightTableView == tableView)
    {
        _isScrollDown = lastOffsetY < scrollView.contentOffset.y;
        lastOffsetY = scrollView.contentOffset.y;
    }
}

// TableView 分区标题即将展示
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(nonnull UIView *)view forSection:(NSInteger)section
{
    // 当前的 tableView 是 RightTableView，RightTableView 滚动的方向向上， RightTableView 是用户拖拽而产生滚动的（（主要判断 RightTableView 用户拖拽而滚动的，还是点击 LeftTableView 而滚动的）
    if ((_rightTableView == tableView) && !_isScrollDown && _rightTableView.dragging)
    {
        [self selectRowAtIndexPath:section];
    }
}

// TableView 分区标题展示结束 section +1
- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // 当前的 tableView 是 RightTableView，RightTableView 滚动的方向向下， RightTableView 是用户拖拽而产生滚动的（主要判断 RightTableView 用户拖拽而滚动的，还是点击 LeftTableView 而滚动的）
    if ((_rightTableView == tableView) && _isScrollDown && _rightTableView.dragging)
    {
        [self selectRowAtIndexPath:section + 1];
    }
}

// 当拖动右边 TableView 的时候，处理左边 TableView
- (void)selectRowAtIndexPath:(NSInteger)index
{
    [_leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
}
















@end

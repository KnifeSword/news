//
//  DataTableViewController.m
//  新闻客户端
//
//  Created by qingyun on 16/5/23.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "DataTableViewController.h"
#import "XWSectionHeaderView.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "Common.h"
#import "HomeListModel.h"
#import "XWimagesCell.h"
#import "XWHomeListCell.h"
#import "XWimagesCell.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"
#import "docDestialVC.h"
@interface DataTableViewController ()
@property(nonatomic,strong)NSMutableArray *newsList;
@property(nonatomic,strong)NSMutableArray *focus;
@property(nonatomic,strong)NSDictionary *dict;
@property (nonatomic ,strong)AFHTTPSessionManager *manager;
@property(nonatomic,strong)UISearchBar *search;
@end

@implementation DataTableViewController
-(UISearchBar *)search
{
    if (_search==nil) {
        _search=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, ScrW, 44)];
        _search.searchBarStyle=UISearchBarStyleMinimal;
        
    }
    return _search;
}
-(NSMutableArray *)newsList
{
    if (_newsList==nil) {
        _newsList=[NSMutableArray array];
    }
    return _newsList;
}
-(AFHTTPSessionManager *)manager {
    if (!_manager) {
        //创建manager对象
        _manager=[AFHTTPSessionManager manager];
        //设置网络监听
        _manager.reachabilityManager=[AFNetworkReachabilityManager sharedManager];
        [_manager.reachabilityManager startMonitoring];
    }
    return _manager;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.estimatedRowHeight=120.f;
    self.tableView.rowHeight=UITableViewAutomaticDimension;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XWHomeListCell class]) bundle:nil]forCellReuseIdentifier:@"cell1"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XWimagesCell class]) bundle:nil] forCellReuseIdentifier:@"cell2"];
    [self getNewsModel];

    [self.tableView setShowsVerticalScrollIndicator:NO];
  
    
}

-(NSDictionary *)dict
{
    if(_dict == nil){
    //获取plist路径
    NSString *path = [[NSBundle mainBundle] pathForResource:@"newsTitle" ofType:@"plist"];
    //从path路径提取数据
    _dict=[NSDictionary dictionaryWithContentsOfFile:path];
    }
    return _dict;
}
-(NSMutableArray *)focus
{
    if (_focus==nil) {
        _focus=[NSMutableArray array];
    }
    return _focus;
}
#pragma mark 网络请求数据
-(void)getNewsModel{
    __weak DataTableViewController *weakSelf=self;
    NSString *urlString=self.dict[self.type];
    [self.manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSArray class]]) {

        NSHTTPURLResponse *response=(NSHTTPURLResponse *)task.response;
        if (response.statusCode==200) {
            // NSLog(@"%@",responseObject);
            NSArray *responseArr=(NSArray *)responseObject;
            NSMutableArray *str=[NSMutableArray array];
            for (NSDictionary *dic in responseArr) {
                if ([dic[SStype] isEqualToString:@"list"]) {
                    NSArray *items = dic[SSitem];
                    for (NSDictionary *NewsItem in items) {
                        HomeListModel *model = [HomeListModel modelWithDictionary:NewsItem];
                        if ([model.type isMemberOfClass:[NSNull class]]) {
                            return;
                        }
                        if (![model.type isEqualToString:@"sports_live"] || [model.type isEqualToString:@"text_live"]) {
                            [str addObject:model];
                        }
                    }
                }
                if ([dic[SStype] isEqualToString:@"focus"]) {//获取头部focus轮播图的数据
                    NSArray *focus = dic[SSitem];
                    for (NSDictionary *focusDict in focus) {
                        HomeListModel *model = [HomeListModel modelWithDictionary:focusDict];
                        [weakSelf.focus addObject:model];
                    }
                }
            
                weakSelf.newsList=str;
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (weakSelf.focus.count>0) {
                        [weakSelf addScrollView];
                    }else{
                        weakSelf.tableView.contentInset=UIEdgeInsetsMake(-40, 0, 0, 0);
                    }
                    
                    [weakSelf.tableView reloadData];
                });
                
                
            }
        }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.newsList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     HomeListModel *model=self.newsList[indexPath.row];
    if (![model.type isEqualToString:@"slide"]){
        XWHomeListCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        cell.model=model;
        return cell;
    }else{
        XWimagesCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
        cell.model=model;
        return cell;
    
    }

}
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    HomeListModel *model=self.newsList[indexPath.row];
//    if (![model.type isEqualToString:@"slide"]) {
//        return 100;
//    }else{
//        return 180;
//    }
//}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeListModel *model=self.newsList[indexPath.row];
    if ([model.type isEqualToString:@"doc"]) {
        docDestialVC *vc=[docDestialVC new];
        vc.model=model;
        [self.navigationController presentViewController:vc animated:YES completion:^{
        }];
    }else{
    
    }
    
}
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    XWSectionHeaderView *sectionHeaderView = [XWSectionHeaderView sectionHeaderView:tableView];
//    
//    //获取当前cell所在的section对应的模型
//    //    sectionHeaderView.sectionModel=section;
//    
//    return sectionHeaderView;
//}


-(void)addScrollView{
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 44,ScrW,200)];
    self.tableView.tableHeaderView = bottomView;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0,ScrW,200) ];
    scrollView.backgroundColor = [UIColor grayColor];
    scrollView.pagingEnabled = YES;
    [bottomView addSubview:scrollView];
    scrollView.contentSize = CGSizeMake(ScrW * self.focus.count, 0);
    for (int i = 0; i < self.focus.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScrW * i, 0, CGRectGetWidth(scrollView.frame), CGRectGetHeight(scrollView.frame))];
        [scrollView addSubview:imageView];
        HomeListModel *focusModel = self.focus[i];
        NSURL *focusUrl = [NSURL URLWithString:focusModel.newsThumbnail];
        [imageView sd_setImageWithURL:focusUrl placeholderImage:nil];
        //给imageView添加标题和索引
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = [UIColor whiteColor];
        UILabel *numLabel = [[UILabel alloc] init];
        numLabel.textColor = [UIColor whiteColor];
        
        titleLabel.text = focusModel.title;
        NSString *currentNum = [NSString stringWithFormat:@"%d/%ld",i+1,self.focus.count];
        numLabel.text = currentNum;
        
        [imageView addSubview:titleLabel];
        [imageView addSubview:numLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@5);
            make.bottom.equalTo(@-5);
        }];
        [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@-10);
            make.bottom.equalTo(@-5);
            make.centerY.mas_equalTo(titleLabel);
        }];
    }
}

@end

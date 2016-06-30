//
//  ViewController.m
//  新闻客户端
//
//  Created by qingyun on 16/5/23.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "homeViewController.h"
#import "Masonry.h"
#import "TitleScrollView.h"
#import "DataTableViewController.h"
@interface homeViewController ()<UIPageViewControllerDataSource,UIPageViewControllerDelegate>
@property (nonatomic,strong)NSArray *titles;
@property (nonatomic,strong)TitleScrollView *titleSV;
@property (nonatomic,strong)UIPageViewController *pageViewControl;
@end

@implementation homeViewController
-(NSArray *)titles{
    if (_titles == nil) {
//        _titles = @[@"头条",@"推荐",@"军事",@"专题",@"数码",@"科技",@"体育",@"公益"@"时政",@"音乐",@"搞笑",@"读书",@"时尚",@"电影",@"女性",@"博客",@"娱乐",@"汽车",@"财经",@"娱乐"];
        _titles=@[@"头条",@"公益",@"时政",@"读书",@"时尚",@"电影",@"博客",@"娱乐",@"汽车",@"财经",];
    }
    return _titles;
}
-(TitleScrollView *)titleSV{
    if (_titleSV == nil) {
        _titleSV = [TitleScrollView titleScrollViewWithTitles:self.titles];
        __weak homeViewController *weakSelf = self;
        _titleSV.changContentVC=^(NSUInteger index){
            [weakSelf changContentViewControllerWithIndex:index];
        };
    }
    return _titleSV;
}
-(UIPageViewController *)pageViewControl{
    if (_pageViewControl == nil) {
        _pageViewControl = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        
        _pageViewControl.dataSource = self;
        _pageViewControl.delegate = self;
        
        DataTableViewController *contenVC = [self viewControllerWithIndex:0];
        [self.pageViewControl setViewControllers:@[contenVC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    }
    return _pageViewControl;
}
-(NSUInteger)indexOfViewController:(DataTableViewController *)vc{
    return [self.titles indexOfObject:vc.type];
}
-(void)changContentViewControllerWithIndex:(NSUInteger)index{
    //1.获取当前控制器的type在titles中的索引currentIndex
    DataTableViewController *currentDataVC = self.pageViewControl.viewControllers.firstObject;
    NSUInteger currentIndex = [self indexOfViewController:currentDataVC];
    //2.currentIndex == index,return;
    if (currentIndex == index) {
        return;
    }
    //3.根据index获取对应的内容控制器,然后设置内容控制器
    DataTableViewController *willChangedVC = [self viewControllerWithIndex:index];
    [self.pageViewControl setViewControllers:@[willChangedVC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    //设置滚动栏目视图
    self.navigationItem.titleView = self.titleSV;
    //设置_titleScrollView的约束
    [_titleSV mas_makeConstraints:^(MASConstraintMaker *make) {
         make.edges.equalTo(@0);
//        make.leading.mas_equalTo(40);
//        make.right.mas_equalTo(-40);
//        make.top.mas_equalTo(0);
//        make.bottom.mas_equalTo(0);
    }];
    [self addChildViewController:self.pageViewControl];
    [self.view addSubview:self.pageViewControl.view];
    self.navigationController.navigationBar.translucent = NO;
}
-(DataTableViewController *)viewControllerWithIndex:(NSUInteger)index{
    if (self.titles.count == 0 || index >self.titles.count) {
        return nil;
    }
    DataTableViewController *dataVC= [[DataTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    dataVC.type = self.titles[index];
    return  dataVC;
}
-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    //1.获取当前控制器的type在titles中的索引currentIndex
    NSUInteger currentIndex = [self indexOfViewController:(DataTableViewController *)viewController];
    //2.假如currentIndex == 0 返回nil; currentIndex != 0,currentIndex -= 1
    if (currentIndex == 0) {
        return nil;
    }
    currentIndex -= 1;
    //3.根据currentIndex获取上一个内容控制器
    return [self viewControllerWithIndex:currentIndex];
}

//下一个内容控制器
-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    //1.获取当前控制器的type在titles中的索引currentIndex
    NSUInteger currentIndex = [self indexOfViewController:(DataTableViewController *)viewController];
    //2.currentIndex++
    currentIndex++;
    //3.假如currentIndex >= self.titles.count,返回nil
    if (currentIndex >= self.titles.count) {
        return nil;
    }
    //4.根据currentIndex获取下一个内容控制器
    return [self viewControllerWithIndex:currentIndex];
}
#pragma mark -UIPageVi33333ewControllerDelegate
-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed{
    //1.获取当前控制器的type在titles中的索引currentIndex
    DataTableViewController *currentDataVC = self.pageViewControl.viewControllers.firstObject;
    NSUInteger currentIndex = [self indexOfViewController:currentDataVC];
    
    //2.获取上一个内容控制器的type在titles中的索引previousIndex
    NSUInteger previousIndex = [self indexOfViewController:(DataTableViewController *)previousViewControllers.firstObject];
    //3.判断currentIndex != previousIndex,设置_titleScrollView的currentIndex等于currentIndex
    if (currentIndex != previousIndex) {
        _titleSV.currentIndex = currentIndex;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

//
//  QYSectionHeaderView.m
//  微信
//
//  Created by qingyun on 16/5/18.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "XWSectionHeaderView.h"
#import "Masonry.h"
#import "Common.h"
@interface XWSectionHeaderView ()
@property (nonatomic, strong) UIScrollView *scrolView;
@property(nonatomic,strong)UIPageControl *pageControl;
@property(nonatomic,strong)NSTimer *timer;
@end
@implementation XWSectionHeaderView
static NSString *headerIdentifier = @"headerSection";
+(instancetype)sectionHeaderView:(UITableView *)tableView{
    XWSectionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerIdentifier];
    if (headerView == nil) {
        headerView = [[XWSectionHeaderView alloc] initWithReuseIdentifier:headerIdentifier];
    }
    return headerView;
}
//scrolView的懒加载
-(UIScrollView *)scrolView
{
    if (_scrolView==nil) {
        _scrolView=[[UIScrollView alloc]init];
        UIImageView *img1=[[UIImageView alloc]init];
        UIImageView *img2=[[UIImageView alloc]init];
        UIImageView *img3=[[UIImageView alloc]init];
        
        img1.image=[UIImage imageNamed:@"head1"];
        img2.image=[UIImage imageNamed:@"head2"];
        img3.image=[UIImage imageNamed:@"head3"];
        
        [_scrolView addSubview:img1];
        [_scrolView addSubview:img2];
        [_scrolView addSubview:img3];
        [img1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.height.mas_equalTo(172);
            make.width.mas_equalTo(ScrW);
        }];
        [img2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(img1.mas_right).with.offset(0);
            make.height.mas_equalTo(172);
           
            make.width.mas_equalTo(ScrW);
        }];
        [img3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(img2.mas_right).with.offset(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(172);
            
            make.width.mas_equalTo(ScrW);
        }];
//
        
        //滚动的时候,超出内容视图边界,是否有反弹效果
        _scrolView.bounces = YES;
        //假如是yes并且bounces是yes,甚至如果内容大小小于bounds的时候，允许垂直拖动
        _scrolView.alwaysBounceVertical =NO;
        
        
        //分页
        _scrolView.pagingEnabled = YES;
        
        //设置滚动条的显示
        _scrolView.showsVerticalScrollIndicator = NO;
        _scrolView.showsHorizontalScrollIndicator=NO;
        _scrolView.delegate=self;
        //滚动条样式
        _scrolView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
       
    }
    return _scrolView;
}
 //pageControl的懒加载
-(UIPageControl *)pageControl
{
    _pageControl=[[UIPageControl alloc]init];
    _pageControl.numberOfPages=3;
    _pageControl.currentPage=0;
    [_pageControl addTarget:self action:@selector(pageControlchange:) forControlEvents:UIControlEventValueChanged];
    return _pageControl;
}
//pageControl的点击事件
-(void)pageControlchange:(UIPageControl *)pagect
{
    CGPoint offset = CGPointMake(ScrW * pagect.currentPage, 0);
    
    [_scrolView setContentOffset:offset animated:YES];

}

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]){
        [self addSubview:self.scrolView];
        [self addSubview:self.pageControl];
        [self addTimer];
    }
    
    return  self;
        
}
//scrolView的代理方法
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //根据当前的偏移量来计算当前显示的页码
    NSInteger currentPage = scrollView.contentOffset.x /ScrW;
    //设置pageControl的当前页码
    _pageControl.currentPage = currentPage;
}
//设置定时器

-(void)addTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
}

-(void)nextPage
{
   
    if (_pageControl.currentPage ==2) {
        _pageControl.currentPage=0;
    }
    else
    {
        _pageControl.currentPage +=1;
    }
    self.scrolView.contentOffset = CGPointMake(ScrW * _pageControl.currentPage, 0);
}


//如果手动拖拽，则定时器失效
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [self.timer invalidate];
    self.timer = nil;
}

//结束拖拽时，重新开启定时器
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self addTimer];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    [_scrolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
  
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.and.bottom.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(100, 30));
        
    }];

}

@end

//
//  TitleScrollView.m
//  新闻客户端
//
//  Created by qingyun on 16/5/23.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "TitleScrollView.h"
#import "Masonry.h"
@implementation TitleScrollView

+(instancetype)titleScrollViewWithTitles:(NSArray *)titles
{
    TitleScrollView *titleSV=[TitleScrollView new];
    titleSV.showsHorizontalScrollIndicator=NO;
    
    for (int i = 0; i < titles.count; i++) {
        UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [titleSV addSubview:titleBtn];
        
        [titleBtn setTitleColor:[UIColor blackColor] forState:0];
        [titleBtn setTitle:titles[i] forState:0];
        titleBtn.titleLabel.font=[UIFont systemFontOfSize:17.0];
        
        titleBtn.tag = 1000 + i;
        [titleBtn addTarget:titleSV action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            [titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(10);
                make.centerY.mas_equalTo(0);
            }];
        }else if (i == titles.count - 1){
            [titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                UIButton *previousBtn = (UIButton *)[titleSV viewWithTag:titleBtn.tag - 1];
                make.left.equalTo(previousBtn.mas_right).with.offset(10);
                make.centerY.mas_equalTo(0);
                make.right.mas_equalTo(-10);
            }];
        }else{
            [titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                UIButton *previousBtn = (UIButton *)[titleSV viewWithTag:titleBtn.tag - 1];
                make.left.equalTo(previousBtn.mas_right).with.offset(20);
                make.centerY.mas_equalTo(0);
            }];

        }
    }
    titleSV.currentIndex = 0;
    return titleSV;
}
-(void)btnClick:(UIButton *)sender{
    if (self.currentIndex != sender.tag -1000) {
        self.currentIndex = sender.tag - 1000;
        
        if (_changContentVC) {
            _changContentVC(self.currentIndex);
        }
    }
}
-(void)setCurrentIndex:(NSUInteger)currentIndex
{
    UIButton *previousBtn = [self viewWithTag:1000 + _currentIndex];
    [previousBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    previousBtn.titleLabel.font = [UIFont systemFontOfSize:17.0];
    
    UIButton *willSelecteBtn = [self viewWithTag:1000 + currentIndex];
    [willSelecteBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    willSelecteBtn.titleLabel.font=[UIFont boldSystemFontOfSize:17.0];
    
    _currentIndex = currentIndex;
    
    CGFloat detalValue = willSelecteBtn.center.x - self.center.x;
    if (detalValue < 0) {
        detalValue = 0;
    }else if (detalValue > self.contentSize.width -self.frame.size.width){
        detalValue = self.contentSize.width - self.frame.size.width;
    }
    
    [self setContentOffset:CGPointMake(detalValue, 0) animated:YES];
    
}
@end

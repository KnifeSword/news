//
//  TitleScrollView.h
//  新闻客户端
//
//  Created by qingyun on 16/5/23.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TitleScrollView : UIScrollView
@property(nonatomic)NSUInteger currentIndex;
@property(nonatomic,copy)void(^changContentVC)(NSUInteger index);
+(instancetype)titleScrollViewWithTitles:(NSArray *)titles;
@end

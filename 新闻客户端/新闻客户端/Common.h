//
//  Common.h
//  新闻客户端
//
//  Created by qingyun on 16/5/24.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#ifndef Common_h
#define Common_h
#define ScrW [UIScreen mainScreen].bounds.size.width
#define ScrY [UIScreen mainScreen].bounds.size.height
static NSString * const SSthumbnail = @"thumbnail";     //缩略图
static NSString * const SSonline = @"online";           //是否在线(制定的新闻专题为0)
static NSString * const SStitle = @"title";             //新闻标题
static NSString * const SSsource = @"source";           //数据来源
static NSString * const SSupdateTime = @"updateTime";   //更新时间
static NSString * const SSNewsid = @"id";               //详情页面链接
static NSString * const SStype = @"type";               //新闻类型
static NSString * const SShasSurvey = @"hasSurvey";     //是否调查
static NSString * const SShasSlide = @"hasSlide";       //是否有幻灯片显示

static NSString * const SSslideStyle = @"style";        //幻灯片风格(在hasSlide下才有此属性) { type类型, images [ 三个图片链接 ] }
static NSString * const SSslideImages = @"images";      //
static NSString * const SScommentsUrl = @"commentsUrl"; //评论链接
//static NSString * const SScomments = @"comments";     //评论数
static NSString * const SScommentsall = @"commentsall"; //总评论数
//static NSString * const SSlink = @"link";             //链接   { type类型，url连接 }
static NSString * const SSitem = @"item";               //item种类
#endif /* Common_h */

//
//  XWHomeListCell.m
//  新闻客户端
//
//  Created by qingyun on 16/6/20.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "XWHomeListCell.h"
#import "UIImageView+WebCache.h"
@interface XWHomeListCell()
@property (weak, nonatomic) IBOutlet UIImageView *thumbnail;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *updateTime;
@property (weak, nonatomic) IBOutlet UILabel *comments;

@end
@implementation XWHomeListCell
-(void)setModel:(HomeListModel *)model
{
    _model = model;
    [_thumbnail sd_setImageWithURL:[NSURL URLWithString:model.newsThumbnail] placeholderImage:nil];
//    if ([model.newsThumbnail isEqualToString:@""]) {//只有标题没有缩略图
//    }
    _title.text = model.title;
    _title.textColor = [UIColor colorWithRed:0.01 green:0.01 blue:0.44 alpha:1];
    _comments.text = model.commentsall;
    _comments.textColor = [UIColor grayColor];
    if ([model.type isEqualToString:@"topic2"]) {
        _updateTime.text = @"专题";
        _updateTime.backgroundColor = [UIColor redColor];
        _updateTime.textColor = [UIColor whiteColor];
    }else{
        _updateTime.backgroundColor = [UIColor clearColor];
        _updateTime.text = model.updateTime;
        _updateTime.textColor = [UIColor grayColor];
    }
    
    _thumbnail.layer.borderWidth = 1;//给imageView添加一个浅灰色边框
    _thumbnail.layer.borderColor = [[UIColor lightGrayColor] CGColor];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

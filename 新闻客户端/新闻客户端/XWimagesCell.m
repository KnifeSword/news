//
//  XWimagesCell.m
//  新闻客户端
//
//  Created by qingyun on 16/6/21.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "XWimagesCell.h"
#import "UIImageView+WebCache.h"
@interface XWimagesCell()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *updateTime;
@property (weak, nonatomic) IBOutlet UILabel *comments;
@property (weak, nonatomic) IBOutlet UIImageView *firstImage;
@property (weak, nonatomic) IBOutlet UIImageView *secendImage;
@property (weak, nonatomic) IBOutlet UIImageView *thirdImage;

@end
@implementation XWimagesCell
-(void)setModel:(HomeListModel *)model
{
    _model = model;
    _title.text = model.title;
    _title.textColor = [UIColor colorWithRed:0.01 green:0.01 blue:0.44 alpha:1];
    _comments.text = model.commentsall;
    _comments.textColor = [UIColor grayColor];
    _updateTime.text = model.updateTime;
    _updateTime.textColor = [UIColor grayColor];
    [_firstImage sd_setImageWithURL:[NSURL URLWithString:model.slideImages[0]] placeholderImage:nil];
    [_secendImage sd_setImageWithURL:[NSURL URLWithString:model.slideImages[1]] placeholderImage:nil];
    [_thirdImage sd_setImageWithURL:[NSURL URLWithString:model.slideImages[2]] placeholderImage:nil];
    [self addBorderWidth:_firstImage];
    [self addBorderWidth:_secendImage];
    [self addBorderWidth:_thirdImage];
}
-(void)addBorderWidth:(UIImageView *)imageView{
    imageView.layer.borderWidth = 1;//给imageView添加一个浅灰色边框
    imageView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
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

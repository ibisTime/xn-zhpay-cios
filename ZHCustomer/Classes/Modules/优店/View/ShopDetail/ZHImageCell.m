//
//  ZHImageCell.m
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/23.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHImageCell.h"
#import "BPPhotoBrowser.h"
#import "TLHeader.h"


@interface ZHImageCell()

@property (nonatomic,strong) UIImageView *imageV;

@end

@implementation ZHImageCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.imageV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, 100)];
        self.imageV.clipsToBounds = YES;
        self.imageV.contentMode = UIViewContentModeScaleAspectFill;
        self.imageV.userInteractionEnabled = YES;
        [self addSubview:self.imageV];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scaleImg)];
        [self.imageV addGestureRecognizer:tap];
    }
    
    return self;
    
}

- (void)scaleImg {

    BPPhotoBrowser *photoB = [[BPPhotoBrowser alloc] initWithFrame:[UIScreen mainScreen].bounds];
    photoB.image = self.imageV.image;
    [UIView animateWithDuration:0.25 animations:^{
        
        [[UIApplication sharedApplication].keyWindow addSubview:photoB];
        
    }];

}


- (void)setUrl:(NSString *)url {

    _url = [url copy];
    
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:[url convertImageUrl]] placeholderImage:[UIImage imageNamed:@"img_paceholder"]];

}


- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageV.height = self.height;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

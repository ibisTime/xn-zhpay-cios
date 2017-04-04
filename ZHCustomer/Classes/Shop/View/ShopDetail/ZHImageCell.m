//
//  ZHImageCell.m
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/23.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHImageCell.h"

@interface ZHImageCell()

@property (nonatomic,strong) UIImageView *imageV;

@end

@implementation ZHImageCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.imageV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, 100)];
        self.imageV.clipsToBounds = YES;
        self.imageV.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.imageV];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
    
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

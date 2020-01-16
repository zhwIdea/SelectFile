//
//  JBCollectionViewCell.m
//  JBGuard
//
//  Created by 郑永康 on 2019/1/2.
//

#import "JBCollectionViewCell.h"
#define SCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@implementation JBCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imagev];
        [self addSubview:self.contentLab];
        [self addSubview:self.deleteButton];
    }
    return self;
}

- (UIImageView *)imagev{
    if (!_imagev) {
        self.imagev = [[UIImageView alloc] initWithFrame:self.bounds];
    }
    return _imagev;
}

- (UILabel *)contentLab{
    if (!_contentLab) {
        self.contentLab = [[UILabel alloc] initWithFrame:CGRectMake(5,(SCREEN_WIDTH - 50)/ 3 - 5 , (SCREEN_WIDTH - 50)/ 3 - 10, 15)];
        self.contentLab.font = [UIFont systemFontOfSize:13];
        self.contentLab.textColor = [UIColor blackColor];
        
    }
    return _contentLab;
}

- (UIButton *)deleteButton{
    if (!_deleteButton) {
        self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteButton.frame = CGRectMake(CGRectGetWidth(self.bounds)-20, 0, 20, 20);
        [_deleteButton setBackgroundImage:[UIImage imageNamed:@"deleteImage_Suggest"] forState:UIControlStateNormal];
    }
    return _deleteButton;
}



@end

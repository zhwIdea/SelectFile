//
//  JBCollectionViewCell.h
//  JBGuard
//
//  Created by 郑永康 on 2019/1/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JBCollectionViewCell : UICollectionViewCell

@property (nonatomic ,strong) UIImageView *imagev;
@property (nonatomic ,strong) UILabel *contentLab;
@property (nonatomic ,strong) UIButton *deleteButton;


@end

NS_ASSUME_NONNULL_END

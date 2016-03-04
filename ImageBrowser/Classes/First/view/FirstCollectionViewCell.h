//
//  FirstCollectionViewCell.h
//  ImageBrowser
//
//  Created by adu on 15/12/18.
//  Copyright © 2015年 adu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FirstCollectionViewCell;

@protocol FirstCollectionViewCellDelegate <NSObject>

- (NSArray *)whichCellOnClick;

- (void)downLoadImage:(UIImage *)image collectionViewCell:(FirstCollectionViewCell *)cell;

@end


@interface FirstCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *MainImageView;

@property (nonatomic, strong) NSString *urlStr;

- (void)startAnimationWithDelay:(CGFloat)delayTime;

@property (nonatomic, weak) id<FirstCollectionViewCellDelegate>delegate;

@end

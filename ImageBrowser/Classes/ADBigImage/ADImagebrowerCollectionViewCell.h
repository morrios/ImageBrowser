//
//  ADImagebrowerCollectionViewCell.h
//  ImageBrowser
//
//  Created by adu on 15/12/22.
//  Copyright © 2015年 adu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADBrowserImageView.h"
@class ADImagebrowerCollectionViewCell;

@protocol ADImagebrowerCollectionViewCellDelegate <NSObject>

- (void)imageOnOneTap:(ADImagebrowerCollectionViewCell *)cell;

@end

@interface ADImagebrowerCollectionViewCell : UICollectionViewCell<UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWidthConstrsint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeightConstraint;

@property (weak, nonatomic) IBOutlet ADBrowserImageView *imageV;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, copy) NSString *urlStr;
- (void)startAnimationWithDelay:(CGFloat)delayTime;

@property (nonatomic, weak)id <ADImagebrowerCollectionViewCellDelegate>delegate;

@end

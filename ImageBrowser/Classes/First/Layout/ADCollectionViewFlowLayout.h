//
//  ADCollectionViewFlowLayout.h
//  ImageBrowser
//
//  Created by adu on 15/12/21.
//  Copyright © 2015年 adu. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ADCollectionViewFlowLayoutDelegate <NSObject>

- (CGFloat)collectView:(UICollectionView *)collectView indexPathForPhotoAtIndexpath:(NSIndexPath *)path width:(CGFloat)width;
- (CGFloat)collectView:(UICollectionView *)collectView indexPathForAnnotationAtIndexpath:(NSIndexPath *)path width:(CGFloat)width;

@end


@interface PinterestLayoutAttributes : UICollectionViewLayoutAttributes

@property (nonatomic, assign) CGFloat photoHeight;

@end

@interface ADCollectionViewFlowLayout : UICollectionViewLayout

@property (nonatomic, weak)  id<ADCollectionViewFlowLayoutDelegate>delegate;

@end

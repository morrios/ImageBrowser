//
//  ADCollectionViewFlowLayout.m
//  ImageBrowser
//
//  Created by adu on 15/12/21.
//  Copyright © 2015年 adu. All rights reserved.
//

#import "ADCollectionViewFlowLayout.h"

@interface ADCollectionViewFlowLayout ()

@property (nonatomic, strong) NSMutableArray *cache;

@end

@implementation PinterestLayoutAttributes

- (id)copyWithZone:(NSZone *)zone{
    PinterestLayoutAttributes *copy = [super copyWithZone:zone];
    copy.photoHeight = self.photoHeight;
    return copy;
}

- (BOOL)isEqual:(id)object{
    PinterestLayoutAttributes *pinter = (PinterestLayoutAttributes *)object;
    
    if (pinter.photoHeight == self.photoHeight) {
        return [super isEqual:object];
    }
    return false;
}

@end


@implementation ADCollectionViewFlowLayout{

    NSInteger numOfColums;
    CGFloat cellPadding;
    CGFloat contentWidth;
    CGFloat contentHeight;
}


- (NSMutableArray *)cache{
    if (!_cache) {
        _cache = [NSMutableArray array];
    }
    return _cache;
}

- (void)setdata{
    UIEdgeInsets insets = self.collectionView.contentInset;
    contentHeight = 0.0;
    contentWidth = (CGRectGetWidth(self.collectionView.bounds) - (insets.right + insets.left));
    
    numOfColums = 2;
    cellPadding = 6.0;
    
}

- (void)prepareLayout{
//    _cache = self.layoutAttributesClass;
    if (self.cache.count == 0) {
        [self setdata];
        
        CGFloat columnWidth = contentWidth / numOfColums;
        
        NSMutableArray *xOffset = [NSMutableArray array];;
        NSMutableArray *yOffset = [NSMutableArray array];;
        
        for (int i = 0; i < numOfColums; i ++) {
            NSNumber *num = [NSNumber numberWithDouble:(i * columnWidth)];
            [xOffset addObject:num];
            
            NSNumber *y_num = [NSNumber numberWithInt:0];
            [yOffset addObject:y_num];
        }
        
        NSInteger column = 0;
        
        for (int i = 0; i < [self.collectionView numberOfItemsInSection:0]; i ++) {
            NSIndexPath *indexpath = [NSIndexPath indexPathForItem:i inSection:0];
            //GET FROM DELEGATE
            CGFloat width = columnWidth - cellPadding * 2;
            CGFloat photoHeight = [self.delegate collectView:self.collectionView indexPathForPhotoAtIndexpath:indexpath width:width];
            CGFloat annotationHeight = [self.delegate collectView:self.collectionView indexPathForAnnotationAtIndexpath:indexpath width:width];
            CGFloat height = cellPadding + photoHeight + annotationHeight + cellPadding;

            NSNumber *x_num = xOffset[column];
            NSNumber *y_num = yOffset[column];
            
            CGRect frame = CGRectMake([x_num floatValue], [y_num floatValue], columnWidth, height);
            CGRect insetFrame =CGRectInset(frame, cellPadding, cellPadding);
            
            //create an UICollectionViewLayoutItem with the frame and add it to the cache
            PinterestLayoutAttributes *pinter =[PinterestLayoutAttributes layoutAttributesForCellWithIndexPath:indexpath];
            pinter.photoHeight = photoHeight;
            pinter.frame = insetFrame;
            [self.cache addObject:pinter];
            
            contentHeight = MAX(contentHeight, CGRectGetMaxY(frame));
            
            NSNumber *y_temp = yOffset[column];
            yOffset[column] = [NSNumber numberWithFloat:([y_temp floatValue] + height)];
            
            column = column >= (numOfColums - 1) ? 0 : ++column;
        }
    }
}

- (CGSize)collectionViewContentSize{

    return CGSizeMake(contentWidth, contentHeight);
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (PinterestLayoutAttributes *attributes in self.cache) {
        if (CGRectIntersectsRect(attributes.frame, rect)) {
            [array addObject:attributes];
        }
    }

    NSLog(@"array.count = %ld", array.count);
    
    return array;
}



@end

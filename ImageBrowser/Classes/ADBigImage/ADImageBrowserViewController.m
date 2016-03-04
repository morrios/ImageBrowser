//
//  ADImageBrowserViewController.m
//  ImageBrowser
//
//  Created by adu on 15/12/21.
//  Copyright © 2015年 adu. All rights reserved.
//

#import "ADImageBrowserViewController.h"
#import "UIImage+ImageEffects.h"
#import "UIImageView+YYWebImage.h"
#import "ADImagebrowerCollectionViewCell.h"
#import "Masonry.h"

static CGFloat const duration = 0.2;
static NSString * const idForcell = @"idcell";


static CGFloat const cell_padding = 15;
#define screen_width CGRectGetWidth([UIScreen mainScreen].bounds)
#define screen_height CGRectGetHeight([UIScreen mainScreen].bounds)

@interface ADImageBrowserViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, ADImagebrowerCollectionViewCellDelegate>
@property (nonatomic, strong) UIImageView *OriginImage;

//views between self.view and image
@property (nonatomic, strong) UIView *snapShortview;
@property (nonatomic, strong) UIView *blurredSnapshortView;

@property (nonatomic, strong) UICollectionView *collection;
@property (nonatomic, strong) NSIndexPath *currentIndexPath;

@end

@implementation ADImageBrowserViewController{
    CGPoint     imageCenter;
    BOOL        isShowAnimation;
    CGSize      itemSize;
}

- (UIImageView *)OriginImage{
    if (!_OriginImage) {
        _OriginImage = [[UIImageView alloc] init];
    }
    return _OriginImage;
}

- (instancetype)initWithImage:(UIImageView *)imageV{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.OriginImage = imageV;
        CGFloat itemWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
        CGFloat itemHeight = CGRectGetHeight([UIScreen mainScreen].bounds);
        itemSize = CGSizeMake(itemWidth, itemHeight);
    }
    
    return self;
}

-(void)showWithViewControllter:(UIViewController *)viewController{
    self.view.userInteractionEnabled = NO;
    self.collection.alpha = 0;
    self.snapShortview = [self snapshortFromParentViewController:viewController];
    self.snapShortview.backgroundColor = [UIColor redColor];
    self.blurredSnapshortView = [self blurredSnapshortFromParentViewController:viewController];
    [self.snapShortview addSubview:self.blurredSnapshortView];
    self.blurredSnapshortView.alpha = 0.0;
    
    [self.view insertSubview:self.snapShortview atIndex:0];
    
    [viewController presentViewController:self animated:NO completion:^{
        __weak ADImageBrowserViewController *weakSelf = self;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            [UIView animateKeyframesWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState animations:^{
                
                weakSelf.blurredSnapshortView.alpha = 1.0;
                self.collection.alpha = 1.0;
                
            } completion:^(BOOL finished) {
                weakSelf.view.userInteractionEnabled = YES;
            }];
        });
    }];
}

- (void)dismiss{
    
    NSLog(@"dismiss");
    
    self.view.userInteractionEnabled = NO;
    
    CGFloat duration = 0.3;
    __weak ADImageBrowserViewController *weakSelf = self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateKeyframesWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState animations:^{
            
            weakSelf.blurredSnapshortView.alpha = 0.0;
            weakSelf.collection.alpha = 0.0;
            
        } completion:^(BOOL finished) {
            [weakSelf.blurredSnapshortView removeFromSuperview];
            [weakSelf.collection removeFromSuperview];
            [weakSelf.presentingViewController dismissViewControllerAnimated:NO completion:nil];
        }];
    });
}

#pragma mark - methods
- (UIView *)snapshortFromParentViewController:(UIViewController *)viewController{
    UIView *sanp = [viewController.view snapshotViewAfterScreenUpdates:YES];
    return sanp;
}
- (CGRect)resizedFrameForAutorotatingImgaeView:(CGSize)imageSize{
    CGRect frame = self.view.bounds;
    CGFloat screenWidth = frame.size.width;
    CGFloat screenHeight = frame.size.height;
    
    CGFloat targetHeight = screenHeight;
    CGFloat targetWidth = screenWidth;
    CGFloat nativeHeight = screenHeight;
    CGFloat nativeWidth = screenWidth;
    
    if (imageSize.width > 0 && imageSize.height > 0) {
        nativeHeight = (imageSize.height > 0) ? imageSize.height :screenHeight;
        nativeWidth = (imageSize.width > 0) ? imageSize.width :screenWidth;
    }
    
    if (nativeHeight > nativeWidth) {
        if (screenHeight / screenWidth < nativeHeight / nativeWidth) {
            targetWidth = screenHeight / (nativeHeight / nativeWidth);
        }else{
            targetHeight = screenWidth / (nativeWidth / nativeHeight);
        }
    }else{
        if (screenWidth / screenHeight < nativeWidth / nativeHeight) {
            targetHeight = screenWidth / (nativeWidth / nativeHeight);
        }else{
            targetWidth = screenHeight / (nativeHeight / nativeWidth);
        }
    }
    
    frame.size = CGSizeMake(targetWidth, targetHeight);
    frame.origin = CGPointMake(0, 0);
    return frame;
    
}
- (UIView *)blurredSnapshortFromParentViewController:(UIViewController *)viewController{
    UIViewController *presentVIewController = viewController.view.window.rootViewController;

    while (presentVIewController.presentedViewController) {
        presentVIewController = presentVIewController.presentedViewController;
    }
    
    //draw the presentViewcontroller'view into a context
    
    CGFloat outerBleed = 20.0f;
    CGFloat performanceDownScalingFactor = 0.25;
    CGFloat scaleOuterBleed = outerBleed * performanceDownScalingFactor;
    CGRect contextBounds = CGRectInset(presentVIewController.view.bounds, - outerBleed, - outerBleed);
    CGRect scaledBounds = contextBounds;
    scaledBounds.size.width *= performanceDownScalingFactor;
    scaledBounds.size.height *= performanceDownScalingFactor;
    CGRect scaleDrawingArea = presentVIewController.view.bounds;
    scaleDrawingArea.size.width *= performanceDownScalingFactor;
    scaleDrawingArea.size.height *= performanceDownScalingFactor;
    
    UIGraphicsBeginImageContextWithOptions(scaledBounds.size, YES, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextConcatCTM(context, CGAffineTransformMakeTranslation(scaleOuterBleed, scaleOuterBleed));
    [presentVIewController.view drawViewHierarchyInRect:scaleDrawingArea afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
//    if (image) {
//        NSString *path =  @"/Users/adu/Desktop/image.png";
//        [UIImagePNGRepresentation(image) writeToFile: path    atomically:YES]; // 保存成功会返回YES
//    }
    UIGraphicsEndImageContext();

    
    UIImage *blurredImage = [image applyDarkEffect];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:contextBounds];
    imageView.image = blurredImage;
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    imageView.backgroundColor = [UIColor blackColor];
    
    return imageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];


    
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
}

- (void)createUI{
    
    
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
    [flowlayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    self.collection = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowlayout];
    self.collection.collectionViewLayout = flowlayout;
    self.collection.dataSource = self;
    self.collection.delegate = self;
    self.collection.backgroundColor = [UIColor clearColor];
    [self.collection registerNib:[UINib nibWithNibName:@"ADImagebrowerCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:idForcell];
    self.collection.pagingEnabled = YES;
    [self.collection setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.collection.decelerationRate = UIScrollViewDecelerationRateFast;
    [self.view addSubview:self.collection];

    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.index inSection:0];
    self.currentIndexPath = indexPath;
    [self.collection scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

#pragma mark - delegate && datasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ADImagebrowerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:idForcell forIndexPath:indexPath];
    cell.delegate = self;
    cell.urlStr = self.imageArray[indexPath.row];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return itemSize;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    static CGFloat initialDelay = 0.2f;
    static CGFloat stutter = 0.06f;
    
    if (isShowAnimation) {
        ADImagebrowerCollectionViewCell *cardCell = (ADImagebrowerCollectionViewCell *)cell;
        [cardCell startAnimationWithDelay:initialDelay + ((indexPath.row) * stutter)];

    }
}

//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
//    if (!decelerate) {
//        int currentIndex = roundf(scrollView.contentOffset.x/(screen_width + cell_padding));
//        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:currentIndex inSection:0];
//        [self.collection scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
//    }
//
//}
//
//- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
//
//    [self scrollToNextImageWith:scrollView];
//
//}

- (void)scrollToNextImageWith:(UIScrollView *)scrollView{
    CGPoint velocity = [scrollView.panGestureRecognizer velocityInView:self.view];
    
    CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y));
    
    CGFloat slideMult = magnitude / 200;
    
    NSLog(@"velocity = %@", NSStringFromCGPoint(velocity));
    
    NSLog(@"magnitude: %f, slideMult: %f", magnitude, slideMult);
    
    int currentIndex = roundf(scrollView.contentOffset.x/(screen_width + cell_padding));
    
    if (currentIndex == 0) {if (velocity.x > 0) return;    }
    if (currentIndex == self.imageArray.count) {if (velocity.x < 0) return;    }
    
    
    currentIndex = (int)self.currentIndexPath.item;
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:currentIndex inSection:0];
    if (velocity.x > 0) {//to right
        nextIndexPath = [NSIndexPath indexPathForItem:(self.currentIndexPath.item - 1) inSection:0];
        currentIndex = currentIndex - 1;
    }else{//to left
        nextIndexPath = [NSIndexPath indexPathForItem:(self.currentIndexPath.item + 1) inSection:0];
        currentIndex = currentIndex + 1;
    }
    
//    [self.collection scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];

    CGRect frame = CGRectMake(currentIndex * (screen_width + cell_padding), 0, screen_width, screen_height);
    CGPoint toPoint = CGPointMake(currentIndex * (screen_width + cell_padding), 0);
    
    [UIView animateWithDuration:0.25 animations:^{
        [scrollView setContentOffset:toPoint animated:NO];
    }];
    
    
    self.currentIndexPath = nextIndexPath;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissFromGestureWithSpeed:(CGPoint)velocity{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [UIView animateWithDuration:0.3 animations:^{
        } completion:^(BOOL finished) {
            [self dismissViewControllerAnimated:NO completion:nil];
        }];
    });
}

- (BOOL)isSpeedReachedTheCritical:(CGPoint)point{
    BOOL isReached = NO;
    CGFloat tippingSpeed = 800;
    
    if ((fabs(point.y) > tippingSpeed)) {
        isReached = YES;
    }
    
    return isReached;
}

#pragma ADImagebrowerCollectionViewCell
- (void)imageOnOneTap:(ADImagebrowerCollectionViewCell *)cell{
    [self dismiss];
}

@end

//
//  FirstViewController.m
//  ImageBrowser
//
//  Created by adu on 15/12/18.
//  Copyright © 2015年 adu. All rights reserved.
//

#import "FirstViewController.h"
#import "FirstCollectionViewCell.h"
#import "ADCollectionViewFlowLayout.h"

static NSString *const kCourseListCellID = @"kCourseListCellID";

@interface FirstViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, ADCollectionViewFlowLayoutDelegate, FirstCollectionViewCellDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *datasArray;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowlayout;
@property (nonatomic, strong) NSMutableArray *PhotoHeightArray;

@end


#warning 一、根据图片的大小调整瀑布流 二、图片播放器 三、第一次出现的动画

@implementation FirstViewController{
    CGSize itemSize;
    BOOL isShowAnimation;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.collectionView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isShowAnimation = YES;
    
    NSLog(@"FIRST%ld", self.datasArray.count);

    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    CGFloat itemWidth = (CGRectGetWidth([UIScreen mainScreen].bounds) - 30) * 0.5;
    itemSize = CGSizeMake(itemWidth, 200);
    
    [self setUI];
    
}

- (void)setUI{
    ADCollectionViewFlowLayout *flowLayout = [[ADCollectionViewFlowLayout alloc] init];
    flowLayout.delegate = self;
    
    self.collectionView.collectionViewLayout = flowLayout;
}

#pragma mark - ADCollectionViewFlowLayoutDelegate
- (CGFloat)collectView:(UICollectionView *)collectView indexPath:(NSIndexPath *)path width:(CGFloat)width{
    return 50;
}

#pragma mark - CollectionView Delegate && DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.datasArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FirstCollectionViewCell *collectioncell = [collectionView dequeueReusableCellWithReuseIdentifier:kCourseListCellID forIndexPath:indexPath];
    collectioncell.urlStr = self.datasArray[indexPath.row];
    collectioncell.delegate = self;
    return collectioncell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static CGFloat initialDelay = 0.2f;
    static CGFloat stutter = 0.06f;
        
    if (isShowAnimation) {
        
//        FirstCollectionViewCell *cardCell = (FirstCollectionViewCell *)cell;
//        [cardCell startAnimationWithDelay:(initialDelay + indexPath.row * stutter)];
//        
//        if (indexPath.row == 3) {
//            isShowAnimation = NO;
//        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"collectionView");
    return itemSize;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

- (NSArray *)whichCellOnClick{
    return self.datasArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (NSArray *)datasArray{
    if (!_datasArray) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"images.plist"ofType:nil];
        _datasArray = [NSArray arrayWithContentsOfFile:path];
    }
    return _datasArray;
}

- (NSMutableArray *)PhotoHeightArray{
    if (!_PhotoHeightArray) {
        _PhotoHeightArray = [NSMutableArray array];
        for (int i = 0; i< self.datasArray.count; i++) {
            [_PhotoHeightArray addObject:[NSNumber numberWithFloat:100.0]];
        }
    }
    return _PhotoHeightArray;
}
#pragma mark - downloadImage
- (void)downLoadImage:(UIImage *)image collectionViewCell:(FirstCollectionViewCell *)cell{
    CGSize size = image.size;
    UIEdgeInsets insets = self.collectionView.contentInset;
    CGFloat contentWidth = (CGRectGetWidth(self.collectionView.bounds) - (insets.right + insets.left));
    
    CGFloat contentHeight = (size.height / size.width) * contentWidth;
    
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    
//    NSLog(@"0  - %@", indexPath);
//    NSLog(@"1  - %ld", indexPath.item);
//    NSLog(@"2  - %f", contentHeight);
    
    if (indexPath.row > 0) {
        self.PhotoHeightArray[indexPath.item] = [NSNumber numberWithFloat:contentHeight];
    }
    
}

#pragma mark - flowLayoutDelegate
- (CGFloat)collectView:(UICollectionView *)collectView indexPathForPhotoAtIndexpath:(NSIndexPath *)path width:(CGFloat)width{
    
    NSNumber *num = self.PhotoHeightArray[path.item];
    CGFloat fl = [num floatValue];
    
    return fl;
}
- (CGFloat)collectView:(UICollectionView *)collectView indexPathForAnnotationAtIndexpath:(NSIndexPath *)path width:(CGFloat)width{
    return 100;
}

@end

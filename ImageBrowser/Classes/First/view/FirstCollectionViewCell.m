//
//  FirstCollectionViewCell.m
//  ImageBrowser
//
//  Created by adu on 15/12/18.
//  Copyright © 2015年 adu. All rights reserved.
//

#import "FirstCollectionViewCell.h"
#import "UIImageView+YYWebImage.h"
#import "ADImageBrowserViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation FirstCollectionViewCell

- (void)awakeFromNib{
    self.layer.cornerRadius = 4;
    self.layer.masksToBounds = YES;
    
    self.MainImageView.userInteractionEnabled = YES;
//    self.MainImageView.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageOneTap:)];
    [self.MainImageView addGestureRecognizer:tap];
}

- (void)imageOneTap:(UITapGestureRecognizer *)tap{

    ADImageBrowserViewController *imageBrowser = [[ADImageBrowserViewController alloc] initWithImage:self.MainImageView];
    NSArray *images =[self.delegate whichCellOnClick];
    NSInteger index = 0;
    for (NSString *urlStr in images) {
        if ([urlStr isEqualToString:self.urlStr]) {
            break;
        }else{
            ++index;
        }
    }
    
    imageBrowser.imageArray = images;
    imageBrowser.index = index;
    
    [imageBrowser showWithViewControllter:[self getViewController]];
    
}

- (UIViewController *)getViewController{
    for (UIView *next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

#pragma mark - Animation Method

- (void)startAnimationWithDelay:(CGFloat)delayTime
{
    self.transform =  CGAffineTransformMakeTranslation(0, -CGRectGetHeight([UIScreen mainScreen].bounds)*1.5);
    [UIView animateWithDuration:1. delay:delayTime usingSpringWithDamping:0.6 initialSpringVelocity:0 options:0 animations:^{
        self.transform = CGAffineTransformIdentity;
        NSLog(@"startAnimationWithDelay");
    } completion:NULL];
}

- (void)setUrlStr:(NSString *)urlStr{
    _urlStr = urlStr;
    //#DCDCDC
    self.backgroundColor = [UIColor whiteColor];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    __weak FirstCollectionViewCell *weakself = self;
    
    [_MainImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"empty_failed"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [weakself.delegate downLoadImage:image collectionViewCell:self];
        
        
    }];
    
}



@end

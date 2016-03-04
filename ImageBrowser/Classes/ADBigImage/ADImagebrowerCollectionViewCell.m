//
//  ADImagebrowerCollectionViewCell.m
//  ImageBrowser
//
//  Created by adu on 15/12/22.
//  Copyright © 2015年 adu. All rights reserved.
//

#import "ADImagebrowerCollectionViewCell.h"
#import <YYWebImage/UIImageView+YYWebImage.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIView+ADimageBrower.h"

@implementation ADImagebrowerCollectionViewCell{
    CGPoint     imageCenter;
}

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    self.imageV.backgroundColor = [UIColor clearColor];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageOneTap:)];
    UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(imageLongGesture:)];
    
    self.imageV.userInteractionEnabled = YES;
    [self.imageV addGestureRecognizer:tap];
    [self.imageV addGestureRecognizer:longpress];
    [tap requireGestureRecognizerToFail:longpress];
    
}

#pragma mark - GestureRecognizer
- (void)imageOneTap:(UITapGestureRecognizer *)sender{
    NSLog(@"imageOneTap");
    if ([self.delegate respondsToSelector:@selector(imageOnOneTap:)]) {
        [self.delegate imageOnOneTap:self];
    }
}
- (void)imageOnPan:(UIPanGestureRecognizer *)sender{}
- (void)imageLongGesture:(UILongPressGestureRecognizer *)sender{
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"保存到相册" otherButtonTitles:@"分享", nil];
        [sheet showInView:self];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"您点击了第%ld个按钮", buttonIndex);
    
    if (buttonIndex == 0) {
        UIImageWriteToSavedPhotosAlbum(self.imageV.image, self, @selector(saveImageToPhotos:withError:contentInfo:), nil);
    }
    
}

- (void)saveImageToPhotos:(UIImage *)image withError:(NSError *)error contentInfo:(void *)contextInfo{
    NSString *str = @"";
    if (!error) {
        str = @"保存成功";
    }else{
        str = @"保存失败";
    }
    
    NSLog(@"%@", str);
    
}

- (void)CellPanGesture:(UIPanGestureRecognizer *)sender{
    CGPoint center = sender.view.center;
    CGPoint translation = [sender translationInView:sender.view];
    
    if ((translation.x < 100.0) && (translation.x > -100.0)) {
        if (sender.state == UIGestureRecognizerStateBegan) {
            self.center = imageCenter;
        }else if (sender.state == UIGestureRecognizerStateChanged){
            
            if (translation.y != 0) {
                self.center = CGPointMake(imageCenter.x, imageCenter.y + translation.y);
            }
            
        }else{
            self.center = imageCenter;
        }
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
}

- (void)setUrlStr:(NSString *)urlStr{
    _urlStr = urlStr;
    self.imageWidthConstrsint.constant = self.frame.size.width;

    if ([urlStr hasPrefix:@"http"]) {
        [self.imageV sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"empty_failed"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            NSLog(@"image.size = %@", NSStringFromCGSize(image.size));
            [self setImageSize:image];
        }];
    }else{
        self.imageV.image = [UIImage imageNamed:urlStr];
    }
    
    
}




- (void)setImageSize:(UIImage *)image{
    CGFloat ADWidth  = [UIScreen mainScreen].bounds.size.width;
    CGFloat ADHeight = [UIScreen mainScreen].bounds.size.height;
    
    
    CGFloat imageHeight = (image.size.height / image.size.width) * ADWidth;
    
    if (image.size.width == 0) {
        self.imageV.contentMode = UIViewContentModeScaleAspectFit;
        self.imageHeightConstraint.constant = self.frame.size.height;
    }else{
        if (imageHeight > ADHeight) {
            self.imageV.contentMode = UIViewContentModeScaleToFill;
            self.imageHeightConstraint.constant = imageHeight;
        }else{
            self.imageV.contentMode = UIViewContentModeScaleAspectFit;
            self.imageHeightConstraint.constant = self.frame.size.height;
        }
    }
}
- (void)startAnimationWithDelay:(CGFloat)delayTime
{
    self.transform =  CGAffineTransformMakeTranslation(0, -CGRectGetHeight([UIScreen mainScreen].bounds)*1.5);
    [UIView animateWithDuration:1. delay:delayTime usingSpringWithDamping:0.6 initialSpringVelocity:0 options:0 animations:^{
        self.transform = CGAffineTransformIdentity;
        NSLog(@"startAnimationWithDelay");
    } completion:NULL];
}
@end

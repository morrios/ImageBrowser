//
//  ADBrowserImageView.m
//  ImageBrowser
//
//  Created by adu on 15/12/24.
//  Copyright © 2015年 adu. All rights reserved.
//

#import "ADBrowserImageView.h"
#import "UIView+ADimageBrower.h"

@implementation ADBrowserImageView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
    }

    return self;
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
    }

    return self;
}



- (void)imageHasChanged{}

- (void)layoutSubviews{
    [super layoutSubviews];
    
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"imagePath"]) {
        NSLog(@"图片改变");
    }
}

@end

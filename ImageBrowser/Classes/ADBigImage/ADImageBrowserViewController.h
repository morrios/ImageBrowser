//
//  ADImageBrowserViewController.h
//  ImageBrowser
//
//  Created by adu on 15/12/21.
//  Copyright © 2015年 adu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface ADImageBrowserViewController : UIViewController

- (instancetype)initWithImage:(UIImageView *)imageV;

- (void)showWithViewControllter:(UIViewController *)viewController;

@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, assign) NSInteger index;

@end

//
//  MovieDetailsViewController.h
//  RottenTomatoes
//
//  Created by  Minett on 10/20/15.
//  Copyright © 2015  Minett. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieDetailsViewController : UIViewController
@property (strong, nonatomic) NSString *movieTitle;
@property (strong, nonatomic) NSString *synopsisText;
@property (strong, nonatomic) NSURL *imageUrl;

- (instancetype)initWithTitle:(NSString *)title synopsis:(NSString *)synopsis imageUrl:(NSURL *)imageUrl;
@end

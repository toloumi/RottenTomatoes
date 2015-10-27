//
//  MoviesTableViewCell.h
//  RottenTomatoes
//
//  Created by  Minett on 10/20/15.
//  Copyright © 2015  Minett. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoviesTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@end

//
//  MovieDetailsViewController.m
//  RottenTomatoes
//
//  Created by  Minett on 10/27/15.
//  Copyright © 2015  Minett. All rights reserved.
//

#import "MovieDetailsViewController.h"
#import <UIImageView+AFNetworking.h>
#import <JGProgressHUD/JGProgressHUD.h>

@interface MovieDetailsViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UITextView *synopsisTextView;

@end

@implementation MovieDetailsViewController

- (instancetype)initWithTitle:(NSString *)title synopsis:(NSString *)synopsis imageUrl:(NSURL *)imageUrl {
    self = [super init];
    if (self) {
        self.title = title;
        _movieTitle = title;
        _synopsisText = synopsis;
        _imageUrl = imageUrl;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.imageView setImageWithURL:self.imageUrl];
    self.synopsisTextView.text = self.synopsisText;
    
    // Do any additional setup after loading the view.
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

@end

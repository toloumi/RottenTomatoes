//
//  ViewController.m
//  RottenTomatoes
//
//  Created by  Minett on 10/20/15.
//  Copyright © 2015  Minett. All rights reserved.
//

#import "MoviesViewController.h"
#import "MoviesTableViewCell.h"
#import "MovieDetailsViewController.h"
#import <UIImageView+AFNetworking.h>
#import <JGProgressHUD/JGProgressHUD.h>

NSString *const kCellIdentifier = @"CellId";

@interface MoviesViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *movies;
@property (strong, nonatomic) JGProgressHUD *progressHud;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) IBOutlet UILabel *errorMessageLabel;

@end

@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(onRefresh:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl.backgroundColor = self.tableView.backgroundColor;
    [self.tableView addSubview:self.refreshControl];
    
    self.errorMessageLabel.hidden = YES;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.progressHud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    [self fetchMovies];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self fetchMovies];
}

- (void)onRefresh:(id)sender {
    [self.tableView reloadData];
    [(UIRefreshControl *)sender endRefreshing];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MoviesTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (cell) {
        cell.titleLabel.text = self.movies[indexPath.row][@"title"];
        cell.synopsisLabel.text = self.movies[indexPath.row][@"synopsis"];
        
        NSURL *thumbUrl = [self hackedUrlFromUrlString:self.movies[indexPath.row][@"posters"][@"thumbnail"]];
        [self setupMovieThumbFetchForUrl:thumbUrl andCell:cell];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"MoviesDetailsSeque" sender:indexPath];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = (NSIndexPath *)sender;
    NSString *title = self.movies[indexPath.row][@"title"];
    NSString *synopsis = self.movies[indexPath.row][@"synopsis"];
    NSURL *imageUrl = [self hackedUrlFromUrlString:self.movies[indexPath.row][@"posters"][@"detailed"]];
    MovieDetailsViewController *detailsVc = (MovieDetailsViewController *)segue.destinationViewController;
    detailsVc.title = title;
    detailsVc.synopsisText = synopsis;
    detailsVc.imageUrl = imageUrl;
}

- (void)setupMovieThumbFetchForUrl:(NSURL *)thumbUrl andCell:(MoviesTableViewCell *)cell {
    NSURLRequest *thumbRequest = [NSURLRequest requestWithURL:thumbUrl];
    [cell.imageView setImageWithURL:thumbUrl];
    
    __weak MoviesTableViewCell *weakCell = cell;
    [cell.imageView setImageWithURLRequest:thumbRequest
                          placeholderImage:nil
                                   success:^(NSURLRequest *request,
                                             NSHTTPURLResponse *response,
                                             UIImage *image) {
                                       __strong MoviesTableViewCell *strongCell = weakCell;
                                       strongCell.imageView.image = image;
                                       [strongCell layoutSubviews];
                                       //[self endLoadingSpinnerWithError:NO];
                                   }
                                   failure:^(NSURLRequest *request,
                                             NSHTTPURLResponse *response,
                                             NSError *error) {
                                       //[self endLoadingSpinnerWithError:YES];
                                   }];
}

- (void)fetchMovies {
    NSString *urlString = @"https://gist.githubusercontent.com/timothy1ee/d1778ca5b944ed974db0/raw/489d812c7ceeec0ac15ab77bf7c47849f2d1eb2b/gistfile1.json";
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLSession *session =
    [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                  delegate:nil
                             delegateQueue:[NSOperationQueue mainQueue]];
    
    [self startLoadingSpinnerOnView:self.view];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData * _Nullable data,
                                                                NSURLResponse * _Nullable response,
                                                                NSError * _Nullable error) {
                                                if (!error) {
                                                    NSError *jsonError = nil;
                                                    NSDictionary *responseDictionary =
                                                    [NSJSONSerialization JSONObjectWithData:data
                                                                                    options:kNilOptions
                                                                                      error:&jsonError];
                                                    self.movies = responseDictionary[@"movies"];
                                                    [self.tableView reloadData];
                                                    [self endLoadingSpinnerWithError:NO];
                                                } else {
                                                    NSLog(@"An error occurred: %@", error.description);
                                                    [self endLoadingSpinnerWithError:YES];
                                                }
                                                
                                            }];
    [task resume];
}

- (NSURL *)hackedUrlFromUrlString:(NSString *)rawUrl {
    NSRange range = [rawUrl rangeOfString:@".*cloudfront.net/" options:NSRegularExpressionSearch];
    NSString *newUrlString = [rawUrl stringByReplacingCharactersInRange:range withString:@"https://content6.flixster.com/"];
    return [NSURL URLWithString:newUrlString];
}

- (void)startLoadingSpinnerOnView:(UIView *)spinnerParentView {
    self.progressHud.textLabel.text = @"Loading...";
    [self.progressHud showInView:spinnerParentView];
}

- (void)endLoadingSpinnerWithError:(BOOL)error {
    if (error) {
        self.progressHud.textLabel.text = @"Error Durring Remote Communication. Please Try Again Later.";
        self.progressHud.indicatorView = [[JGProgressHUDErrorIndicatorView alloc] init];
        [self.progressHud dismissAfterDelay:3.0];
        self.errorMessageLabel.hidden = NO;
    } else {
        [self.progressHud dismissAnimated:YES];
        self.errorMessageLabel.hidden = YES;
    }
}

@end

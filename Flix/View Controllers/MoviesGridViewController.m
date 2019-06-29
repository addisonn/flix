//
//  MoviesGridViewController.m
//  Flix
//
//  Created by addisonz on 6/27/19.
//  Copyright © 2019 addisonz. All rights reserved.
//

#import "MoviesGridViewController.h"
#import "MBProgressHUD.h"
#import "MovieCollectionCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailsViewController.h"

@interface MoviesGridViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong) NSArray *movies;
@property (nonatomic, strong) NSArray *filteredMovies;

// third party loader
@property (nonatomic, strong) MBProgressHUD *hud;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UISearchBar *gridSearchBar;

@end

@implementation MoviesGridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.gridSearchBar.delegate = self;

    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.label.text = @"Loading";
    
    [self fetchMovies];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout*) self.collectionView.collectionViewLayout;
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 5;
    CGFloat posterPerLine = 2;
    CGFloat itemWidth = (self.collectionView.frame.size.width - layout.minimumInteritemSpacing * (posterPerLine - 1)) / posterPerLine;
    CGFloat itemHeight = itemWidth * 1.5;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
}

// making network request to the movie API, currently returning the first 20 movies from currentlyPlaying

- (void)fetchMovies {
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/297762/similar?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
            
            // set up network alert
            UIAlertController *networkAlert = [UIAlertController alertControllerWithTitle:@"Cannot Get Movies"
                                                                                  message:@"The internet connection seems to be offline."
                                                                preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Try Again"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                                 [self fetchMovies];
                                                             }];
            [networkAlert addAction:okAction];
            [self presentViewController:networkAlert animated:YES completion:^{
                // optional code for what happens after the alert controller has finished presenting
            }];
            
        }
        else {
            // hide the loading bar before displaying
            [self.hud hideAnimated:YES];
            // TODO: Get the array of movies
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            self.movies = dataDictionary[@"results"];
            self.filteredMovies = self.movies;
            
            [self.collectionView reloadData];
            
        }
    }];
    [task resume];
}


- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MovieCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MovieCollectionCell" forIndexPath:indexPath];
    NSDictionary *movie = self.filteredMovies[indexPath.item];
    
    // set up URL
    NSString *posterURLString = movie[@"poster_path"];

    NSString *smallURLString = @"https://image.tmdb.org/t/p/w45";
    NSString *smallPosterString = [smallURLString stringByAppendingString:posterURLString];
    NSURL *smallPosterURL = [NSURL URLWithString:smallPosterString];

    NSString *bigURLString = @"https://image.tmdb.org/t/p/original";
    NSString *bigPosterString = [bigURLString stringByAppendingString:posterURLString];
    NSURL *bigPosterURL = [NSURL URLWithString:bigPosterString];
    
    NSURLRequest *requestSmall = [NSURLRequest requestWithURL:smallPosterURL];
    NSURLRequest *requestLarge = [NSURLRequest requestWithURL:bigPosterURL];
    
    [cell.posterView setImageWithURLRequest:requestSmall placeholderImage:nil
                                    success:^(NSURLRequest *imageRequest, NSHTTPURLResponse *imageResponse, UIImage *smallImage) {
                                        
                                        cell.posterView.alpha = 0.0;
                                        cell.posterView.image = smallImage;
                                        
                                        [UIView animateWithDuration:0.3
                                                         animations:^{
                                                             cell.posterView.alpha = 1.0;
                                                         } completion:^(BOOL finished) {
                                                             // The AFNetworking ImageView Category only allows one request to be sent at a time
                                                             // per ImageView. This code must be in the completion block.
                                                             [cell.posterView setImageWithURLRequest:requestLarge
                                                                                       placeholderImage:smallImage
                                                                                                success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage * largeImage) {
                                                                                                    cell.posterView.image = largeImage;
                                                                                                }
                                                                                                failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                                                    // do something for the failure condition of the large image request
                                                                                                    // possibly setting the ImageView's image to a default image
                                                                                                }];
                                                         }];
                                    }
                                    failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                        // do something for the failure condition
                                        // possibly try to get the large image
                                    }];
    
//    setting cell image with no animation
//     cell.posterView.image = nil;
//    [cell.posterView setImageWithURL:posterURL];
    
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.filteredMovies.count;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (searchText.length != 0) {
        
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *evaluatedObject, NSDictionary *bindings) {
            return [evaluatedObject[@"title"] containsString:searchText];
        }];
        self.filteredMovies = [self.movies filteredArrayUsingPredicate:predicate];
    }
    else {
        self.filteredMovies = self.movies;
    }
    
    [self.collectionView reloadData];
    
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.gridSearchBar.showsCancelButton = YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.gridSearchBar.showsCancelButton = NO;
    self.gridSearchBar.text = @"";
    [self.gridSearchBar resignFirstResponder];
    self.filteredMovies = self.movies;
    [self.collectionView reloadData];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UICollectionViewCell *tappedCell = sender;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:tappedCell];
    NSDictionary *movie = self.filteredMovies[indexPath.row];
    
    // creating instance of the details class and designating destination page
    DetailsViewController *detailsViewController = [segue destinationViewController];
    detailsViewController.movie = movie;
}

@end

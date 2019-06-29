//
//  TrailerViewController.m
//  Flix
//
//  Created by addisonz on 6/28/19.
//  Copyright © 2019 addisonz. All rights reserved.
//

#import "TrailerViewController.h"
#import <WebKit/WebKit.h>
#import "MBProgressHUD.h"

@interface TrailerViewController ()
@property (weak, nonatomic) IBOutlet WKWebView *trailerWebView;
@property (strong, nonatomic) NSArray *movieVideoes;
@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation TrailerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Third party loader added
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.label.text = @"Loading";
    
    NSString *movieId = [NSString stringWithFormat:@"%@", self.selectedMovie[@"id"]];
    NSString *baseURLString = @"https://api.themoviedb.org/3/movie/";
    NSString *endURLString = @"/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US";
    NSString *URLcombine = [baseURLString stringByAppendingString:movieId];

    NSString *searchURL = [URLcombine stringByAppendingString:endURLString];
    
    // Convert the url String to a NSURL object.
    NSURL *movieSearchURL = [NSURL URLWithString:searchURL];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:movieSearchURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            
        }
        else {
            [self.hud hideAnimated:YES];
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            self.movieVideoes = dataDictionary[@"results"];
            NSDictionary *movieVideo = self.movieVideoes[0];
            NSString *baseMovieURL = @"https://www.youtube.com/watch?v=";
            NSString *movieVidURL = [baseMovieURL stringByAppendingString:movieVideo[@"key"]];
            NSURL *vidURL = [NSURL URLWithString:movieVidURL];
            // Place the URL in a URL Request.
            NSURLRequest *request = [NSURLRequest requestWithURL:vidURL
                                                     cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                 timeoutInterval:10.0];
            // Load Request into WebView.
            [self.trailerWebView loadRequest:request];
            
        }
        
    }];
    [task resume];
}

- (IBAction)cancelTrailerView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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

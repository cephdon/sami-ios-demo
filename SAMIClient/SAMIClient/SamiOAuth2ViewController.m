//
//  SamiOAuth2ViewController.m
//  SAMIClient
//
//  Created by Maneesh Sahu-SSI on 9/22/14.
//  Copyright (c) 2014 SSIC. All rights reserved.
//

#import "SamiOAuth2ViewController.h"
#import "SamiUserSession.h"

@interface SamiOAuth2ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *addressField;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation SamiOAuth2ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //3. set the delegate to self so that we can respond to web activity
    self.webView.delegate = self;
    
    //6. Create the authenticate string that we will use in our request to foursquare
    // we have to provide our client id and the same redirect uri that we used in setting up our app
    // The redirect uri can be any scheme we want it to be... it's not actually going anywhere as we plan to
    // intercept it and get the access token off of it
    NSString *authenticateURLString = [NSString stringWithFormat:@"%@%@?client=mobile&client_id=%@&response_type=token&redirect_uri=%@", SAMI_AUTH_BASE_URL, SAMI_AUTHENTICATE_PATH, SAMI_CLIENT_ID, SAMI_REDIRECT_URL];
    //7. Make the request and load it into the webview
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:authenticateURLString]];
    
    self.addressField.text = authenticateURLString;
    [self.webView loadRequest:request];    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Web view delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    if([request.URL.scheme isEqualToString:@"ios-app"]){
        // 8. get the url and check for the access token in the callback url
        NSString *URLString = [[request URL] absoluteString];
        if ([URLString rangeOfString:@"access_token="].location != NSNotFound) {
            // 9. Store the access token in the user defaults
            NSString *accessToken = [[URLString componentsSeparatedByString:@"="] lastObject];
            [SamiUserSession sharedInstance].accessToken = accessToken;
            // 10. dismiss the view controller
            //[self.navigationController popToRootViewControllerAnimated:YES];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
    return YES;
}

@end

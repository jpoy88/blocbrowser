//
//  WebBrowserViewController.m
//  BlocBrowser
//
//  Created by John Patrick Adapon on 10/4/14.
//  Copyright (c) 2014 John Adapon. All rights reserved.
//

#import "WebBrowserViewController.h"
#import "AwesomeFloatingToolbar.h"





@interface WebBrowserViewController () <UIWebViewDelegate, UITextFieldDelegate, AwesomeFloatingToolbarDelegate>

@property (nonatomic, strong) UIWebView *webview;
@property (nonatomic, strong) UITextField *textField;
//@property (nonatomic, strong) UIButton *backButton; <-- removed with Toolbar Exercise
//@property (nonatomic, strong) UIButton *forwardButton; <-- removed with Toolbar Exercise
//@property (nonatomic, strong) UIButton *stopButton; <-- removed with Toolbar Exercise
//@property (nonatomic, strong) UIButton *reloadButton; <-- removed with Toolbar Exercise
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@property (nonatomic, strong) AwesomeFloatingToolbar *awesomeToolbar;

//@property (nonatomic, assign) BOOL isLoading; <-- there is a problem with multiple frames (ex. webpage with videos with another page inside it)
@property (nonatomic, assign) NSUInteger frameCount;

@end

@implementation WebBrowserViewController

#pragma mark - UIViewController

- (void) loadView {
    UIView *mainView = [UIView new];
    
    self.webview = [[UIWebView alloc] init];
    self.webview.delegate = self;
    
    self.textField = [[UITextField alloc] init];
    self.textField.keyboardType = UIKeyboardTypeURL;
    self.textField.returnKeyType = UIReturnKeyDone;
    self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textField.placeholder = NSLocalizedString(@"Website URL / Google Search", @"Placeholder text for web browser URL field");
    self.textField.backgroundColor = [UIColor colorWithWhite:200/255.0f alpha:1];
    self.textField.delegate = self;
    
    /*
    self.backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.backButton setEnabled:NO];
    
    self.forwardButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.forwardButton setEnabled:NO];
    
    self.stopButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.stopButton setEnabled:NO];
    
    self.reloadButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.reloadButton setEnabled:NO];
    
    [self.backButton setTitle:NSLocalizedString(@"Back", @"Back command") forState:UIControlStateNormal];
    //[self.backButton addTarget:self.webview action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    
    [self.forwardButton setTitle:NSLocalizedString(@"Forward", @"Forward command") forState:UIControlStateNormal];
    //[self.forwardButton addTarget:self.webview action:@selector(goForward) forControlEvents:UIControlEventTouchUpInside];
    
    [self.stopButton setTitle:NSLocalizedString(@"Stop", @"Stop command") forState:UIControlStateNormal];
    //[self.stopButton addTarget:self.webview action:@selector(stopLoading) forControlEvents:UIControlEventTouchUpInside];
    
    [self.reloadButton setTitle:NSLocalizedString(@"Reload", @"Reload command") forState:UIControlStateNormal];
    //[self.reloadButton addTarget:self.webview action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
    
    [self addButtonTargets]; // <-- button targets placed to the method
    */
    
    self.awesomeToolbar = [[AwesomeFloatingToolbar alloc] initWithFourTitles:@[kWebBrowserBackString, kWebBrowserForwardString, kWebBrowserStopString, kWebBrowserRefreshString]];
    self.awesomeToolbar.delegate = self;
    
    
    /*
    NSString *urlString = @"http://wikipedia.org";
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webview loadRequest:request];*/
    
    /* refactoring to for loop, because its cleaner and smart
    [mainView addSubview:self.webview];
    [mainView addSubview:self.textField];
    [mainView addSubview:self.backButton];
    [mainView addSubview:self.forwardButton];
    [mainView addSubview:self.stopButton];
    [mainView addSubview:self.reloadButton];
    */
    
    //for (UIView *viewToAdd in @[self.webview, self.textField, self.backButton, self.forwardButton, self.stopButton, self.reloadButton]) { <-- removed with Toolbar Exercise
    for (UIView *viewToAdd in @[self.webview, self.textField, self.awesomeToolbar]){
    
            [mainView addSubview:viewToAdd];
    }
    
    self.view = mainView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;

    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.activityIndicator];
    //[self.activityIndicator startAnimating]; <-- just to see if its working
}

- (void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    /*
    //make the webview fill the main view
    self.webview.frame = self.view.frame;*/
    
    
    //First, calculate some dimensions
    
    CGFloat viewWidth = [UIScreen mainScreen].bounds.size.width;
    
    static CGFloat itemHeight = 50;
    CGFloat width = CGRectGetWidth(self.view.bounds);
    //CGFloat browserHeight = CGRectGetHeight(self.view.bounds) - itemHeight - itemHeight; <-- removed with Toolbar Exercise
    //CGFloat buttonWidth = CGRectGetWidth(self.view.bounds) / 4; <-- removed with Toolbar Exercise
    
    CGFloat browserHeight = CGRectGetHeight(self.view.bounds) - itemHeight;
    
    
    //Now, assign the frames
    self.textField.frame = CGRectMake(0, 0, width, itemHeight);
    self.webview.frame = CGRectMake(0, CGRectGetMaxY(self.textField.frame), width, browserHeight);
    
    
    //Loop assigning buttons
    
    /*  <-- removed with Toolbar Exercise
    CGFloat currentButtonX = 0;
    
    for (UIButton *thisButton in @[self.backButton, self.forwardButton, self.stopButton, self.reloadButton]){
        thisButton.frame = CGRectMake(currentButtonX, CGRectGetMaxY(self.webview.frame), buttonWidth, itemHeight);
        currentButtonX += buttonWidth; // first button on the very left(0) + the width of that button so the second button will be placed beside it, then so on
    }
    */
     
    self.awesomeToolbar.frame = CGRectMake(viewWidth / 64, 100, viewWidth - (viewWidth / 32), 60);
    
    
    
    /*
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Halo!", @"welcome message") message:NSLocalizedString(@"This Web Browser is super private!", @"message") delegate:nil cancelButtonTitle:NSLocalizedString(@"Oh yeah? Let's use it!", @"confirmation button") otherButtonTitles:nil];
    [alert show];
    */
}



- (void) resetWebView {
    [self.webview removeFromSuperview];
    
    UIWebView *newWebView = [[UIWebView alloc] init];
    newWebView.delegate = self;
    [self.view addSubview:newWebView];
    
    self.webview = newWebView;
    
    //[self addButtonTargets];
    
    self.textField.text = nil;
    [self updateButtonsAndTitle];
    
   
    
}

/*
- (void) addButtonTargets {
    for (UIButton *button in @[self.backButton, self.forwardButton, self.stopButton, self.reloadButton]) {
        [button removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self.backButton addTarget:self.webview action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self.forwardButton addTarget:self.webview action:@selector(goForward) forControlEvents:UIControlEventTouchUpInside];
    [self.stopButton addTarget:self.webview action:@selector(stopLoading) forControlEvents:UIControlEventTouchUpInside];
    [self.reloadButton addTarget:self.webview action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
}
*/
 
 
#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    NSString *URLString = textField.text;
    NSURL *URL = [NSURL URLWithString:URLString];
    
    NSRange whiteSpace = [URLString rangeOfString:@" "];
    NSString *googleQuery = [URLString stringByReplacingCharactersInRange:whiteSpace withString:@"+"];
    
    if (whiteSpace.location != NSNotFound){
        
        URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.google.com/search?q=%@", googleQuery]];
    }
    
    else if (!URL.scheme) {
        // The user didn't type http: or https:
        URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", URLString]];
    }
    

    
    if (URL) {
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        [self.webview loadRequest:request];
    }
    
    return NO;
}




#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    //self.isLoading = YES; <-- multiple frame problem
    self.frameCount++;  // <-- lets say webpage + miniwebpage in webpage + video = counts up to 3 frames
    [self updateButtonsAndTitle];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    //self.isLoading = NO;
    self.frameCount--; //<-- previous example, 3 frames counted, now counting down the frames completed loading
    [self updateButtonsAndTitle];
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {

    if (error.code != -999){
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error") message:[error localizedDescription] delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
    [alert show];
    }
    
    [self updateButtonsAndTitle];
    self.frameCount--; // <-- considered as finish loading even if its error
 
    
}

#pragma mark - Miscellaneious

- (void) updateButtonsAndTitle {
    
    NSString *webpageTitle = [self.webview stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    if (webpageTitle) {
        self.title = webpageTitle;
    } else {
        self.title = self.webview.request.URL.absoluteString;
    }
    
    // if (self.isLoading)
    if (self.frameCount > 0) {   // <-- if its greater than zero, there are still pages loading
        [self.activityIndicator startAnimating];
    } else {
        [self.activityIndicator stopAnimating];
    }
    
    
    //self.backButton.enabled = [self.webview canGoBack];
    //self.forwardButton.enabled = [self.webview canGoForward];
    //self.stopButton.enabled = self.isLoading;
    //self.reloadButton.enabled = !self.isLoading;
    
    //self.stopButton.enabled = self.frameCount > 0; // <-- pages are still loading, stop button is enabled
    //self.reloadButton.enabled = self.webview.request.URL && self.frameCount == 0; // <-- 0 means all pages loaded, reload button is enabled. Addedd self.webview.request.URL "This change ensures that the web view has an NSURLRequest with accompanying NSURL. Otherwise, there'd be nothing to reload."
    
    [self.awesomeToolbar setEnabled:[self.webview canGoBack] forButtonWithTitle:kWebBrowserBackString];
    [self.awesomeToolbar setEnabled:[self.webview canGoForward] forButtonWithTitle:kWebBrowserForwardString];
    [self.awesomeToolbar setEnabled:self.frameCount > 0 forButtonWithTitle:kWebBrowserStopString];
    [self.awesomeToolbar setEnabled:self.webview.request.URL && self.frameCount == 0 forButtonWithTitle:kWebBrowserRefreshString];
    
}




#pragma mark - AwesomeFloatingToolbarDelegate

-(void) floatingToolbar:(AwesomeFloatingToolbar *)toolbar didSelectButtonWithTitle:(NSString *)title {
    
    if ([title isEqual:NSLocalizedString(@"Back", @"Back command")]){
        [self.webview goBack];
    }
    else if ([title isEqual:NSLocalizedString(@"Forward", @"Forward command")]) {
        [self.webview goForward];
    }
    else if ([title isEqual:NSLocalizedString(@"Stop", @"Stop command")]) {
        [self.webview stopLoading];
    }
    else if ([title isEqual:NSLocalizedString(@"Refresh", @"Reload command")]) {
        [self.webview reload];
    }
    
}


@end

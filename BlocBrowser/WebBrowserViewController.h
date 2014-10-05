//
//  WebBrowserViewController.h
//  BlocBrowser
//
//  Created by John Patrick Adapon on 10/4/14.
//  Copyright (c) 2014 John Adapon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebBrowserViewController : UIViewController


/*
 Replaces the web view with a fresh one, erasing all history. Also updates the URL field and toolbar button appropriately.
*/

- (void) resetWebView;

@end

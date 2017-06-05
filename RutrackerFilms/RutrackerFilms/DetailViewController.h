//
//  ViewController.h
//  RutrackerFilms
//
//  Created by denis on 24.05.17.
//  Copyright © 2017 uncorner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

extern NSInteger const MaxTitleLenght;

@property (strong, nonatomic) NSString *relativeUrl;
@property (strong, nonatomic) NSString *name;

//@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UIWebView *webView;



@end


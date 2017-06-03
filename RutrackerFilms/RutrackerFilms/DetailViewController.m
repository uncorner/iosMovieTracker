//
//  ViewController.m
//  RutrackerFilms
//
//  Created by denis on 24.05.17.
//  Copyright © 2017 uncorner. All rights reserved.
//

#import "DetailViewController.h"
#import "Common.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSMutableString *s = [[NSMutableString alloc]init];
    [s appendString:WebsiteUrl];
    [s appendString:@"/"];
    [s appendString:self.relativeUrl];
    
    NSURL *url = [NSURL URLWithString:s];
    
    self.label1.text = url.absoluteString;
    
    self.webView.scalesPageToFit = YES;
    self.webView.contentMode = UIViewContentModeScaleAspectFit;
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

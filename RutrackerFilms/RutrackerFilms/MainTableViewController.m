//
//  MainTableViewController.m
//  RutrackerFilms
//
//  Created by denis on 24.05.17.
//  Copyright © 2017 uncorner. All rights reserved.
//

#import "MainTableViewController.h"
@import HTMLReader;

@interface MainTableViewController ()

@property (nonatomic, strong) NSMutableArray *arrayFilms;

@end

@implementation MainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *url = [NSURL URLWithString:@"https://rutracker.cr/forum/viewforum.php?f=2200"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    
    [request setValue:@"UTF-8" forHTTPHeaderField:@"Accept-Charset" ];
    [request setValue:@"ru-RU" forHTTPHeaderField:@"Content-Language"];
    [request setValue:@"UTF-8" forHTTPHeaderField:@"Charset"];
    [request setValue:@"application/x-www-form-urlencoded charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                      {
                                          NSLog(@"completionHandler");
                                          
                                          NSString *contentType = nil;
                                          if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                                              NSDictionary *headers = [(NSHTTPURLResponse *)response allHeaderFields];
                                              contentType = headers[@"Content-Type"];
                                          }
                                          
                                          //NSString *htmlData = [[NSString alloc] initWithData:data encoding:NSWindowsCP1251StringEncoding];
                                          
                                          //NSLog([htmlData substringFromIndex:100]);
                                          [self parseHtml:data :contentType];
                                      }];
    [dataTask resume];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void) parseHtml: (NSData*) data: (NSString*) contentType {
    NSLog(@"parseHtml");
    
    
//    HTMLDocument *home = [HTMLDocument documentWithData:data
//                                      contentTypeHeader:contentType];
//    HTMLElement *div = [home firstNodeMatchingSelector:@".repository-meta-content"];
//    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
//    NSLog(@"%@", [div.textContent stringByTrimmingCharactersInSet:whitespace]);
//    

    HTMLDocument *doc = [HTMLDocument documentWithData:data
                                      contentTypeHeader:contentType];
    
    //Elements elements = doc.select("#main_content_wrap tr.hl-tr");
    NSArray<HTMLElement*> *elements = [doc nodesMatchingSelector:@"#main_content_wrap tr.hl-tr"];
    NSLog(@"elements %lu", (unsigned long)elements.count);
    
//    for (int j = 0; j < elements.count; j++) {
//        
//
//    }
    
    for (id object in elements) {
        HTMLElement * element = (HTMLElement*) object;
        
        //Elements torTopicElemets = element.select("td .torTopic a");
        //NSArray<HTMLElement*> *torTopicElements = [element nodesMatchingSelector:@"td .torTopic a"];
        //NSLog(@"torTopicElements %lu", (unsigned long)torTopicElements.count);
        
        /*
         if (torTopicElemets.size() > 0) {
         filmInfo.setName(torTopicElemets.get(0).text());
         filmInfo.setRelativeUrl(torTopicElemets.get(0).attr("href"));
         }
         */
        
        //if (torTopicElements.count > 0) {
        //HTMLElement *torTopicElement =[torTopicElements objectAtIndex:0];
        
        HTMLElement *torTopicElement = [element firstNodeMatchingSelector:@"td .torTopic a"];
        if (torTopicElement != nil)
        {
            NSString *name = [torTopicElement textContent];
            NSLog(@"%@", name);
            NSString *relativeUrl = [[torTopicElement attributes] objectForKey:@"href"];
            NSLog(@"%@", relativeUrl);
        }
        
        /*
         Elements topicAuthorElemets = element.select("td .topicAuthor a");
         if (topicAuthorElemets.size() > 0) {
         filmInfo.setTorrentAuthor(topicAuthorElemets.get(0).text());
         }
         */
        
        HTMLElement *topicAuthorElemet = [element firstNodeMatchingSelector:@"td .topicAuthor a"];
        //[element nodesMatchingSelector:@"td .topicAuthor a"];
        if (topicAuthorElemet != nil) {
            NSString *torrentAuthor = [topicAuthorElemet textContent];
            NSLog(@"%@", torrentAuthor);
            
        }
      
        
    }
    
    ////
}

- (void) viewWillAppear:(BOOL)animated {
    // todo
    self.arrayFilms = [[NSMutableArray alloc] initWithObjects:@"Джон Вик 2", @"Гадкий Я", @"Рыцарь в доспехах", nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayFilms.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString * identifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    NSString * string = [self.arrayFilms objectAtIndex:indexPath.row];
    cell.textLabel.text = string;
    
    // Configure the cell...
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end

//
//  TableViewController.m
//  WDProgressionImageLoader
//
//  Created by zhangyuchen on 8/26/15.
//  Copyright (c) 2015 zhangyuchen. All rights reserved.
//

#import "TableViewController.h"
#import "WDProgressiveImageView.h"

@interface TableViewController () <UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *testData;

@end

@implementation TableViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    _testData = [NSMutableArray array];
    
    NSArray *a = @[@"http://madeira.cc.hokudai.ac.jp/RD/jovi/info96/html/images/mand_prgrsv.jpg",
                   @"http://i.ytimg.com/vi/nDuYUlHc1r4/maxresdefault.jpg",
                   @"http://wd.geilicdn.com/vshop265496221-1416649037-627682.jpg?w=750&h=750",
                   @"http://wd.geilicdn.com/vshop13042-1422705517.jpeg?w=640&h=330&cp=1",
                   @"https://upload.wikimedia.org/wikipedia/commons/6/64/Pittsfield_township_new_progressive_missionary_baptist_church.JPG",
                   @"http://www.webdesignref.com/examples/images/jpeg_prog_big.jpg",
                   @"https://s-media-cache-ak0.pinimg.com/1200x/2e/0c/c5/2e0cc5d86e7b7cd42af225c29f21c37f.jpg"
                   ];
    
    [_testData addObjectsFromArray:a];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
//    self.tableView.dataSource = self;
//    self.tableView.delegate = self;
    
    
//    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _testData.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        WDProgressiveImageView *iv = [[WDProgressiveImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 500)];
        iv.tag = 233;
        [cell.contentView addSubview:iv];
    }
    
    
    NSString *url = [_testData objectAtIndex:indexPath.row];
    
    WDProgressiveImageView *iv = (WDProgressiveImageView *)[cell.contentView viewWithTag:233];
    [iv loadImageWithURL:url];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 500;
}

@end

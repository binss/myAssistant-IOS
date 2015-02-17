//
//  BINDayViewController.m
//  MyFinance
//
//  Created by bin on 14-2-6.
//  Copyright (c) 2014年 bin. All rights reserved.
//

#import "BINDayViewController.h"
#import "BINDatabaseManager.h"
@interface BINDayViewController ()

@end

@implementation BINDayViewController
@synthesize listData;
@synthesize incomeList;
@synthesize expenseList;
@synthesize otherList;
@synthesize incomeListIndex;
@synthesize expenseListIndex;
@synthesize otherListIndex;
@synthesize delectListIndex;

@synthesize sections;
@synthesize filePath;
@synthesize income;
@synthesize expense;

@synthesize date;
@synthesize dayContentArray;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        // Custom initialization
        
        dayContentArray = [NSMutableArray array];
//        self.navigationItem.rightBarButtonItem = self.editButtonItem;
//        self.navigationItem.rightBarButtonItem.title = @"编辑";
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
//    sections = [[NSMutableArray alloc] initWithObjects:@"收入",@"支出",@"其他",nil];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    dayContentArray = [NSMutableArray arrayWithArray:[[BINDatabaseManager databaseManager] getDailyRecord]];

//    NSLog(@"%@",dayContentArray);
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:date];
    self.navigationItem.title = [NSString stringWithFormat:@"%i年%i月%i日",[dateComponent year], [dateComponent month], [dateComponent day]];
    
    [self.tableView reloadData];
    
}

- (void)viewWillDisappear:(BOOL)animated
{

    
}

- (IBAction)backButtonClicked:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:^(void){
                                 // Code
                             }];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [dayContentArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@    %@",[[dayContentArray objectAtIndex:row] objectForKey:@"time"],[[dayContentArray objectAtIndex:row] objectForKey:@"content"]];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    
    [[BINDatabaseManager databaseManager] setCurrentRecord:[dayContentArray objectAtIndex:row]];
    [self performSegueWithIdentifier:@"modifyRecord" sender:self];

    
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    [[BINDatabaseManager databaseManager] setCurrentRecord:[dayContentArray objectAtIndex:row]];
    [[BINDatabaseManager databaseManager] deleteRecord];
    [dayContentArray removeObjectAtIndex:row];
    
    //更新视图
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                     withRowAnimation:UITableViewRowAnimationAutomatic];

//    //检查数组是否为空，如果为空，插入"无记录"并更新视图
//    if([dayContentArray count] == 0)
//    {
//        [dayContentArray addObject:@{@"time":@"  ",@"content":@"无记录"}];
//        [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
//                         withRowAnimation:UITableViewRowAnimationAutomatic];
//    }

}


@end

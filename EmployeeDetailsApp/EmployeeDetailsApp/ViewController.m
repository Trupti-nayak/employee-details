//
//  ViewController.m
//  EmployeeDetailsApp
//
//  Created by prabhudev avarasang on 21/01/17.
//  Copyright © 2017 Trupti. All rights reserved.
//

#import "ViewController.h"
#import "EmployeeFormViewController.h"
#import "AppDelegate.h"
#import "EmployeeDetailsEntity+CoreDataClass.h"

#define bufferSpace 30

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property (nonatomic,strong)NSArray *allEmployeesArr;
@property (nonatomic,strong)NSMutableArray *nameArray;
@property (nonatomic,strong)NSMutableArray *genderArray;
@property(nonatomic,strong)NSMutableArray *nameTempArray;
@property (nonatomic,strong)NSMutableArray *addressArray;

@property (nonatomic,strong)NSMutableArray *dobArray;
@property (nonatomic,strong)NSMutableArray *designationArray;

@property (nonatomic,strong)NSDictionary *empDict;
@property (nonatomic,strong)NSMutableArray *imageArr;



@end


@implementation ViewController
@dynamic tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor=[UIColor greenColor];
    _allEmployeesArr=[[NSArray alloc]init];
    _nameArray=[[NSMutableArray alloc]init];
    _genderArray=[[NSMutableArray alloc]init];
    _designationArray=[[NSMutableArray alloc]init];
    _addressArray=[[NSMutableArray alloc]init];
    _dobArray=[[NSMutableArray alloc]init];


         [self fetchEmployeeDetails];
   
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_nameArray!=nil) {
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(dbValueChaned:)
//                                                     name:@"DBValueChanged"
//                                                   object:nil];
        [self fetchEmployeeDetails];
        [self.tableView reloadData];
       
    }

}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self removeListener];
    
}
//-(void)dbValueChaned:(NSNotification *)notification
//{
//    [self fetchEmployeeDetails];
//    [self.tableView reloadData];
//}


-(void)fetchEmployeeDetails
{
    [_nameArray removeAllObjects ];
    [_genderArray removeAllObjects];
    [_designationArray removeAllObjects];
    AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *moc=app.managedObjectContext;
    NSFetchRequest *fetchEmpReq=[[NSFetchRequest alloc]initWithEntityName:@"EmployeeDetailsEntity"];
 //   EmployeeDetailsEntity *allDetails =[NSEntityDescription entityForName:@"EmployeeDetailsEntity" inManagedObjectContext:moc];
    NSSortDescriptor *sortByName=[[NSSortDescriptor alloc]initWithKey:@"employeeName" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortByName, nil];

    [fetchEmpReq setSortDescriptors:sortDescriptors];
    NSError *error=nil;
    _allEmployeesArr=[moc executeFetchRequest:fetchEmpReq error:&error];
    
    NSLog(@"total no of employees %lu",(unsigned long)_allEmployeesArr.count);
   // NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    _imageArr=[[NSMutableArray alloc]init];
    for (EmployeeDetailsEntity *emp in _allEmployeesArr) {
        [_nameArray addObject:emp.employeeName];
        [_genderArray addObject:emp.employeeGender];
        [_designationArray addObject:emp.employeeDesignation];
        
       // [_dobArray addObject:emp.employeeDOB];
      //  [_addressArray addObject:emp.employeeAddress];
      //  [_imageArr addObject:emp.employeeImage];
    }
   
    
}

- (IBAction)addEmployeeDetails:(id)sender {
   // UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
  //  EmployeeFormViewController *empFormVC=[sb instantiateViewControllerWithIdentifier:@"myEmpForm"];
   // addVC.view.backgroundColor=[UIColor redColor];
   // [self presentViewController:empFormVC animated:YES completion:nil];
    
}


- (IBAction)searchEmpDetails:(id)sender {
    NSLog(@"search button");
    if (_nameArray.count>0) {
        UISearchBar *searchBar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
        searchBar.delegate=self;
        [searchBar becomeFirstResponder];[self.view addSubview:searchBar];
    }
}



#pragma mark saerch DElegates

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *searchedStr=searchBar.text;
    NSLog(@"saerch button called %@",searchedStr);
    [searchBar resignFirstResponder];
    [searchBar removeFromSuperview];
    BOOL foundEmployee =false;
    _nameTempArray=[[NSMutableArray alloc]initWithArray:_nameArray];
    NSMutableArray *nameArary=[[NSMutableArray alloc]init];
   // [_nameArray removeAllObjects];
    for (NSString *str in _nameArray) {
        if ([str containsString:searchedStr ]) {
            foundEmployee=true;
            [nameArary addObject:str];
        }
    }
    [_nameArray removeAllObjects];
   // [_nameArray arrayByAddingObjectsFromArray:nameArary];
    _nameArray=nameArary;
    [self.tableView reloadData];
    
    UIBarButtonItem *clear=[[UIBarButtonItem alloc]initWithTitle:@"clear" style:UIBarButtonItemStylePlain target:self action:@selector(clearButton)];
    self.navigationItem.leftBarButtonItem =clear;
}


-(void)clearButton
{
    _nameArray=[NSMutableArray arrayWithArray:_nameTempArray];
    [self.tableView reloadData];
    self.navigationItem.leftBarButtonItem=nil;
}



#pragma mark TableView DElegates

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _nameArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //static NSString *reuseIdent = @"EmployeeCell";
    
    //create a reusable table-view cell object located by its identifier

    UITableViewCell *empCell = [tableView dequeueReusableCellWithIdentifier:@"employeeCell"];
    
    if (empCell == nil){
        empCell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"employeeCell"];
        empCell.textLabel.text=@"Total Employees";
        empCell.detailTextLabel.text=[NSString stringWithFormat:@"%lu",(unsigned long)_nameArray.count];
    }
    
    //get the employee object at the given index path in the fetch results
  //  EmployeeDetailsEntity *empDEtails=[_allEmployeesArr objectAtIndex:indexPath.row];
    
    //display text for the cell view
    empCell.textLabel.text = [_nameArray objectAtIndex:indexPath.row];
    empCell.detailTextLabel.text=[NSString stringWithFormat:@"%@ \t %@",[_designationArray objectAtIndex:indexPath.row],[_genderArray objectAtIndex:indexPath.row]];
    //empCell.imageView.image=[_imageArr objectAtIndex:indexPath.row];
    
    //set the accessory view to be a clickable button
  //  empCell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    return empCell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EmployeeFormViewController *form = [[EmployeeFormViewController alloc]init];
//    form.view.frame=self.view.frame;
//   // UIImageView *profileImage=[[UIImageView alloc]initWithImage:@"image"];
//    UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
//    nameLabel.text=@"Name";
//    UITextField *nameTF=[[UITextField alloc]initWithFrame:CGRectMake(self.view.frame.origin.x+bufferSpace+100, self.view.frame.origin.y, self.view.frame.size.width/2, 30)];
//    nameTF.text=[_nameArray objectAtIndex:indexPath.row];
//
//    //
//    UILabel *designationLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
//    designationLabel.text=@"Designation";
//    //
//    UILabel *addressLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
//    addressLabel.text=@"Address";
//    
//    [self.view addSubview:nameLabel];
//    [self.view addSubview:nameTF];
//    [self.view addSubview:designationLabel];
//    [self.view addSubview:addressLabel];

    [self.navigationController pushViewController:form animated:YES];
}


-(void)removeListener
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

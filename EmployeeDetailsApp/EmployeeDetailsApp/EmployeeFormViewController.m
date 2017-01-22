//
//  EmployeeFormViewController.m
//  EmployeeDetailsApp
//
//  Created by prabhudev avarasang on 21/01/17.
//  Copyright © 2017 Trupti. All rights reserved.
//


// requirements:
//  The app's Info.plist must contain an NSPhotoLibraryUsageDescription key with a string value explaining to the user how the app uses this data for using UIImagePickerController
// to set the privacy create a list and serach for privacy photo usage description- set a string like "This app needs access to photos"
// image capture works only on physical device not on simuator

#import "EmployeeFormViewController.h"
#import "AppDelegate.h"
#import "EmployeeContent.h"
#import "EmployeeDetailsEntity+CoreDataClass.h"

typedef enum
{
    GenderTag,
    HobbiesTag,
}TagForPicker;


@interface EmployeeFormViewController ()<UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>


@property (weak, nonatomic) IBOutlet UITextField *nameFieldTF;


@property (weak, nonatomic) IBOutlet UITextField *designationTF;

@property (weak, nonatomic) IBOutlet UITextField *dobTF;

@property (weak, nonatomic) IBOutlet UITextView *addressTxtView;

@property (weak, nonatomic) IBOutlet UITextField *genderTF;

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;

@property (weak, nonatomic) IBOutlet UITextField *hobbiesTF;


//
@property(nonatomic,strong)NSString *genderString;
@property(nonatomic,strong)NSString *hobbiesString;

@property(nonatomic,strong)EmployeeContent *empContentObj;
@property(nonatomic,strong)UIDatePicker *datep;
@property(nonatomic,strong)NSDateFormatter *dateFormat;

@property(nonatomic,strong)UIImagePickerController *imagePicker;
@property(nonatomic,strong)UIImage *selectedImage;
@property(nonatomic,assign)TagForPicker tag;




@end

@implementation EmployeeFormViewController

@synthesize empContentObj;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    isSaved=false;
    empContentObj=[[EmployeeContent alloc]init];
    _dobTF.delegate=self;
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Error"
                                      message:@"DEvice has no camera"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action)
                             {
                                 [self dismissViewControllerAnimated:YES completion:nil];
                                 
                            }];
        [alert addAction:ok];
        
        [self presentViewController:alert animated:YES completion:nil];
    }

    
    
}



- (IBAction)takePhoto:(id)sender {
    
    _imagePicker = [[UIImagePickerController alloc] init];
    _imagePicker.delegate = self;
    _imagePicker.allowsEditing = YES;
    _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:_imagePicker animated:YES completion:NULL];
}


- (IBAction)chooseFromPhotos:(id)sender {
   UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}




- (IBAction)saveEmpDetails:(id)sender {
    AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *moc=app.managedObjectContext;
    EmployeeDetailsEntity *employee=(EmployeeDetailsEntity *)[NSEntityDescription insertNewObjectForEntityForName:@"EmployeeDetailsEntity" inManagedObjectContext:moc];
 //   NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    if (!employee) {
        NSLog(@"failed to create employee details");
    }
    
//    employee.employeeName= _nameFieldTF.text;
//    employee.employeeDesignation=_designationTF.text;
//    employee.employeeAddress=_addressTxtView.text;
//    employee.employeeGender= _genderTF.text;
    [employee setValue:_nameFieldTF.text forKey:@"employeeName"];
    [employee setValue:_designationTF.text forKey:@"employeeDesignation"];
    [employee setValue:_addressTxtView.text forKey:@"employeeAddress"];
    [employee setValue:_genderTF.text forKey:@"employeeGender"];
    [employee setValue:_hobbiesTF.text forKey:@"employeeGender"];
    
    NSData *dataImg=UIImagePNGRepresentation(_selectedImage);
    [employee setValue:dataImg forKey:@"employeeImage"];


    NSError *error=nil;
    
    if ([moc save:&error]){
        NSLog(@"Successful");
    }
    else {
        NSLog(@"Unsuccessful = %@", error);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)backButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)closeForm:(id)sender {
  //  [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)selectGender:(id)sender {
    _tag=GenderTag;
    NSLog(@"Array values Are %@",[[empContentObj getGenderArray] objectAtIndex:0]);
    UIPickerView *genderPicker=[[UIPickerView alloc]init];
   // genderPicker.backgroundColor=[UIColor lightGrayColor];
    genderPicker.center=self.view.center;
    genderPicker.dataSource=self;
    genderPicker.delegate=self;
    [self.view addSubview:genderPicker];
    
}
- (IBAction)selectHobbies:(id)sender {
     _tag=HobbiesTag;
    UIPickerView *hobbiesPicker=[[UIPickerView alloc]init];
    // genderPicker.backgroundColor=[UIColor lightGrayColor];
    hobbiesPicker.center=self.view.center;
    hobbiesPicker.dataSource=self;
    hobbiesPicker.delegate=self;
    [self.view addSubview:hobbiesPicker];

    
}

#pragma mark ImagePicker delegates
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    _selectedImage = info[UIImagePickerControllerEditedImage];
    _profileImageView.image = _selectedImage;
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}


#pragma marks TextField delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    _datep=[[UIDatePicker alloc]initWithFrame:CGRectMake(150,300, 250, 150)];
    _datep.center=self.view.center;
    [self.datep addTarget:self action:@selector(datePickerBtnAction:) forControlEvents:UIControlEventValueChanged];
    NSDate *theMaxDate = [_dateFormat dateFromString: @"1-1-2000"];
   // NSDate *theMinDate = [_dateFormat dateFromString: @"1-1-1981"];
    [_datep setMaximumDate:theMaxDate];
   // [_datep setMinimumDate:theMinDate];
    [_datep setDatePickerMode:UIDatePickerModeDate];
    [self.view addSubview:_datep];
}
-(void)datePickerBtnAction:(UIDatePicker *)sender
{
    [_dateFormat setDateFormat:@"dd-MM-yyyy"];
    NSString *strDate=[_dateFormat stringFromDate:_datep.date];

    self.dobTF.text=strDate;
    
    
 //   [_dateFormat setDateFormat:@"HH:mm"];
  //  NSString *strTime=[_dateFormat stringFromDate:_datep.date];
  //  self.txtTimeSet.text=strTime;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    // Handle the selection
    if (_tag== GenderTag) {
        _genderString=[[empContentObj getGenderArray] objectAtIndex:row];
        NSLog(@"gender string %@",_genderString);
        _genderTF.text=_genderString;

    }
    else if (_tag== HobbiesTag)
    {
        _hobbiesString=[[empContentObj getHobbiesArray] objectAtIndex:row];
        NSLog(@"hobbies string %@",_genderString);
        _hobbiesTF.text=_hobbiesString;
    }
       [pickerView removeFromSuperview];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{

   // return [[empContentObj getGenderArray] count];
    if (_tag== GenderTag) {
        return [[empContentObj getGenderArray] count];
    }
    else
        return [[empContentObj getHobbiesArray] count];
    
 
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *title;
    
   // title = [@"" stringByAppendingFormat:@"Row %ld",(long)row];
         if (_tag== GenderTag) {
              title=[[empContentObj getGenderArray] objectAtIndex:row];
         }
    else
    {
         title=[[empContentObj getHobbiesArray] objectAtIndex:row];
    }
   
    
    return title;
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    int sectionWidth = 300;
    
    return sectionWidth;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

//
//  ViewController.m
//  MailList
//
//  Created by 蒋伟 on 2019/5/31.
//  Copyright © 2019 中国人寿. All rights reserved.
//

#import "ViewController.h"
#import <ContactsUI/ContactsUI.h>
#import <Contacts/Contacts.h>

@interface ViewController () <CNContactPickerDelegate>

@end

@implementation ViewController {
    
    CNContactPickerViewController * _peoplePickVC;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)openMailListAction:(id)sender {
    
    _peoplePickVC = [[CNContactPickerViewController alloc] init];
    _peoplePickVC.delegate = self;
    [self showViewController:_peoplePickVC sender:nil];
    
}

- (IBAction)getMailListAction:(id)sender {
    
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (status == CNAuthorizationStatusNotDetermined) {
        CNContactStore *store = [[CNContactStore alloc] init];
        [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError*  _Nullable error) {
            if (error) {
                //无权限
                [self showAlertViewAboutNotAuthorAccessContact];
            } else {
                //有权限
                [self openContact];
            }
        }];
    } else if(status == CNAuthorizationStatusRestricted) {
        //无权限
        [self showAlertViewAboutNotAuthorAccessContact];
    } else if (status == CNAuthorizationStatusDenied) {
        //无权限
        [self showAlertViewAboutNotAuthorAccessContact];
    } else if (status == CNAuthorizationStatusAuthorized) {
        //有权限
        [self openContact];
    }
    
}

- (void)showAlertViewAboutNotAuthorAccessContact{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请授权通讯录权限" message:@"请在iPhone的\"设置-隐私-通讯录\"选项中,允许花解解访问你的通讯录" preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:OKAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void)openContact{
    
    NSArray *keysToFetch = @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey];
    CNContactFetchRequest *fetchRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:keysToFetch];
    CNContactStore *contactStore = [[CNContactStore alloc] init];
    
    [contactStore enumerateContactsWithFetchRequest:fetchRequest error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
        
        NSString * firstName = contact.familyName;
        NSString * lastName = contact.givenName;
        
        //电话
        NSArray * phoneNums = contact.phoneNumbers;
        CNLabeledValue *labelValue = phoneNums.firstObject;
        NSString *phoneValue = [labelValue.value stringValue];
        
        NSLog(@"姓名：%@%@ 电话：%@", firstName, lastName, phoneValue);
        
    }];
    
}

// 获取指定联系人 里面只log了第一个电话号码
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact {

    //姓名
    NSString * firstName = contact.familyName;
    NSString * lastName = contact.givenName;

    //电话
    NSArray * phoneNums = contact.phoneNumbers;
    CNLabeledValue *labelValue = phoneNums.firstObject;
    NSString *phoneValue = [labelValue.value stringValue];

    NSLog(@"姓名：%@%@ 电话：%@", firstName, lastName, phoneValue);

}

// 获取指定电话
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty {

    //姓名
    NSString * firstName = contactProperty.contact.familyName;
    NSString * lastName = contactProperty.contact.givenName;

    //电话
    NSString * phoneNum = [contactProperty.value stringValue];

    NSLog(@"姓名：%@%@ 电话：%@", firstName, lastName, phoneNum);

}

//获取多个联系人 里面只log了每个联系人第一个电话号码
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContacts:(NSArray<CNContact *> *)contacts {

    //遍历
    for (CNContact * contact in contacts) {

        //姓名
        NSString * firstName = contact.familyName;
        NSString * lastName = contact.givenName;

        //电话
        NSArray * phoneNums = contact.phoneNumbers;
        CNLabeledValue *labelValue = phoneNums.firstObject;
        NSString *phoneValue = [labelValue.value stringValue];

        NSLog(@"姓名：%@%@ 电话：%@", firstName, lastName, phoneValue);

    }
}

- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker {
    NSLog(@"取消");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

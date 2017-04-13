//
//  ViewController.m
//  LocalNotificationSample
//
//  Created by  Mac-Vishal on 23/03/17.
//  Copyright © 2017  Mac-Vishal. All rights reserved.
//

#import "ViewController.h"
#import <UserNotifications/UserNotifications.h>

#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface ViewController ()
{
    NSDate *eventDate;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Start Date
    UIDatePicker *startDtPicker = [[UIDatePicker alloc]init];
    [startDtPicker setDate:[NSDate date]];
    startDtPicker.datePickerMode = UIDatePickerModeDateAndTime;
    [startDtPicker addTarget:self action:@selector(onStartDateClick:) forControlEvents:UIControlEventValueChanged];
    [txtTime setInputView:startDtPicker];
    
    // Do any additional setup after loading the view, typically from a nib.
}
-(void) onStartDateClick:(id)sender
{
    UIDatePicker *picker = (UIDatePicker*)txtTime.inputView;
    [picker setMinimumDate:[NSDate date]];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    eventDate = picker.date;
    [dateFormat setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormat setDateFormat:@"dd/MM/yyyy HH:mm"];
    
    NSString *dateString = [dateFormat stringFromDate:eventDate];
    txtTime.text = [NSString stringWithFormat:@"%@",dateString];
    NSLog(@"%@",[self getDatefromDateString:txtTime.text ofFormat:@"dd/MM/yyyy HH:mm"]);
}

- (IBAction)start:(id)sender
{
    if(SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"10.0")){
        
        UNMutableNotificationContent *objNotificationContent = [[UNMutableNotificationContent alloc] init];
        
        objNotificationContent.title = [NSString localizedUserNotificationStringForKey:@"Notification!" arguments:nil];
        
        objNotificationContent.body = [NSString localizedUserNotificationStringForKey:@"Incoming Local Notification" arguments:nil];
        
        objNotificationContent.sound = [UNNotificationSound defaultSound];
        
        NSArray *array = [NSArray arrayWithObjects:@"Value 1", @"Value 2", nil];
        NSDictionary *data = [NSDictionary dictionaryWithObject:array forKey:@"payload"];
        [objNotificationContent setUserInfo:data];
        
        //update application icon badge number
        objNotificationContent.badge = @([[UIApplication sharedApplication] applicationIconBadgeNumber] + 1);
        
        // Deliver the notification in five seconds.
        NSCalendar *cal = [NSCalendar currentCalendar];
        
        NSDateComponents *comps = [cal components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute)
                                         fromDate:[self getDatefromDateString:txtTime.text ofFormat:@"dd/MM/yyyy HH:mm"]];
        UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:comps repeats:NO];
        
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"ten"
                                                                              content:objNotificationContent trigger:trigger];
        //schedule localNotification
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            if (!error) {
                NSLog(@"Local Notification succeeded");
            }
            else {
                NSLog(@"Local Notification failed");
            }
        }];

    }
    else
    {
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        [localNotification setFireDate:[self getDatefromDateString:txtTime.text ofFormat:@"dd/MM/yyyy HH:mm"]];
        [localNotification setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
        
        NSArray *array = [NSArray arrayWithObjects:@"Value 1", @"Value 2", nil];
        NSDictionary *data = [NSDictionary dictionaryWithObject:array forKey:@"payload"];
        [localNotification setUserInfo:data];
        
        // Setup alert notification
        [localNotification setAlertBody:@"Incoming Local Notification" ];
        [localNotification setHasAction:YES];
        
        // Set badge notification, increment current badge value
        [localNotification setApplicationIconBadgeNumber:[[UIApplication sharedApplication] applicationIconBadgeNumber] + 1];
        
        // Setup sound notification
        [localNotification setSoundName:UILocalNotificationDefaultSoundName];
        
        // Schedule the notification
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];

    }
    
   }
- (NSDate *)getDatefromDateString:(NSString *)dateString ofFormat:(NSString *)datStringFormat
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];

    [df setDateFormat:datStringFormat];
    
    NSDate *date = [df dateFromString:dateString];
    
    return date;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

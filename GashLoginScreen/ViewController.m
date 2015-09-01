//
//  ViewController.m
//  GashLoginScreen
//
//  Created by dzhillian on 8/18/15.
//  Copyright (c) 2015 flabs. All rights reserved.
//


#import "ViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"


@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.lblLogin setText:[NSString stringWithFormat:NSLocalizedString(@"Login", nil)]];
    _lblPassword.text = [NSString stringWithFormat:NSLocalizedString(@"Password", nil)];
    [_lblPassword setAutoresizesSubviews:YES];
    [_lblPassword setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)signinClicked:(id)sender {
    NSInteger success = 0;
    NSArray *authUserArr = nil;
    NSDictionary *authUserDir = nil;
    NSString *status = nil;
    NSString *authMode = nil;
    @try {
        if ([[self.txtUsername text] isEqualToString:@""] || [[self.txtPassword text] isEqualToString:@""]) {
            [self alertStatus:@"Please enter Login and Password" :@"Sign in Failed!" :0];
        } else {

            NSDictionary *tmp = @{@"authUser" : @{@"login" : [self.txtUsername text],
                    @"pwd" : [self.txtPassword text]}};
            NSLog(@"%@", tmp);
            /*  tmp = [NSDictionary dictionaryWithObjectsAndKeys:
                      @"login", [self.txtUsername text],
                      @"pwd", [self.txtPassword text]];
              NSLog(@"%@", tmp);*/

            NSData *postData = [NSJSONSerialization dataWithJSONObject:tmp options:NSJSONWritingPrettyPrinted error:nil];
            NSString *jsonstr = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
            NSLog(@"%@", jsonstr);

            NSString *p = [NSString stringWithFormat:@"login=%@&pwd%@", [self.txtUsername text], [self.txtPassword text]];
            NSData *pData = [p dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];

            //NSLog(@"PostData: %@", post);
            NSURL *url = [NSURL URLWithString:@"http://172.16.250.12:38555/Nubis/rest/session"];

            NSURL *tempURL = [NSURL URLWithString:@"https://172.16.250.12:38789/CashTracker/Provider?id=login"];

            //NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
            NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long) [pData length]];

            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:tempURL];
            [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
            [request addRequestHeader:@"Content-Length" value:postLength];
            [request setRequestMethod:@"Post"];
            [request appendPostData:pData];

            /*     [request setURL:tempURL];
                 //[request setHTTPMethod:@"PUT"];
                 [request setHTTPMethod:@"POST"];
                 [request setValue:postLength forHTTPHeaderField:@"Content-length"];
                 //[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                 [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
                 //[request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
                 [request setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Request-With"];
                 //[request allowsAnyHTTPSCertificateForHost:@"172.16.250.12"];

                 [request setHTTPBody:pData];*/

            NSError *error = [[NSError alloc] init];
            NSHTTPURLResponse *response = nil;
            [request startSynchronous];
            NSData *urlData = [request responseData];
            error = [request error];
            //NSData *urlData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];

            NSLog(@"Response code: %ld", (long) [response statusCode]);

            if ([response statusCode] >= 200 && [response statusCode] < 300) {
                NSString *responseData = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
                NSLog(@"Response ==> %@", responseData);

                NSError *error = nil;
                NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:urlData options:NSJSONReadingMutableContainers error:&error];

                authUserDir = jsonData[@"authUser"];//[jsonData objectForKey:@"authUser"];
                status = authUserDir[@"status"];
                authMode = authUserDir[@"authMode"];
                NSLog(@"Login: %@, status: %@, authmode: %@", [self.txtUsername text], status, authMode);
                success = 1;

            }
            if (success == 1) {
                NSLog(@"Log SUCCESS");
            } else {
                [self alertStatus:@"Incorrect username or password" :@"Sign in failed!" :0];
            }

        }
    } @catch (NSException *e) {
        NSLog(@"Exception: %@", e);
        [self alertStatus:@"Sign in failed." :@"Error!" :0];
    }
    if (success) {
        [self performSegueWithIdentifier:@"login_success" sender:self];
    }
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {

    [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];

    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

- (void)alertStatus:(NSString *)msg :(NSString *)title :(int)tag {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    alertView.tag = tag;
    [alertView show];
}

- (IBAction)backgroundTap:(id)sender {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
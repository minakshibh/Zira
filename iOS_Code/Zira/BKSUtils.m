/*
 * Copyright 2014 Google Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#if !defined(__has_feature) || !__has_feature(objc_arc)
#error "This file requires ARC support."
#endif

#import "BKSUtils.h"

#import "BKSConstants.h"
#import "GoogleWalletSDK/GoogleWalletSDK.h"

@implementation BKSUtils

+ (NSString *)visibleTitle {
  return NSLocalizedString(@"Bike Store", @"Navigation bar title");
}

+ (NSString *)googleBikeTitle {
  return NSLocalizedString(@"Google Bike", @"First item title");
}

+ (NSString *)googleBike2Title {
  return NSLocalizedString(@"Google Bike 2014", @"Google Bike 2014 item title");
}

+ (NSString *)conferenceBikeTitle {
  return NSLocalizedString(@"Conference Bike", @"Conference Bike title");
}

///
/// The section header for the Confirmation view controller
///
+ (NSString *)buyWithSectionHeader {
  return NSLocalizedString(@"Buy With:", @"Label for instrument section");
}

///
/// The section header for the "ship to" section in the Confirmation view
/// controller.
///
+ (NSString *)shipToSectionHeader {
  return NSLocalizedString(@"Ship To:", @"Label for address section");
}

///
/// Header for order complete view controller.
///
+ (NSString *)orderCompleteTitle {
  return NSLocalizedString(@"Thank you!", @"Header for order complete view controller");
}

///
/// Text for order complete view controller.
///
+ (NSString *)orderCompleteText {
  return NSLocalizedString(
      @"Thanks for your order! We will send you a notification when the bike has been shipped.",
      @"Text for order complete view controller");
}

+ (NSString *)errorDialogTitle {
  return NSLocalizedString(@"Error", @"Error dialog title");
}

+ (NSString *)okDialogTitle {
  return NSLocalizedString(@"OK", @"Error dialog ok button title");
}

+ (NSString *)spendingLimitExceeded {
  return NSLocalizedString(@"You have exceeded your spending limit",
                           @"Error message on exceeding the spending limit");
}

/// NSDecimalNumberHandler that can correctly handle
/// operations on NSDecimalNumber instances to suit the
/// needs of the app.
///
+ (id)currencyDecimalNumberHandler {
  static NSDecimalNumberHandler *sharedHandler = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedHandler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundBankers
                                                                           scale:2
                                                                raiseOnExactness:NO
                                                                 raiseOnOverflow:NO
                                                                raiseOnUnderflow:NO
                                                             raiseOnDivideByZero:YES];
  });
  return sharedHandler;
}

///
/// Return a formatted NSDecimalNumber to be shown to the user.
///
+ (NSString *)formatPrice:(NSDecimalNumber *)price {
  NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
  [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
  [formatter setCurrencyCode:kBKSCurrencyCode];
  return [formatter stringFromNumber:price];
}

///
/// Compute the total price of an item.
///
+ (NSString *)computeTotalPrice:(CatalogItem *)catalogItem {
  NSDecimalNumberHandler *currencyHandler = [BKSUtils currencyDecimalNumberHandler];
  NSDecimalNumber *subtotal =
      [catalogItem.price decimalNumberByAdding:catalogItem.tax withBehavior:currencyHandler];
  NSString *total = [[subtotal decimalNumberByAdding:catalogItem.shippingCost
                                        withBehavior:currencyHandler] stringValue];
  return total;
}

///
/// Create a GWAMaskedWalletRequest
/// @param CataglogItem - the catalog item that is used for creating the request
///
+ (GWAMaskedWalletRequest *)createMaskedWalletRequestWithCatalogItem:(CatalogItem *)catalogItem {
  NSString *total = [self computeTotalPrice:catalogItem];
  GWAMaskedWalletRequest *request =
      [[GWAMaskedWalletRequest alloc] initWithCurrencyCode:kBKSCurrencyCode
                                       estimatedTotalPrice:total];
  request.phoneNumberRequired = YES;
  request.shippingAddressRequired = YES;
  return request;
}

///
/// Create a GWAFullWalletRequest
/// @param CataglogItem - the catalog item that is used for creating the request
/// @param googleTransactionId - the transactionId associated with a prior
/// masked wallet response.
/// @param merchantTransactionId - the merchant transactionId associated with a
/// prior masked wallet response.
///
+ (GWAFullWalletRequest *)createFullWalletRequestWithCatalogItem:(CatalogItem *)catalogItem
                                             googleTransactionId:(NSString *)googleTransactionId
                                           merchantTransactionId:(NSString *)merchantTransactionId {
  NSMutableArray *lineItems = [[NSMutableArray alloc] init];

  GWALineItem *productLineItem =
      [[GWALineItem alloc] initWithItemDescription:catalogItem.description
                                         unitPrice:[catalogItem.price stringValue]
                                          quantity:@"1"];
  [lineItems addObject:productLineItem];

  GWALineItem *shippingCostLineItem =
      [[GWALineItem alloc] initWithItemDescription:catalogItem.description
                                        totalPrice:[catalogItem.shippingCost stringValue]
                                              role:kGWALineItemRoleShipping];
  [lineItems addObject:shippingCostLineItem];

  GWALineItem *taxLineItem =
      [[GWALineItem alloc] initWithItemDescription:catalogItem.description
                                        totalPrice:[catalogItem.tax stringValue]
                                              role:kGWALineItemRoleTax];
  [lineItems addObject:taxLineItem];

  GWACart *cart = [[GWACart alloc] initWithCurrencyCode:kBKSCurrencyCode
                                             totalPrice:[self computeTotalPrice:catalogItem]
                                              lineItems:lineItems];

  GWAFullWalletRequest *fullWalletRequest =
      [[GWAFullWalletRequest alloc] initWithGoogleTransactionId:googleTransactionId
                                                           cart:cart
                                          merchantTransactionId:merchantTransactionId];
  return fullWalletRequest;
}

///
/// Handle the error and show an appropriate error dialog.
///
+ (void)handleError:(NSError *)error {
  switch (error.code) {
  case kGWAWalletErrorSpendingLimitExceeded:
    // Show a dialog to the user.
    [self showDialogWithTitle:[self errorDialogTitle] message:[self spendingLimitExceeded]];
    break;
  case kGWAWalletErrorBuyerCancelled:
    // This code indicates that the buyer cancelled the transaction and can
    // be used for things such as analytics.
    break;
  // Integration errors that should be logged and handled by the merchant/developer
  case kGWAWalletErrorMerchantAccountError:
  case kGWAWalletErrorInvalidParameters:
  case kGWAWalletErrorIntegrationError:
  case kGWAWalletErrorInvalidTransaction:
    NSLog(@"Error code %@", error.localizedDescription);
    [self showErrorDialog:error];
    break;
  // Unrecoverable errors
  case kGWAWalletErrorBuyerAccountError:
  case kGWAWalletErrorAuthenticationFailure:
  case kGWAWalletErrorServiceUnavailable:
  case kGWAWalletErrorUnknown:
  case kGWAWalletErrorUnsupportedAPIVersion:
  case kGWAWalletErrorInternalError:
    // unrecoverable error
    NSLog(@"Received unrecoverable error: %@", error.localizedDescription);
    [self showErrorDialog:error];
    break;
  default:
    NSLog(@"Received error: %@", error.localizedDescription);
    [self showErrorDialog:error];
    break;
  }
}

///
/// Show a UIAlertView with the given error.
///
+ (void)showErrorDialog:(NSError *)error {
  [self showDialogWithTitle:[self errorDialogTitle] message:error.localizedDescription];
}

///
/// Show a UIAlertView given a title and a message.
///
+ (void)showDialogWithTitle:(NSString *)title message:(NSString *)message {
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                  message:message
                                                 delegate:nil
                                        cancelButtonTitle:[self okDialogTitle]
                                        otherButtonTitles:nil];
  [alert show];
}

@end

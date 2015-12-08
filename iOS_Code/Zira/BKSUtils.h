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

#import <Foundation/Foundation.h>

#import "CatalogItem.h"
#import "GoogleWalletSDK/GoogleWalletSDK.h"

@interface BKSUtils : NSObject

///
/// Navigation bar title.
///
+ (NSString *)visibleTitle;

///
/// Title of Google Bike.
///
+ (NSString *)googleBikeTitle;

///
/// Title of Google Bike2.
///
+ (NSString *)googleBike2Title;

///
/// Title of the conference bike.
///
+ (NSString *)conferenceBikeTitle;

///
/// The section header for the Confirmation view controller
///
+ (NSString *)buyWithSectionHeader;

///
/// The section header for the "ship to" section in the Confirmation view
/// controller.
///
+ (NSString *)shipToSectionHeader;

///
/// Header for order complete view controller.
///
+ (NSString *)orderCompleteTitle;

///
/// Text for order complete view controller.
///
+ (NSString *)orderCompleteText;

///
/// Text for the alert dialog okay button.
///
+ (NSString *)okDialogTitle;

///
/// Text shown when a user exceeds their spending limit.
///
+ (NSString *)spendingLimitExceeded;

///
/// NSDecimalNumberHandler that can correctly handle
/// operations on NSDecimalNumber instances to suit the
/// needs of the app.
///
+ (id)currencyDecimalNumberHandler;

///
/// Return a formatted NSDecimalNumber to be shown to the user.
///
+ (NSString *)formatPrice:(NSDecimalNumber *)price;

///
/// Compute the total price of an item.
/// @param CatalogItem the item to compute the total of.
///
+ (NSString *)computeTotalPrice:(CatalogItem *)catalogItem;

///
/// Create a GWAMaskedWalletRequest
/// @param CatalogItem the catalog item that is used for creating the request
///
+ (GWAMaskedWalletRequest *)createMaskedWalletRequestWithCatalogItem:
        (CatalogItem *)catalogItem;

///
/// Create a GWAFullWalletRequest
/// @param CataglogItem the catalog item that is used for creating the request
/// @param googleTransactionId the transactionId associated with a prior
/// masked wallet response.
/// @param merchantTransactionId the merchant transactionId associated with a
/// prior masked wallet response.
///
+ (GWAFullWalletRequest *)
    createFullWalletRequestWithCatalogItem:(CatalogItem *)catalogItem
                       googleTransactionId:(NSString *)googleTransactionId
                     merchantTransactionId:(NSString *)merchantTransactionId;

///
/// Handle the error and show an appropriate error dialog.
///
+ (void)handleError:(NSError *)error;

///
/// Show a UIAlertView with the given error.
///
+ (void)showErrorDialog:(NSError *)error;

///
/// Show a UIAlertView given a title and a message.
///
+ (void)showDialogWithTitle:(NSString *)title message:(NSString *)message;

@end

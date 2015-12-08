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

///
/// Interface that represents a single item that can be purchased.
///
@interface CatalogItem : NSObject

///
/// The item title.
///
@property(nonatomic, copy) NSString *title;

///
/// The item unit price.
///
@property(nonatomic, copy) NSDecimalNumber *price;

///
/// Although the tax varies by the specific locality/state, we consider
/// it fixed for the purposes of this sample.
///
@property(nonatomic, copy) NSDecimalNumber *tax;

///
/// The item shipping cost.
///
@property(nonatomic, copy) NSDecimalNumber *shippingCost;

///
/// The item's thumbnail image.
///
@property(nonatomic, strong) UIImage *thumbImage;

///
/// The item's full image.
///
@property(nonatomic, strong) UIImage *fullImage;

///
/// Designated initializer.
///
- (id)initWithTitle:(NSString *)title
              price:(NSString *)price
            taxRate:(NSString *)taxRate
       shippingCost:(NSString *)shippingCost
         thumbImage:(UIImage *)thumbImage
          fullImage:(UIImage *)fullImage;

@end

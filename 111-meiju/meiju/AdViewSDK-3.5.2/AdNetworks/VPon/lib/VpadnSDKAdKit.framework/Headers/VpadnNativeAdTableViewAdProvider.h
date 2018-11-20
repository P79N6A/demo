//
//  VpadnNativeAdTableViewAdProvider.h
//  iphone-vpon-sdk
//
//  Created by Mike Chou on 5/19/16.
//  Copyright © 2016 com.vpon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "VpadnNativeAd.h"
#import "VpadnNativeAdsManager.h"

NS_ASSUME_NONNULL_BEGIN
/*!
 @class VpadnNativeAdTableViewAdProvider
 
 @abstract Additional functionality on top of VpadnNativeAdsManager to assist in using native ads within a UITableView. This class contains a mechanism to map indexPaths to native ads in a stable manner as well as helpers which assist in doing the math to include ads at a regular interval within a table view.
 */
@interface VpadnNativeAdTableViewAdProvider : NSObject

/*!
 @property
 @abstract Passes delegate methods from VpadnNativeAd. Separate delegate calls will be made for each native ad contained.
 */
@property (nonatomic, weak, nullable) id<VpadnNativeAdDelegate> delegate;

/*!
 @method
 
 @abstract Create a VpadnNativeAdTableViewAdProvider.
 
 @param manager The VpadnNativeAdsManager which is consumed by this class.
 */
- (instancetype)initWithManager:(VpadnNativeAdsManager *)manager NS_DESIGNATED_INITIALIZER;

/*!
 @method
 
 @abstract Retrieve a native ad for an indexPath, will return the same ad for a given indexPath until the native ads manager is refreshed. This method is intended for usage with a table view and specifically the caller is recommended to wait until  tableView:cellForRowAtIndexPath: to ensure getting the best native ad for the given table cell.
 
 @param tableView The tableView where native ad will be used
 @param indexPath The indexPath to use as a key for this native ad
 @return A VpadnNativeAd which is loaded and ready to be used.
 */
- (VpadnNativeAd *)tableView:(UITableView *)tableView nativeAdForRowAtIndexPath:(NSIndexPath *)indexPath;

/*!
 @method
 
 @abstract Support for evenly distributed native ads within a table view. Computes whether this cell is an ad or not.
 
 @param indexPath The indexPath of the cell within the table view
 @param stride The frequency that native ads are to appear within the table view
 @return Boolean indicating whether the cell at the path is an ad
 */
- (BOOL)isAdCellAtIndexPath:(NSIndexPath *)indexPath forStride:(NSInteger)stride;

/*!
 @method
 
 @abstract Support for evenly distributed native ads within a table view. Adjusts a non-ad cell indexPath to the indexPath it would be in a collection with no ads.
 
 @param indexPath The indexPath to of the non-ad cell
 @param stride The frequency that native ads are to appear within the table view
 @return An indexPath adjusted to what it would be in a table view with no ads
 */
- (NSIndexPath *)adjustNonAdCellIndexPath:(NSIndexPath *)indexPath forStride:(NSInteger)stride;

/*!
 @method
 
 @abstract Support for evenly distributed native ads within a table view. Adjusts the total count of cells within the table view to account for the ad cells.
 
 @param count The count of cells in the table view not including ads
 @param stride The frequency that native ads are to appear within the table view
 @return The total count of cells within the table view including both ad and non-ad cells
 */
- (NSInteger)adjustCount:(NSInteger)count forStride:(NSInteger)stride;

@end

NS_ASSUME_NONNULL_END


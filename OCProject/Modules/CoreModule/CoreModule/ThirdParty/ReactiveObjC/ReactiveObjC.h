//
//  ReactiveObjC.h
//  ReactiveObjC
//
//  Created by Josh Abernathy on 3/5/12.
//  Copyright (c) 2012 GitHub, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

//! Project version number for ReactiveObjC.
FOUNDATION_EXPORT double ReactiveObjCVersionNumber;

//! Project version string for ReactiveObjC.
FOUNDATION_EXPORT const unsigned char ReactiveObjCVersionString[];

#import <CoreModule/EXTKeyPathCoding.h>
#import <CoreModule/EXTScope.h>
#import <CoreModule/NSArray+RACSequenceAdditions.h>
#import <CoreModule/NSData+RACSupport.h>
#import <CoreModule/NSDictionary+RACSequenceAdditions.h>
#import <CoreModule/NSEnumerator+RACSequenceAdditions.h>
#import <CoreModule/NSFileHandle+RACSupport.h>
#import <CoreModule/NSNotificationCenter+RACSupport.h>
#import <CoreModule/NSObject+RACDeallocating.h>
#import <CoreModule/NSObject+RACLifting.h>
#import <CoreModule/NSObject+RACPropertySubscribing.h>
#import <CoreModule/NSObject+RACSelectorSignal.h>
#import <CoreModule/NSOrderedSet+RACSequenceAdditions.h>
#import <CoreModule/NSSet+RACSequenceAdditions.h>
#import <CoreModule/NSString+RACSequenceAdditions.h>
#import <CoreModule/NSString+RACSupport.h>
#import <CoreModule/NSIndexSet+RACSequenceAdditions.h>
#import <CoreModule/NSUserDefaults+RACSupport.h>
#import <CoreModule/RACBehaviorSubject.h>
#import <CoreModule/RACChannel.h>
#import <CoreModule/RACCommand.h>
#import <CoreModule/RACCompoundDisposable.h>
#import <CoreModule/RACDelegateProxy.h>
#import <CoreModule/RACDisposable.h>
#import <CoreModule/RACEvent.h>
#import <CoreModule/RACGroupedSignal.h>
#import <CoreModule/RACKVOChannel.h>
#import <CoreModule/RACMulticastConnection.h>
#import <CoreModule/RACQueueScheduler.h>
#import <CoreModule/RACQueueScheduler+Subclass.h>
#import <CoreModule/RACReplaySubject.h>
#import <CoreModule/RACScheduler.h>
#import <CoreModule/RACScheduler+Subclass.h>
#import <CoreModule/RACScopedDisposable.h>
#import <CoreModule/RACSequence.h>
#import <CoreModule/RACSerialDisposable.h>
#import <CoreModule/RACSignal+Operations.h>
#import <CoreModule/RACSignal.h>
#import <CoreModule/RACStream.h>
#import <CoreModule/RACSubject.h>
#import <CoreModule/RACSubscriber.h>
#import <CoreModule/RACSubscriptingAssignmentTrampoline.h>
#import <CoreModule/RACTargetQueueScheduler.h>
#import <CoreModule/RACTestScheduler.h>
#import <CoreModule/RACTuple.h>
#import <CoreModule/RACUnit.h>

#if TARGET_OS_WATCH
#elif TARGET_OS_IOS || TARGET_OS_TV
    #import <CoreModule/UIBarButtonItem+RACCommandSupport.h>
    #import <CoreModule/UIButton+RACCommandSupport.h>
    #import <CoreModule/UICollectionReusableView+RACSignalSupport.h>
    #import <CoreModule/UIControl+RACSignalSupport.h>
    #import <CoreModule/UIGestureRecognizer+RACSignalSupport.h>
    #import <CoreModule/UISegmentedControl+RACSignalSupport.h>
    #import <CoreModule/UITableViewCell+RACSignalSupport.h>
    #import <CoreModule/UITableViewHeaderFooterView+RACSignalSupport.h>
    #import <CoreModule/UITextField+RACSignalSupport.h>
    #import <CoreModule/UITextView+RACSignalSupport.h>

    #if TARGET_OS_IOS
        #import <CoreModule/NSURLConnection+RACSupport.h>
        #import <CoreModule/UIStepper+RACSignalSupport.h>
        #import <CoreModule/UIDatePicker+RACSignalSupport.h>
        #import <CoreModule/UIAlertView+RACSignalSupport.h>
        #import <CoreModule/UIActionSheet+RACSignalSupport.h>
        #import <CoreModule/MKAnnotationView+RACSignalSupport.h>
        #import <CoreModule/UIImagePickerController+RACSignalSupport.h>
        #import <CoreModule/UIRefreshControl+RACCommandSupport.h>
        #import <CoreModule/UISlider+RACSignalSupport.h>
        #import <CoreModule/UISwitch+RACSignalSupport.h>
    #endif
#elif TARGET_OS_MAC
    #import <CoreModule/NSControl+RACCommandSupport.h>
    #import <CoreModule/NSControl+RACTextSignalSupport.h>
    #import <CoreModule/NSObject+RACAppKitBindings.h>
    #import <CoreModule/NSText+RACSignalSupport.h>
    #import <CoreModule/NSURLConnection+RACSupport.h>
#endif

//
//  Threading.swift
//  SwiftThreading
//
//  Created by Joshua Smith on 7/5/14.
//  Copyright (c) 2014 iJoshSmith. All rights reserved.
//

//
// This code has been tested against Xcode 6 Beta 5.
//

import Foundation

infix operator ~> {}

/** 
Executes the lefthand closure on a background thread and, 
upon completion, the righthand closure on the main thread. 
*/
func ~> (
    backgroundClosure: () -> (),
    mainClosure:       () -> ())
{
    dispatch_async(queue) {
        backgroundClosure()
        dispatch_async(dispatch_get_main_queue(), mainClosure)
    }
}

/**
Executes the lefthand closure on a background thread and,
upon completion, the righthand closure on the main thread.
Passes the background closure's output to the main closure.
*/
func ~> <R> (
    backgroundClosure: () -> R,
    mainClosure:       (result: R) -> ())
{
    dispatch_async(queue) {
        let result = backgroundClosure()
        dispatch_async(dispatch_get_main_queue(), {
            mainClosure(result: result)
        })
    }
}

/**

Contributed by Isaac Rivera on 5/31/2015

Executes the lefthand closure on a background thread accepting a tuple (R, T)
return and upon completion, the righthand closure on the main thread is executed,
passing the tuple to the main closure.

Example:

func getData(req: NSURLRequest) -> (result: [String], error: NSError?) {...}
func storeResult(result: [String], forError error: NSError?)) {...}

{
getData(req)
} ~> {
storeResult($0, forError: $1)
}

*/
func ~> <R, T> (
	backgroundClosure: () -> (R, T),
	mainClosure:       ((R, T)) -> ())
{
	dispatch_async(queue) {
		let (a, b) = backgroundClosure()
		dispatch_async(dispatch_get_main_queue(), {
			mainClosure(a, b)
		})
	}
}

/** Serial dispatch queue used by the ~> operator. */
private let queue = dispatch_queue_create("serial-worker", DISPATCH_QUEUE_SERIAL)

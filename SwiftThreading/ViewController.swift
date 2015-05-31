//
//  ViewController.swift
//  SwiftThreading
//
//  Created by Joshua Smith on 7/5/14.
//  Copyright (c) 2014 iJoshSmith. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
	@IBAction func handleButton(sender: AnyObject)
	{
		// NOTE: The semicolons prevent a compiler error
		// as of Xcode 6 Beta 3.
		
		{ log("hello") } ~> { log("goodbye") };
		
		{ addRange(0..<10_000) } ~> { log("sum = \($0)") };
	}
	
	@IBAction func handleButtonWithTuple(sender: AnyObject)
	{
		{
			addRangeWithMessage(0..<1_000_000)
			} ~> {
				alert($1, "sum = \($0)")
		}
	}
}

func addRange(range: Range<Int>) -> Int
{
	log("adding...")
	return reduce(range, 0, +)
}

func log(message: String)
{
	let main = NSThread.currentThread().isMainThread
	let name = main ? "[main]" : "[back]"
	println("\(name) \(message)")
}


func addRangeWithMessage(range: Range<Int>) -> (Int, String)
{
	log("adding...")
	return (reduce(range, 0, +), "Success!")
}

func alert(title: String, message:String)
{
	let main = NSThread.currentThread().isMainThread
	let name = main ? "[main]" : "[back]"
	
	UIAlertView(title: title, message: "\(name) \(message)", delegate: nil, cancelButtonTitle: "OK").show()
}

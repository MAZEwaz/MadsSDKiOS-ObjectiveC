//
//  MadsJSConstants.h
//  MadsSDK
//
//  Created by Alexander van Elsas on 3/28/12.
//  Copyright (c) 2012 Mads. All rights reserved.
//

#ifndef MadsSDK_MadsJSConstants_h
#define MadsSDK_MadsJSConstants_h

/*#define MADS_JS @"window.mads = {};mads.readyEvents = [];mads.ready(callback) { this.readyEvents.push(callback) };mads.setReady = function() { for(i in this.readyEvents) this.readyEvents[i](); } mads.isOverlay = function(opts) { window.ormmaview.executeNativeCall(\"mads_overlay\", \"hi\", \"hi\") };alert('hi from alert');window.ORMMAReady = function() { mads.setReady() };"
*/
#define MADS_JS @"window.mads = {};mads.readyEvents = [];mads.ready = function(callback) { this.readyEvents.push(callback) };mads.setReady = function() { for(i in this.readyEvents) { this.readyEvents[i](); } this.readyEvents = [] }; mads.isOverlay = function(opts) { window.ormmaview.executeNativeCall('mads_overlay', 'hi', 'hi') };window.ORMMAReady = function() { mads.setReady() };"

#endif

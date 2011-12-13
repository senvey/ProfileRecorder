/*

	ProfileRecorder, record user's info so that it could be browsed offline.
	Copyright 2007 Senvey Lee
	Email me at senvey@gmail.com

	This file is part of ProfileRecorder.

	ProfileRecorder is free software; you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation; either version 2 of the License, or
	(at your option) any later version.

	ProfileRecorder is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with ProfileRecorder; if not, write to the Free Software
	Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

*/

window.onload = WindowLoading;
var TOOLTIPS;
var BLANK_BANK_BAG;
var BANK_FIRST_SLOT_NUM = 5;
var BANK_BAG_TOTAL_NUM = 7;
var PortableBagsIds = ['Backpack', 'Bag1', 'Bag2', 'Bag3', 'Bag4'];
var BankBagsIds = ['Bag5', 'Bag6', 'Bag7', 'Bag8', 'Bag9', 'Bag10', 'Bag11'];

function WindowLoading() {
	TOOLTIPS = document.getElementById('ToolTips');
	
	for (i = BANK_FIRST_SLOT_NUM; i <= BANK_FIRST_SLOT_NUM+BANK_BAG_TOTAL_NUM; i++) {
	    BLANK_BANK_BAG = document.getElementById('BlankBankBag' + i);
	    if (BLANK_BANK_BAG != null) {
	        // Don't know how to add Light filter dynamically, so pre-add it in css.
	        BLANK_BANK_BAG.filters.Light.AddPoint(19, 19, 50, 255, 0, 0, 100);
	    }
	}
}

function IsInArray(s, arr) {
    for (var p in arr) {
        if (arr[p] === s) {
            return true;
        }
    }
    return false; 
}
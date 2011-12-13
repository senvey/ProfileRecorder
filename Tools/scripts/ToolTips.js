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

function showToolTips() {
    // in case page is loading, TOOLTIPS may be not available
    if (TOOLTIPS == null) {
        return;
    }
	TOOLTIPS.style.display = 'block';
}

function hideToolTips() {
    // in case page is loading, TOOLTIPS may be not available
    if (TOOLTIPS == null) {
        return;
    }
	TOOLTIPS.style.display = 'none';
}

function updateToolTips(event, text) {
    // in case page is loading, TOOLTIPS may be not available
    if (TOOLTIPS == null) {
        return;
    }
    
	var intX = 0, intY = 0;
	TOOLTIPS.innerHTML = text;

	tooltip_width = (TOOLTIPS.style.pixelWidth) ? TOOLTIPS.style.pixelWidth : TOOLTIPS.offsetWidth;
	tooltip_height = (TOOLTIPS.style.pixelHeight) ? TOOLTIPS.style.pixelHeight : TOOLTIPS.offsetHeight;

	if (event == null) {
		event = window.event;
	}

	if (event.pageX || event.pageY) {
		intX = event.pageX;
		intY = event.pageY;
	} else if (event.clientX || event.clientY) {
		if (document.documentElement.scrollTop) {
			intX = event.clientX + document.documentElement.scrollLeft;
			intY = event.clientY + document.documentElement.scrollTop;
		} else {
			intX = event.clientX + document.body.scrollLeft;
			intY = event.clientY + document.body.scrollTop;
		}

		if (tooltip_width > document.body.clientWidth - 20) {
			intX -= event.clientX;
		} else if (event.clientX + tooltip_width > document.body.clientWidth - 20) {
			if (tooltip_width + 5 < event.clientX ) {
				intX -= tooltip_width + 5;
			} else {
				intX -= event.clientX;
			}
		} else {
			intX += 15;
		}
		if (tooltip_height > document.body.clientHeight) {
			intY -= event.clientY;
		} else if (event.clientY + tooltip_height > document.body.clientHeight) {
			if (tooltip_height + 5 < document.body.clientHeight) {
				intY -= (event.clientY + tooltip_height - document.body.clientHeight) + 5;
			} else {
				intY -= event.clientY;
			}
		}
	}
	
	TOOLTIPS.style.left = (intX) + 'px';
	TOOLTIPS.style.top = (intY) + 'px';
}
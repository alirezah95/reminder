var msec;
var sec;
var min;


function reset() {
	msec = 0;
	sec = 0;
	min = 0;
	return;
}

function update() {
	msec += 1;
	if (msec >= 100) {
		msec = 0;
		sec += 1;
		if (sec >= 60) {
			min += 1;
			sec = 0;
		}
	}
}

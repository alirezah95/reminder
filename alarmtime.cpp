#include "alarmtime.hpp"
#include <QTime>

AlarmTime::AlarmTime(QObject *parent) : QObject(parent)
{

}

QString AlarmTime::getTimeDiff(int hour, int minute)
{
	auto currTime = QTime::currentTime();
	auto hourDiff = hour - currTime.hour();
	if (hourDiff < 0) {
		hourDiff = 24 + hourDiff;
	}
	auto minDiff = minute - currTime.minute();
	if (minDiff < 0) {
		minDiff = 59 + minDiff;
		hourDiff--;
		if (hourDiff < 0) {
			hourDiff = 24 + hourDiff;
		}
	}

	QString hStr, mStr;
	if (hourDiff == 0)
		hStr = "";
	else {
		hStr = QString("%1 hour").arg(hourDiff) + ((hourDiff > 1) ? "s": "");
		hStr += " and ";
	}

	if (minDiff == 0)
		mStr = "";
	else
		mStr = QString("%1 minute").arg(minDiff) + ((hourDiff > 1) ? "s": "");

	return QString("Alarm in %1%2")
			.arg(hStr.toStdString().c_str(), mStr.toStdString().c_str());
}

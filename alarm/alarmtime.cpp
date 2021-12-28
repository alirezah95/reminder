#include "alarmtime.hpp"
#include <QTime>
#include <QDebug>

AlarmTime::AlarmTime(QObject *parent) : QObject(parent)
{

}

QString AlarmTime::getTimeDiff(int hour, int minute)
{
	auto currTime = QTime::currentTime();
	auto alarmTime = QTime();
	alarmTime.setHMS(hour, minute, 0);

	long secs = currTime.secsTo(alarmTime);
	if (secs < 0) {
		secs += 86400;
	}

	int hourDiff = secs / 3600;
	int minDiff = (secs % 3600) / 60;

	if (hourDiff == 0 && minDiff == 0) {
		return QString("Alarm in less than 1 minute");
	}

	QString hStr, mStr;
	if (hourDiff == 0) {
		hStr = "";
	} else {
		hStr = QString("%1 hour").arg(hourDiff) + ((hourDiff > 1) ? "s": "");
	}
	if (minDiff == 0) {
		mStr = "";
	} else {
		mStr = QString("%1 minute").arg(minDiff) + ((hourDiff > 1) ? "s": "");
	}
	if (minDiff != 0 && hourDiff != 0)
		hStr += " and ";

	return QString("Alarm in %1%2")
			.arg(hStr.toStdString().c_str(), mStr.toStdString().c_str());
}

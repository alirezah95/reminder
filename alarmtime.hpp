#ifndef ALARMTIME_HPP
#define ALARMTIME_HPP

#include <QObject>

class AlarmTime : public QObject
{
	Q_OBJECT
public:
	explicit AlarmTime(QObject *parent = nullptr);
	Q_INVOKABLE QString getTimeDiff(int hour, int minute);

signals:

};

#endif // ALARMTIME_HPP

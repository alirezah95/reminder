#ifndef ALARMPROXYMODEL_HPP
#define ALARMPROXYMODEL_HPP

#include <QSortFilterProxyModel>
#include <QObject>

class SqlAlarmModel;

class AlarmProxyModel : public QSortFilterProxyModel
{
	Q_OBJECT
public:
	explicit AlarmProxyModel(QObject *parent = nullptr);
	virtual ~AlarmProxyModel();

	Q_INVOKABLE bool insert(QString time, QString repeat, bool active);
	Q_INVOKABLE bool remove(int row);

private:
	SqlAlarmModel*	mSource;
};

#endif // ALARMPROXYMODEL_HPP

#include "alarmproxymodel.hpp"
#include "sqlalarmmodel.hpp"

AlarmProxyModel::AlarmProxyModel(QObject *parent)
	: QSortFilterProxyModel{parent}
{
	mSource = new SqlAlarmModel();

	setSourceModel(mSource);
	setSortRole(SqlAlarmModel::Roles::Time);
	sort(0);

	return;
}

AlarmProxyModel::~AlarmProxyModel()
{
	delete mSource;
}

bool AlarmProxyModel::insert(QString time, QString repeat, bool active)
{
	return mSource->insert(time, repeat, active);
}

bool AlarmProxyModel::remove(int row)
{
	return mSource->remove(row);
}

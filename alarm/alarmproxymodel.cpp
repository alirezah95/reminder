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
	return mSource->remove(
				mapToSource(this->index(row, 0)));
}

bool AlarmProxyModel::removeMultiple(QList<int>& rows)
{
	QList<QModelIndex> mappedRows;
	mappedRows.reserve(rows.size());
	for (auto a: rows) {
		mappedRows.push_back(this->mapToSource(
								 this->index(a, 0)));
	}
	return mSource->removeMultiple(mappedRows);
}

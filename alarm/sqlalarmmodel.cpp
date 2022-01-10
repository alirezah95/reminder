#include "sqlalarmmodel.hpp"
#include <QtSql>
#include <algorithm>

SqlAlarmModel::SqlAlarmModel(QObject *parent)
	: QAbstractListModel(parent)
{
	/*
	 * Alarm table in appdb.db database should be created if it doesn't exists.
	 */
	auto db = mSql.database();
	if (!db.tables().contains("alarm")) {
		QSqlQuery query;
		query.exec(
					"create table if not exists alarm ("
					"time varchar(6),"
					"repeat varchar(20),"
					"active boolean);"
					);
	}

	/*
	 * Setting up mSql to use alarm table, the default submit behavior is left
	 * on OnRowChanged.
	 */
	beginResetModel();
	mSql.setTable("alarm");
	mSql.setEditStrategy(QSqlTableModel::OnManualSubmit);
	if (!mSql.select()) {
		qDebug() << "Error in getting data from database: "
				 << mSql.lastError().text();
		return;
	}
	endResetModel();

}

QHash<int, QByteArray> SqlAlarmModel::roleNames() const
{
	return {
		{ Roles::Time, "time" },
		{ Roles::Repeat, "repeat" },
		{ Roles::Active, "active" }
	};
}

QVariant SqlAlarmModel::data(const QModelIndex &index, int role) const
{
	if (!index.isValid() || index.row() > rowCount())
		return QVariant();

	switch (role) {
		case Roles::Time:
			return mSql.data(mSql.index(index.row(), 0));
		case Roles::Repeat:
			return mSql.data(mSql.index(index.row(), 1));
		case Roles::Active:
			return mSql.data(mSql.index(index.row(), 2));
		default:
			return QVariant();
	}
}

int SqlAlarmModel::rowCount(const QModelIndex &parent) const
{
	if (parent.isValid())
		return 0;
	return mSql.rowCount();
}

Qt::ItemFlags SqlAlarmModel::flags(const QModelIndex& index) const
{
	if (!index.isValid())
		return Qt::NoItemFlags;
	return Qt::ItemIsEditable;
}

bool SqlAlarmModel::setData(const QModelIndex& index, const QVariant& value,
							int role)
{
	if (!index.isValid())
		return false;
	auto res = mSql.setData(mSql.index(index.row(), role - Qt::UserRole - 1),
							value);
	if (!res) {
		return false;
	}
	mSql.submit();
	return true;
}

bool SqlAlarmModel::insert(QString time, QString repeat, bool active)
{
	QSqlRecord record;
	record.append(QSqlField("time"));
	record.append(QSqlField("repeat"));
	record.append(QSqlField("active"));

	record.setValue(0, time);
	record.setValue(1, repeat);
	record.setValue(2, active);

	beginInsertRows(QModelIndex(), rowCount(), rowCount());
	auto res = mSql.insertRecord(-1, record);
	endInsertRows();
	return res;
}

bool SqlAlarmModel::remove(const QModelIndex& row)
{
	qDebug() << "Row removed: " << row.row();
	beginRemoveRows(QModelIndex(), row.row(), row.row());
	auto res = mSql.removeRow(row.row());
	endRemoveRows();
	return res;
}

bool SqlAlarmModel::removeMultiple(QList<QModelIndex>& rows)
{
	/* Items are sorted first. */
	std::sort(rows.begin(), rows.end(), [](const QModelIndex& a,
			  const QModelIndex& b) {
		return a.row() > b.row();
	});
	QString s = "";
	for (auto a: rows) {
		beginRemoveRows(QModelIndex(), a.row(), a.row());
		mSql.removeRow(a.row());
	}
	endRemoveRows();

	return false;
}

//bool SqlAlarmModel::removeAlarm(QString time, QString repeat, bool active)
//{

//}

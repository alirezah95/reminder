#include "timesmodel.hpp"
#include <QtSql>

TimesModel::TimesModel(QObject *parent)
	: QAbstractListModel{parent}
{
	auto defaultDb = QSqlDatabase::database();
	if (!defaultDb.isOpen() && !defaultDb.open()) {
		qDebug() << "Database is not open...";
		return;
	}

	if (!defaultDb.tables().contains("tz")) {
		QSqlQuery query;
		if (!query.exec("create table tz("
				   "tzid text);") ) {
			qDebug() << "Could not create table...";
			return;
		}
	}

	mSql.setTable("tz");
	beginResetModel();
	mSql.select();
	endResetModel();
}

TimesModel::~TimesModel()
{
}

int TimesModel::rowCount(const QModelIndex& parent) const
{
	if (parent.isValid())
		return 0;

	return mSql.rowCount();
}

QVariant TimesModel::data(const QModelIndex& index, int role) const
{
	if (!index.isValid())
		return QVariant();

	QTimeZone zone(mSql.data(index).toByteArray());

	switch (role) {
		case Roles::Country:
			return QLocale::territoryToString(zone.territory());
		case Roles::City: {
				auto zId = zone.id();
				return zId.sliced(zId.indexOf('/') + 1);
			}
		case Roles::Time: {
				QDateTime now;
				now.setTimeZone(zone);
				now.setSecsSinceEpoch(QDateTime::currentSecsSinceEpoch());
				return now.time().toString("hh:mm");
			}
		case Roles::Date: {
				QDateTime now;
				now.setTimeZone(zone);
				now.setSecsSinceEpoch(QDateTime::currentSecsSinceEpoch());
				return now.date().toString("MMM dd");
			}
		default:
			return QVariant();
	}
}

QHash<int, QByteArray> TimesModel::roleNames() const
{
	return {
		{ Roles::Country, "country" },
		{ Roles::City, "city" },
		{ Roles::Time, "time" },
		{ Roles::Date, "date" }
	};
}

bool TimesModel::insert(const QString zoneId)
{
	QTimeZone newZone(zoneId.toUtf8());
	if (!newZone.isValid())
		return false;

	beginInsertRows(QModelIndex(), mSql.rowCount(), mSql.rowCount());
	QSqlRecord newRec;
	newRec.append(QSqlField("tzid"));
	newRec.setValue(0, zoneId);

	auto res = mSql.insertRecord(-1, newRec);
	endInsertRows();
	return res;
}

bool TimesModel::remove(const QModelIndex& indx)
{
	if (!indx.isValid() || indx.row() >= mSql.rowCount() || indx.row() < 0)
		return false;

	beginRemoveRows(QModelIndex(), indx.row(), indx.row());
	auto res = mSql.removeRow(indx.row());
	endRemoveRows();
	return res;
}

void TimesModel::updateTimes()
{
	emit dataChanged(mSql.index(0, 0), mSql.index(mSql.rowCount() - 1, 0),
					 { Roles::Time });
}

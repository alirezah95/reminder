#include "timezonelistmodel.hpp"

TimezoneModel::TimezoneModel(QObject *parent)
	: QAbstractListModel{parent}
{
	const auto& availTz = QTimeZone::availableTimeZoneIds();
	mTimezones.reserve(availTz.size());

	for (auto& tz: availTz) {
		mTimezones.push_back(QTimeZone(tz));
	}
}

int TimezoneModel::rowCount(const QModelIndex& parent) const
{
	if (parent.isValid()) {
		return 0;
	}
	return mTimezones.size();
}

QVariant TimezoneModel::data(const QModelIndex& index, int role) const
{
	if (!index.isValid() || index.row() >= rowCount(QModelIndex())
			|| index.row() < 0) {
		return QVariant();
	}

	switch (role) {
		case Roles::Id:
			return mTimezones[index.row()].id();
		case Roles::Country:
			return QLocale::territoryToString(
						mTimezones[index.row()].territory());
		case Roles::City: {
				QString zone = mTimezones[index.row()].id();
				return zone.sliced(zone.indexOf('/') + 1);
			}
		case Roles::Offset: {
				int minOffset = mTimezones[index.row()].offsetFromUtc(
							QDateTime::currentDateTime()) / 60;
				QString res = "-";
				if (minOffset >= 0) res = "+";
				else minOffset *= -1;

				QString hour = QString::number(int(minOffset / 60));
				if (hour.size() < 2) hour.prepend('0');

				QString min = QString::number(minOffset % 60);
				if (min.size() < 2) min.prepend('0');

				return res + hour + ":" + min;
			}
		default:
			return QVariant();
	}
}

QHash<int, QByteArray> TimezoneModel::roleNames() const
{
	return {
		{ Roles::Id, "id" },
		{ Roles::Country, "country" },
		{ Roles::City, "city" },
		{ Roles::Offset, "offset" }
	};
}

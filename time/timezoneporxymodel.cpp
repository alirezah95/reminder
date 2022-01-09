#include "timezoneporxymodel.hpp"
#include "timezonelistmodel.hpp"

#include <QStringListModel>
#include <QColor>

TimezonePorxyModel::TimezonePorxyModel(QObject *parent)
	: QSortFilterProxyModel{parent},
	  mTzList(new TimezoneModel)
{
	setSourceModel(mTzList);
	setDynamicSortFilter(true);
	setSortCaseSensitivity(Qt::CaseSensitive);
	setSortRole(TimezoneModel::Roles::City);
	sort(0);
	setFilterKeyColumn(0);
	setFilterRole(TimezoneModel::Roles::City);
	setFilterCaseSensitivity(Qt::CaseInsensitive);
}

TimezonePorxyModel::~TimezonePorxyModel()
{
	delete mTzList;
}

bool TimezonePorxyModel::filterAcceptsRow(
		int source_row, const QModelIndex& source_parent) const
{
	auto rowIndx = sourceModel()->index(source_row, 0);

	auto city = sourceModel()->data(rowIndx, TimezoneModel::Roles::City)
			.toString();
	auto country = sourceModel()->data(rowIndx, TimezoneModel::Roles::Country)
			.toString();

	auto cs = filterCaseSensitivity();
	auto pattern = filterRegularExpression().pattern();
	return city.startsWith(pattern, cs) || country.startsWith(pattern, cs);
}

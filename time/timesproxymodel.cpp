#include "timesproxymodel.hpp"
#include "timesmodel.hpp"

TimesProxyModel::TimesProxyModel(QObject *parent)
	: QSortFilterProxyModel{ parent },
	  mTModel{ new TimesModel() }
{
	setSourceModel(mTModel);
	setSortRole(TimesModel::Roles::City);
	sort(0);
}

TimesProxyModel::~TimesProxyModel()
{
	delete mTModel;
}

bool TimesProxyModel::insert(QString zoneId)
{
	return dynamic_cast<TimesModel*>(sourceModel())->insert(zoneId);
}

bool TimesProxyModel::remove(const QModelIndex& index)
{
	if (!index.isValid())
		return false;

	auto sourceIndx = mapToSource(index);
	return dynamic_cast<TimesModel*>(sourceModel())->remove(sourceIndx);
}

void TimesProxyModel::updateTimes()
{
	dynamic_cast<TimesModel*>(sourceModel())->updateTimes();
}

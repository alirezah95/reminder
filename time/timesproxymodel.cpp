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

bool TimesProxyModel::remove(int row)
{
	return dynamic_cast<TimesModel*>(sourceModel())->remove(
				mapToSource(this->index(row, 0)));
}

bool TimesProxyModel::removeMultiple(QList<int>& indexes)
{
	QList<QModelIndex> mappedIndxes;
	mappedIndxes.reserve(indexes.size());
	for (const auto& indx: indexes) {
		mappedIndxes.push_back(this->mapToSource(
								   this->index(indx, 0)));
	}
	return dynamic_cast<TimesModel*>(sourceModel())->removeMultiple(
				mappedIndxes);
}

void TimesProxyModel::updateTimes()
{
	dynamic_cast<TimesModel*>(sourceModel())->updateTimes();
}

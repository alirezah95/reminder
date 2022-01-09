#ifndef TIMEZONEPORXYMODEL_HPP
#define TIMEZONEPORXYMODEL_HPP

#include <QSortFilterProxyModel>

class TimezoneModel;
class QStringListModel;

class TimezonePorxyModel : public QSortFilterProxyModel
{
	Q_OBJECT
public:
	explicit TimezonePorxyModel(QObject *parent = nullptr);
	~TimezonePorxyModel();

	bool filterAcceptsRow(int source_row,
						  const QModelIndex& source_parent) const override;

private:
	TimezoneModel*		mTzList;
	QStringListModel*		mStrModel;
};

#endif // TIMEZONEPORXYMODEL_HPP

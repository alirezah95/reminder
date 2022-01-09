#ifndef TIMESPROXYMODEL_HPP
#define TIMESPROXYMODEL_HPP

#include <QSortFilterProxyModel>

class TimesModel;

class TimesProxyModel : public QSortFilterProxyModel
{
	Q_OBJECT
public:
	explicit TimesProxyModel(QObject *parent = nullptr);
	~TimesProxyModel();

	Q_INVOKABLE bool insert(QString zoneId);
	Q_INVOKABLE bool remove(const QModelIndex& index);

public slots:
	void updateTimes();

private:
	TimesModel*		mTModel;
};

#endif // TIMESPROXYMODEL_HPP

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
	Q_INVOKABLE bool remove(int row);
	Q_INVOKABLE bool removeMultiple(QList<int>& indexes);

public slots:
	void updateTimes();

private:
	TimesModel*		mTModel;
};

#endif // TIMESPROXYMODEL_HPP

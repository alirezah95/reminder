#ifndef TIMESMODEL_HPP
#define TIMESMODEL_HPP

#include <QAbstractListModel>
#include <QSqlTableModel>
#include <QTimeZone>
#include <QSqlQuery>

class TimesModel : public QAbstractListModel
{
	Q_OBJECT
public:
	enum Roles {
		Country = Qt::UserRole + 1,
		City,
		Time,
		Date
	};

	explicit TimesModel(QObject *parent = nullptr);
	~TimesModel();

	int rowCount(const QModelIndex& parent) const override;
	QVariant data(const QModelIndex& index, int role) const override;
	QHash<int, QByteArray> roleNames() const override;

	Q_INVOKABLE bool insert(const QString zoneId);
	Q_INVOKABLE bool remove(const QModelIndex& indx);
	Q_INVOKABLE bool removeMultiple(QList<QModelIndex>& indxes);

public slots:
	void updateTimes();

private:
	QSqlTableModel		mSql;
};

#endif // TIMESMODEL_HPP

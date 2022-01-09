#ifndef TIMEZONESLISTMODEL_HPP
#define TIMEZONESLISTMODEL_HPP

#include <QAbstractListModel>
#include <QTimeZone>

class TimezoneModel : public QAbstractListModel
{
	Q_OBJECT
public:
	enum Roles {
		Id = Qt::UserRole + 1,
		Country,
		City,
		Offset
	};
	explicit TimezoneModel(QObject *parent = nullptr);

	int rowCount(const QModelIndex& parent) const override;
	QVariant data(const QModelIndex& index, int role) const override;
	QHash<int, QByteArray> roleNames() const override;

private:
	QList<QTimeZone>	mTimezones;
};

#endif // TIMEZONESLISTMODEL_HPP

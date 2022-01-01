#ifndef SQLALARMMODEL_HPP
#define SQLALARMMODEL_HPP

#include <QAbstractListModel>
#include <QSqlTableModel>

class SqlAlarmModel : public QAbstractListModel
{
	Q_OBJECT

public:
	enum Roles {
		Time = Qt::UserRole + 1,
		Repeat,
		Active
	};
	explicit SqlAlarmModel(QObject *parent = nullptr);

	QHash<int, QByteArray> roleNames() const override;
	QVariant data(const QModelIndex &index,
				  int role = Qt::DisplayRole) const override;
	int rowCount(const QModelIndex &parent = QModelIndex()) const override;

	Q_INVOKABLE bool insert(QString time, QString repeat, bool active);
	Q_INVOKABLE bool remove(int row);
//	Q_INVOKABLE bool removeAlarm(QString time, QString repeat, bool active);

private:
	QSqlTableModel	mSql;
};

#endif // SQLALARMMODEL_HPP

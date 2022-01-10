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
	Qt::ItemFlags flags(const QModelIndex &index) const override;
	bool setData(const QModelIndex &index, const QVariant &value,
				int role=Qt::EditRole) override;

	Q_INVOKABLE bool insert(QString time, QString repeat, bool active);
	Q_INVOKABLE bool remove(const QModelIndex& row);
	Q_INVOKABLE bool removeMultiple(QList<QModelIndex>& rows);

private:
	QSqlTableModel			mSql;
};

#endif // SQLALARMMODEL_HPP

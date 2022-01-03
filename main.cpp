#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QFontDatabase>
#include <QtSql>
#include <QtCore>
#include <QScreen>
#include <QQmlContext>

#include "alarm/alarmtime.hpp"
#include "qtstatusbar/src/statusbar.h"
#include "alarm/alarmproxymodel.hpp"


int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
	QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

	QGuiApplication app(argc, argv);

	/*
	 * Initializing default sqlite database.
	 */
	auto db = QSqlDatabase::addDatabase("QSQLITE");
	QDir dbPath(QStandardPaths::writableLocation(
				QStandardPaths::AppLocalDataLocation));
	if (!dbPath.exists()) {
		if (dbPath.mkdir(dbPath.absolutePath()) == false) {
			qDebug() << "setting database to memory";
			db.setDatabaseName(":memory:");
		} else {
			db.setDatabaseName(dbPath.absolutePath() + "/appdb.db");
		}
	} else {
		db.setDatabaseName(dbPath.absolutePath() + "/appdb.db");
	}

	AlarmTime at;
	AlarmProxyModel alarmModel;

	qmlRegisterSingletonInstance("reminder", 0, 1, "AlarmModel", &alarmModel);
	qmlRegisterType<StatusBar>("reminder", 0, 1, "StatusBar");
	qmlRegisterSingletonInstance<AlarmTime>("reminder", 0, 1, "AlarmTime",
											&at);

	QQmlApplicationEngine engine;
	const QUrl url(QStringLiteral("qrc:/main.qml"));
	QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
					 &app, [url](QObject *obj, const QUrl &objUrl) {
		if (!obj && url == objUrl)
			QCoreApplication::exit(-1);
	}, Qt::QueuedConnection);

	engine.load(url);

	auto id = QFontDatabase::addApplicationFont(":/assets/DejaVuSans.ttf");
	if (id < 0) {
		qDebug() << "Error in loading font";
		return -1;
	}
	auto defaultFont = QFont(QFontDatabase::applicationFontFamilies(id)[0]);
	app.setFont(defaultFont);

	return app.exec();
}

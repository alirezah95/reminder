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
#include "time/timezoneporxymodel.hpp"
#include "time/timesproxymodel.hpp"


#define UI_MODE_NIGHT_MASK	48
#define UI_MODE_NIGHT_YES	32

bool isAndroidNightModeEnabled() {
#ifdef Q_OS_ANDROID

	QJniObject context = QNativeInterface::QAndroidApplication::context();
	QJniObject resource = context.callObjectMethod(
				"getResources", "()Landroid/content/res/Resources;");
	QJniObject config = resource.callObjectMethod(
				"getConfiguration", "()Landroid/content/res/Configuration;");
	auto uiMode = config.getField<jint>("uiMode") & UI_MODE_NIGHT_MASK;
	return (uiMode == UI_MODE_NIGHT_YES);
#else
	return false;
#endif
}


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
	qmlRegisterSingletonInstance<AlarmTime>("reminder", 0, 1, "AlarmTime", &at);
	qmlRegisterType<TimezonePorxyModel>("time", 0, 1, "TimezonesModel");
	qmlRegisterType<TimesProxyModel>("time", 0, 1, "TimesModel");

	QQmlApplicationEngine engine;
	const QUrl url(QStringLiteral("qrc:/main.qml"));
	QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
					 &app, [url](QObject *obj, const QUrl &objUrl) {
		if (!obj && url == objUrl)
			QCoreApplication::exit(-1);
	}, Qt::QueuedConnection);

	auto root = engine.rootContext();
	root->setContextProperty("androidNightMode",
							 isAndroidNightModeEnabled());

	QFontDatabase::addApplicationFont(":/assets/DejaVuSansMono.ttf");
	auto fontId = QFontDatabase::addApplicationFont(
				":/assets/DejaVuSans.ttf");
	auto font = QFont();
	font.setFamily(QFontDatabase::applicationFontFamilies(fontId).at(0));
	font.setPixelSize(16);
	app.setFont(font);

	engine.load(url);

	return app.exec();
}

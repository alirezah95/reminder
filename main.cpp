#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QFontDatabase>

#include "alarm/alarmtime.hpp"


int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
	QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

	QGuiApplication app(argc, argv);

	QScopedPointer at(new AlarmTime);
	qmlRegisterSingletonInstance<AlarmTime>("alarmtime", 0, 1, "AlarmTime",
											&*at);

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

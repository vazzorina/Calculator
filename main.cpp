#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "backend.h"

#ifdef Q_OS_ANDROID
#include <QtCore/qnativeinterface.h>
#include <QtCore/qjniobject.h>
#endif

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

#ifdef Q_OS_ANDROID
    QNativeInterface::QAndroidApplication::runOnAndroidMainThread([]{
        QJniObject activity =
            QNativeInterface::QAndroidApplication::context();

        if (activity.isValid()) {
            QJniObject window =
                activity.callObjectMethod("getWindow",
                                          "()Landroid/view/Window;");

            window.callMethod<void>("setStatusBarColor",
                                    "(I)V",
                                    0xFF04BFAD);
        }
    });
#endif

    backend backend;

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("backend", &backend);
    engine.loadFromModule("CalculatorAndroid", "Main");


    return app.exec();
}

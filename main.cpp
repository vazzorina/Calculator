#include <QGuiApplication>
#include <QQmlApplicationEngine>

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

    QQmlApplicationEngine engine;
    engine.loadFromModule("CalculatorAndroid", "Main");


    return app.exec();
}

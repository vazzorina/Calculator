#ifndef BACKEND_H
#define BACKEND_H

#include <QObject>
#include <QString>

class backend : public QObject
{
    Q_OBJECT
public:
    explicit backend(QObject *parent = nullptr);
    Q_INVOKABLE QString calculate(const QString &expression);
private:
    double evaluate(std::string expression);
};

#endif // BACKEND_H

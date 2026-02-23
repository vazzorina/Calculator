#include "backend.h"
#include "QString"
#include <stack>
#include <string>

backend::backend(QObject *parent) : QObject(parent) {}

double backend::evaluate(std::string expression) {
    std::stack<double> values;
    std::stack<char> ops;

    // Функция для определения приоритета операций
    auto precedence = [](char op) {
        if (op == '+' || op == '-') return 1;
        if (op == '*' || op == '/' || op == '%') return 2;
        return 0;
    };

    // Функция для выполнения базовой операции
    auto applyOp = [](double a, double b, char op) {
        switch (op) {
        case '+': return a + b;
        case '-': return a - b;
        case '*': return a * b;
        case '/': return b != 0 ? a / b : 0; // Защита от деления на 0
        case '%': return a / 100 * b;
        }
        return 0.0;
    };

    for (int i = 0; i < expression.length(); i++) {
        //проверяем, является ли '-' унарным (только если '-' в начале или после знаков и (
        if (expression[i] == '-' && (i == 0 || expression[i-1] == '('||
            expression[i-1] == '+' || expression[i-1] == '-' ||
            expression[i-1] == '*' || expression[i-1] == '/'))
        {
            std::string val = "-";
            i++;
            // Читаем число после минуса
            while (i < expression.length() && (isdigit(expression[i]) || expression[i] == '.')) {
                val += expression[i++];
            }
            values.push(std::stod(val));
            i--;
        }
        else if (isdigit(expression[i]) || expression[i] == '.') {
            std::string val;
            while (i < expression.length() && (isdigit(expression[i]) || expression[i] == '.')) {
                val += expression[i++];
            }
            values.push(std::stod(val));
            i--;
        }
        else if (expression[i] == '(') {
            ops.push('(');
        }
        else if (expression[i] == ')') {
            while (!ops.empty() && ops.top() != '(') {
                double val2 = values.top();
                values.pop();

                double val1 = values.top();
                values.pop();

                char op = ops.top();
                ops.pop();

                values.push(applyOp(val1, val2, op));
            }
            if (!ops.empty()) ops.pop();
        }
        else {
            while (!ops.empty() && precedence(ops.top()) >= precedence(expression[i])) {
                double val2 = values.top(); values.pop();
                double val1 = values.top(); values.pop();
                char op = ops.top(); ops.pop();
                values.push(applyOp(val1, val2, op));
            }
            ops.push(expression[i]);
        }
    }

    while (!ops.empty()) {
        double val2 = values.top(); values.pop();
        double val1 = values.top(); values.pop();
        char op = ops.top(); ops.pop();
        values.push(applyOp(val1, val2, op));
    }

    return values.empty() ? 0 : values.top();
}

QString backend::calculate(const QString &expression) {
    if (expression.isEmpty()) return "0";

    try {
        double result = evaluate(expression.toStdString());
        return QString::number(result, 'g', 10); //возвращаем без лишних нулей после запятой
    } catch (...) {
        return "Error";
    }
}

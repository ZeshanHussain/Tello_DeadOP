#include <QObject>
#include <QTimer>
#include "tello.hpp" // Include your Tello class definition here

class TelloController : public QObject
{
    Q_OBJECT
public:
    explicit TelloController(QObject *parent = nullptr);

    Q_INVOKABLE void performDroneMovements();

private slots:
    void checkConnection();

private:
    Tello DeadOp; // Assuming you have a Tello object here
    QTimer connectionTimer;
};

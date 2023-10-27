#include "tellocontroller.h"
#include <iostream>
#include<QDebug>

TelloController::TelloController(QObject *parent)
    : QObject(parent)
{
    // Initialize your Tello object if necessary

    // Set up the connection check timer
    connectionTimer.setInterval(5000); // Check every 5 seconds
    connect(&connectionTimer, SIGNAL(timeout()), this, SLOT(checkConnection()));
    connectionTimer.start();
}

void TelloController::checkConnection()
{
    if (!DeadOp.is_connected()) {
        // Attempt to reconnect
        if (!DeadOp.connect("192.168.10.1", 8889)) {
            qWarning() << "Failed to Connect to Drone";
        }
        else {
            qCritical() << "Connection has been Established";

        }
    }
}

void TelloController::performDroneMovements()
{
    // Ensure the connection is established before sending commands
    if (DeadOp.is_connected()) {
        if (DeadOp.takeoff()) {
            std::cout << "deadOp has moved!\n";
            DeadOp.set_speed(20.0);
            DeadOp.move_right(70);
            DeadOp.move_forward(20);
            DeadOp.move_left(70);
            DeadOp.move_back(60);
            DeadOp.move_right(40);
            DeadOp.move_forward(40);
            DeadOp.move_left(20);
            DeadOp.land();
        }
    } else {
        std::cerr << "Tello drone not connected!" << std::endl;
    }
}



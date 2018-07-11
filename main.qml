/*
 * Copyright (C) 2018 - Florent Revest  <revestflo@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.5
import org.asteroid.controls 1.0
import QtSensors 5.3

Application {
    id: app

    centerColor: "#4cd479"
    outerColor: "#1c723a"

    readonly property double radians_to_degrees: 180 / Math.PI

    Accelerometer {
        id: accel
        dataRate: 100
        active:true
        onReadingChanged: {
            var newX = (bubble.x + calcRoll(accel.reading.x, accel.reading.y, accel.reading.z) * .1)
            var newY = (bubble.y - calcPitch(accel.reading.x, accel.reading.y, accel.reading.z) * .1)

            if (isNaN(newX) || isNaN(newY))
                return;

            if (newX < 0)
                newX = 0

            if (newX > app.width - bubble.width)
                newX = app.width - bubble.width

            if (newY < 18)
                newY = 18

            if (newY > app.height - bubble.height)
                newY = app.height - bubble.height

                bubble.x = newX
                bubble.y = newY
        }
    }

    function calcPitch(x,y,z) {
        return -Math.atan2(y, Math.sqrt(x*x+z*z)) * app.radians_to_degrees;
    }
    function calcRoll(x,y,z) {
        return -Math.atan2(x, Math.sqrt(y*y+z*z)) * app.radians_to_degrees;
    }

    Rectangle {
        id: bubble
        color: "red"
        width: Dims.w(10)
        height: Dims.h(10)
        property real centerX: app.width / 2
        property real centerY: app.height / 2
        property real bubbleCenter: bubble.width / 2
        x: centerX - bubbleCenter
        y: centerY - bubbleCenter

        Behavior on y {
            SmoothedAnimation {
                easing.type: Easing.Linear
                duration: 100
            }
        }
        Behavior on x {
            SmoothedAnimation {
                easing.type: Easing.Linear
                duration: 100
            }
        }
    }
}

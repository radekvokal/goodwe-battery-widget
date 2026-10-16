import QtQuick

Canvas {
    id: neonCanvas

    property int batteryPercent: 0
    property bool isCharging: false
    property int barCount: Math.max(0, Math.min(6, Math.ceil(batteryPercent / 16.67)))

    property color neonColor: {
        if (barCount >= 6) return "#00ff66"
        if (barCount === 5) return "#66ff33"
        if (barCount === 4) return "#bbff00"
        if (barCount === 3) return "#ffdd00"
        if (barCount === 2) return "#ff8800"
        return "#ff2266"
    }

    onBatteryPercentChanged: requestPaint()
    onIsChargingChanged: requestPaint()
    onWidthChanged: requestPaint()
    onHeightChanged: requestPaint()

    renderStrategy: Canvas.Cooperative

    onPaint: {
        var ctx = getContext("2d")
        ctx.reset()
        ctx.clearRect(0, 0, width, height)

        var w = width
        var h = height

        var battW = w * 0.82
        var battH = h * 0.52
        var battX = (w - battW) / 2 - w * 0.03
        var battY = (h - battH) / 2
        var nubW = w * 0.06
        var nubH = battH * 0.4
        var cornerR = battH * 0.15
        var lineW = Math.max(2, battH * 0.06)

        var col = neonColor
        var glowCol = Qt.rgba(col.r, col.g, col.b, 0.35)

        // Outer glow
        ctx.save()
        ctx.shadowBlur = battH * 0.35
        ctx.shadowColor = String(col)
        ctx.strokeStyle = String(glowCol)
        ctx.lineWidth = lineW * 2.5
        ctx.lineJoin = "round"
        drawBatteryOutline(ctx, battX, battY, battW, battH, cornerR)
        ctx.stroke()
        // Nub glow
        drawNub(ctx, battX + battW, battY + (battH - nubH) / 2, nubW, nubH, cornerR * 0.5)
        ctx.stroke()
        ctx.restore()

        // Main outline
        ctx.save()
        ctx.shadowBlur = battH * 0.15
        ctx.shadowColor = String(col)
        ctx.strokeStyle = String(col)
        ctx.lineWidth = lineW
        ctx.lineJoin = "round"
        drawBatteryOutline(ctx, battX, battY, battW, battH, cornerR)
        ctx.stroke()
        // Nub
        drawNub(ctx, battX + battW, battY + (battH - nubH) / 2, nubW, nubH, cornerR * 0.5)
        ctx.stroke()
        ctx.restore()

        // Bars
        var barPad = battW * 0.04
        var barGap = battW * 0.02
        var barAreaW = battW - barPad * 2
        var barW = (barAreaW - barGap * 5) / 6
        var barH = battH - barPad * 2.5

        for (var i = 0; i < barCount; i++) {
            var bx = battX + barPad + i * (barW + barGap)
            var by = battY + barPad * 1.25

            // Bar glow
            ctx.save()
            ctx.shadowBlur = battH * 0.25
            ctx.shadowColor = String(col)
            ctx.fillStyle = String(glowCol)
            drawRoundRect(ctx, bx, by, barW, barH, cornerR * 0.3)
            ctx.fill()
            ctx.restore()

            // Bar solid
            ctx.save()
            ctx.shadowBlur = battH * 0.1
            ctx.shadowColor = String(col)
            ctx.fillStyle = String(col)
            drawRoundRect(ctx, bx, by, barW, barH, cornerR * 0.3)
            ctx.fill()
            ctx.restore()
        }

        // Charging bolt icon
        if (isCharging) {
            var boltX = battX + battW * 0.38
            var boltY = battY + battH * 0.1
            var boltW = battW * 0.24
            var boltH = battH * 0.8

            ctx.save()
            ctx.shadowBlur = battH * 0.3
            ctx.shadowColor = "#ffffff"
            ctx.fillStyle = "rgba(255, 255, 255, 0.85)"
            ctx.beginPath()
            ctx.moveTo(boltX + boltW * 0.55, boltY)
            ctx.lineTo(boltX + boltW * 0.15, boltY + boltH * 0.5)
            ctx.lineTo(boltX + boltW * 0.45, boltY + boltH * 0.5)
            ctx.lineTo(boltX + boltW * 0.35, boltY + boltH)
            ctx.lineTo(boltX + boltW * 0.85, boltY + boltH * 0.4)
            ctx.lineTo(boltX + boltW * 0.55, boltY + boltH * 0.4)
            ctx.closePath()
            ctx.fill()
            ctx.restore()
        }
    }

    function drawBatteryOutline(ctx, x, y, w, h, r) {
        ctx.beginPath()
        ctx.moveTo(x + r, y)
        ctx.lineTo(x + w - r, y)
        ctx.arcTo(x + w, y, x + w, y + r, r)
        ctx.lineTo(x + w, y + h - r)
        ctx.arcTo(x + w, y + h, x + w - r, y + h, r)
        ctx.lineTo(x + r, y + h)
        ctx.arcTo(x, y + h, x, y + h - r, r)
        ctx.lineTo(x, y + r)
        ctx.arcTo(x, y, x + r, y, r)
        ctx.closePath()
    }

    function drawNub(ctx, x, y, w, h, r) {
        ctx.beginPath()
        ctx.moveTo(x, y)
        ctx.lineTo(x + w - r, y)
        ctx.arcTo(x + w, y, x + w, y + r, r)
        ctx.lineTo(x + w, y + h - r)
        ctx.arcTo(x + w, y + h, x + w - r, y + h, r)
        ctx.lineTo(x, y + h)
    }

    function drawRoundRect(ctx, x, y, w, h, r) {
        ctx.beginPath()
        ctx.moveTo(x + r, y)
        ctx.lineTo(x + w - r, y)
        ctx.arcTo(x + w, y, x + w, y + r, r)
        ctx.lineTo(x + w, y + h - r)
        ctx.arcTo(x + w, y + h, x + w - r, y + h, r)
        ctx.lineTo(x + r, y + h)
        ctx.arcTo(x, y + h, x, y + h - r, r)
        ctx.lineTo(x, y + r)
        ctx.arcTo(x, y, x + r, y, r)
        ctx.closePath()
    }
}

import QtQuick 2.1
import QtQuick.Layouts 1.1
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

Item {
    readonly property date currentDateTime: dataSource.data.Local ? dataSource.data.Local.DateTime : new Date()
    property var flame_positions: []
    property var flames: []
    property string candle_1: ""
    property string candle_2: ""
    property string candle_3: ""
    property string candle_4: ""
    readonly property date christmas: new Date(new Date().getFullYear() + "-12-24")
    readonly property date advent_4: new Date(christmas.getTime() - (christmas.getDay() % 7) * 24 * 60 * 60 * 1000)
    readonly property date advent_3: new Date(advent_4.getTime() - 7 * 24 * 60 * 60 * 1000)
    readonly property date advent_2: new Date(advent_3.getTime() - 7 * 24 * 60 * 60 * 1000)
    readonly property date advent_1: new Date(advent_2.getTime() - 7 * 24 * 60 * 60 * 1000)
    
    function getCandleFlame(position, on) {
        if (!on) return "\n";
        const topFlame = position % 2 ? ")" : "(";
        const move = new Array(position % 3).fill(" ").join("");
        return " " + move + topFlame + "\n" + move + "(_)";
    }
    
    function getCandleArt(height, number) {
        return flames[number - 1] + "\n.-'-.\n" + Array(height).fill("|   |").map(function (row, index) {
            if (Math.floor(height / 2) === index) return "| " + number + " |";
            return row;
        }).join("\n") + "\n`---'";
    }
    
    function getCandleHeight(initialHeight, adventDate, now) {
        if (now > (christmas.getTime() + 24 * 60 * 60 * 1000)) return 1;
        if (now < adventDate) return initialHeight;
        if (initialHeight === 2) return 2;
        const timediff = advent_4 - adventDate;
        const steps = initialHeight - 2;
        const oneStep = timediff / (initialHeight - 2);
        if (!oneStep) return 2;
        return initialHeight - Math.floor((now - adventDate) / oneStep);
    }
    
    PlasmaCore.DataSource {
        id: dataSource
        engine: "time"
        connectedSources: ["Local"]
        interval: Math.ceil(Math.random() * 50) + 75
    }
    
    onCurrentDateTimeChanged: {
        const now = new Date();
        flame_positions = new Array(4).fill(0).map(function(){return new Date().getTime() % Math.ceil(Math.random() * 6)});
        
        flames[0] = getCandleFlame(flame_positions[0], now > advent_1);
        candle_1 = getCandleArt(getCandleHeight(8, advent_1, now), 1) + "\n" + advent_1.toLocaleString(Qt.locale("de_DE"), "dd.MM");
        
        flames[1] = getCandleFlame(flame_positions[1], now > advent_2);
        candle_2 = getCandleArt(getCandleHeight(6, advent_2, now), 2) + "\n" + advent_2.toLocaleString(Qt.locale("de_DE"), "dd.MM");
        
        flames[2] = getCandleFlame(flame_positions[2], now > advent_3);
        candle_3 = getCandleArt(getCandleHeight(4, advent_3, now), 3) + "\n" + advent_3.toLocaleString(Qt.locale("de_DE"), "dd.MM");
        
        flames[3] = getCandleFlame(flame_positions[3], now > advent_4);
        candle_4 = getCandleArt(getCandleHeight(2, advent_4, now), 4) + "\n" + advent_4.toLocaleString(Qt.locale("de_DE"), "dd.MM");
    }
    
    Plasmoid.fullRepresentation: RowLayout {
        anchors.fill: parent
        spacing: 10
        PlasmaComponents.Label {
            Layout.alignment: Qt.AlignBottom
            text: candle_1
            font.family: "Monospace"
        }
        PlasmaComponents.Label {
            Layout.alignment: Qt.AlignBottom
            text: candle_2
            font.family: "Monospace"
        }
        PlasmaComponents.Label {
            Layout.alignment: Qt.AlignBottom
            text: candle_3
            font.family: "Monospace"
        }
        PlasmaComponents.Label {
            Layout.alignment: Qt.AlignBottom
            text: candle_4
            font.family: "Monospace"
        }
    }
}

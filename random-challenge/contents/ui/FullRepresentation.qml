import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.plasmoid
import "shared" as Shared
import "../js/challenges-data.js" as Data
import "../js/challenge-engine.js" as Engine

Item {
    id: root

    Layout.minimumWidth: Math.max(340, Kirigami.Units.gridUnit * 20)
    Layout.preferredWidth: Math.max(360, Kirigami.Units.gridUnit * 22)
    Layout.minimumHeight: Math.max(460, Kirigami.Units.gridUnit * 26)
    Layout.preferredHeight: Math.max(500, Kirigami.Units.gridUnit * 29)

    implicitWidth: Layout.preferredWidth
    implicitHeight: Layout.preferredHeight
    property bool isDailyMode: false
    property string selectedCategory: typeof plasmoid !== "undefined" && plasmoid.configuration ? plasmoid.configuration.preferredCategory || "All" : "All"
    property string selectedDifficulty: typeof plasmoid !== "undefined" && plasmoid.configuration ? plasmoid.configuration.preferredDifficulty || "All" : "All"
    property string statusMessage: ""
    property var statsData: null
    property var currentChallenge: null

    function loadNextChallenge() {
        if (typeof plasmoid === "undefined") return;
        var excludeId = root.currentChallenge ? root.currentChallenge.id : "";
        root.isDailyMode = false;
        root.currentChallenge = Engine.getRandomChallenge(plasmoid, root.selectedCategory, root.selectedDifficulty, 0, excludeId);
    }

    function loadDailyChallenge() {
        if (typeof plasmoid === "undefined") return;
        root.isDailyMode = true;
        root.currentChallenge = Engine.getDailyChallenge(plasmoid);
    }

    function reloadStats() {
        if (typeof plasmoid === "undefined") return;
        root.statsData = Engine.calculateStatistics(plasmoid);
        if (root.parent && root.parent.completedCount !== undefined) {
            root.parent.completedCount = root.statsData.totalCompleted;
        }
    }

    function showFeedback(msg) {
        root.statusMessage = msg;
        feedbackTimer.restart();
    }

    Timer {
        id: feedbackTimer
        interval: 2500
        repeat: false
        onTriggered: root.statusMessage = ""
    }

    Component.onCompleted: {
        root.reloadStats();
        root.loadDailyChallenge();
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10

        // Header
        Shared.HeaderBar {
            title: i18n("Random Challenge")
            subtitle: i18n("Micro-missions & learning")
            iconName: "games-solve"
            Layout.fillWidth: true

            Shared.MetricBadge {
                text: root.statusMessage !== "" ? root.statusMessage : i18n("%1 Completed", root.statsData ? root.statsData.totalCompleted : 0)
                badgeColor: root.statusMessage !== "" ? "#27ae60" : Kirigami.Theme.highlightColor
                subtle: root.statusMessage === ""
            }

            PlasmaComponents.Button {
                text: i18n("Clear All")
                icon.name: "edit-clear-all"
                visible: root.currentChallenge !== null
                flat: true
                Layout.preferredHeight: 28
                onClicked: {
                    Engine.clearAllChallenges(plasmoid);
                    root.loadNextChallenge();
                    root.showFeedback(i18n("All cleared"));
                }
            }

            PlasmaComponents.Button {
                icon.name: "office-chart-line"
                Layout.preferredWidth: 28
                Layout.preferredHeight: 28
                flat: true
                onClicked: statsDialog.visible = true
            }
        }

        // Mode switch row: Daily Mission vs Random Explorer
        RowLayout {
            Layout.fillWidth: true
            spacing: 6

            PlasmaComponents.Button {
                Layout.fillWidth: true
                text: i18n("Daily Mission")
                icon.name: "rating"
                highlighted: root.isDailyMode
                flat: !root.isDailyMode
                onClicked: root.loadDailyChallenge()
            }

            PlasmaComponents.Button {
                Layout.fillWidth: true
                text: i18n("Random Challenge")
                icon.name: "view-refresh"
                highlighted: !root.isDailyMode
                flat: root.isDailyMode
                onClicked: root.loadNextChallenge()
            }
        }

        // Filter Row
        RowLayout {
            visible: !root.isDailyMode
            Layout.fillWidth: true
            spacing: 6

            QQC2.ComboBox {
                id: categoryCombo
                Layout.fillWidth: true
                model: ["All"].concat(Data.getCategories())
                currentIndex: 0
                onActivated: {
                    root.selectedCategory = currentText;
                    root.loadNextChallenge();
                }
            }

            QQC2.ComboBox {
                id: diffCombo
                Layout.preferredWidth: 120
                model: ["All", "Beginner", "Intermediate", "Advanced"]
                currentIndex: 0
                onActivated: {
                    root.selectedDifficulty = currentText;
                    root.loadNextChallenge();
                }
            }
        }

        // Active Challenge Presentation Card
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            ColumnLayout {
                visible: root.currentChallenge === null
                anchors.centerIn: parent
                spacing: 12

                Shared.EmptyState {
                    Layout.alignment: Qt.AlignHCenter
                    title: i18n("No challenges available")
                    description: i18n("All challenges in this category have been completed or deleted.")
                    iconName: "games-solve"
                }

                PlasmaComponents.Button {
                    Layout.alignment: Qt.AlignHCenter
                    text: i18n("Restore Default Challenges")
                    icon.name: "view-refresh"
                    onClicked: {
                        Engine.resetAllChallenges(plasmoid);
                        root.loadNextChallenge();
                        root.showFeedback(i18n("Challenges restored"));
                    }
                }
            }

            ChallengeCard {
                anchors.fill: parent
                visible: root.currentChallenge !== null
                challenge: root.currentChallenge
                isDaily: root.isDailyMode
                isFav: typeof plasmoid !== "undefined" && root.currentChallenge ? Engine.isFavorite(plasmoid, root.currentChallenge.id) : false

                onCompleteClicked: {
                    if (typeof plasmoid !== "undefined" && root.currentChallenge) {
                        Engine.markCompleted(plasmoid, root.currentChallenge);
                        root.reloadStats();
                        root.showFeedback(i18n("Challenge Completed! 🎉"));
                        root.loadNextChallenge();
                    }
                }

                onNextClicked: {
                    root.loadNextChallenge();
                }

                onSkipClicked: {
                    root.showFeedback(i18n("Challenge Skipped"));
                    root.loadNextChallenge();
                }

                onDeleteClicked: {
                    if (typeof plasmoid !== "undefined" && root.currentChallenge) {
                        Engine.deleteChallenge(plasmoid, root.currentChallenge.id);
                        root.showFeedback(i18n("Challenge deleted"));
                        root.loadNextChallenge();
                    }
                }

                onFavoriteToggled: {
                    if (typeof plasmoid !== "undefined" && root.currentChallenge) {
                        var fav = Engine.toggleFavorite(plasmoid, root.currentChallenge.id);
                        root.showFeedback(fav ? i18n("Added to Favorites ⭐") : i18n("Removed from Favorites"));
                    }
                }
            }
        }
    }

    // Stats & Custom Challenge Overlay Dialog
    StatsDialog {
        id: statsDialog
        anchors.fill: parent
        anchors.margins: 8
        visible: false
        statsData: root.statsData
        historyList: typeof plasmoid !== "undefined" ? Engine.getCompletedHistory(plasmoid) : []

        onClosed: visible = false

        onCustomCreated: function(title, desc, cat, diff, dur) {
            if (typeof plasmoid !== "undefined") {
                Engine.addCustomChallenge(plasmoid, title, desc, cat, diff, dur);
                root.showFeedback(i18n("Custom challenge created!"));
            }
        }
    }
}


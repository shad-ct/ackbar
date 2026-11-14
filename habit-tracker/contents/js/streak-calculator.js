.pragma library

function toDateKey(date) {
    var d = date ? new Date(date) : new Date();
    if (isNaN(d.getTime())) d = new Date();
    var y = d.getFullYear();
    var m = String(d.getMonth() + 1).padStart(2, "0");
    var day = String(d.getDate()).padStart(2, "0");
    return y + "-" + m + "-" + day;
}

function isHabitScheduledOn(habit, date) {
    if (!habit) return false;
    var d = date ? new Date(date) : new Date();
    var startD = habit.startDate ? new Date(habit.startDate) : new Date(0);
    // Before start date, not scheduled
    var dateMidnight = new Date(d.getFullYear(), d.getMonth(), d.getDate());
    var startMidnight = new Date(startD.getFullYear(), startD.getMonth(), startD.getDate());
    if (dateMidnight < startMidnight) return false;

    if (habit.frequencyType === "daily") {
        return true;
    }
    if (habit.frequencyType === "weekdays") {
        var dayOfWeek = d.getDay(); // 0 = Sun, 1 = Mon ...
        var scheduledDays = habit.frequencyDays || [1, 2, 3, 4, 5];
        return scheduledDays.indexOf(dayOfWeek) !== -1;
    }
    if (habit.frequencyType === "weekly_target") {
        // Can be completed on any day toward the target
        return true;
    }
    return true;
}

function isHabitCompletedOn(habit, dateKey) {
    if (!habit || !habit.completions) return false;
    var count = habit.completions[dateKey];
    var target = habit.targetCount || 1;
    return typeof count === "number" && count >= target;
}

function calculateHabitStreak(habit) {
    if (!habit || !habit.completions) {
        return { current: 0, longest: 0 };
    }

    var today = new Date();
    var todayKey = toDateKey(today);
    var currentStreak = 0;

    // Check today: if completed, streak starts at 1
    var checkDate = new Date(today.getFullYear(), today.getMonth(), today.getDate());
    var todayCompleted = isHabitCompletedOn(habit, todayKey);

    if (todayCompleted) {
        currentStreak = 1;
        checkDate.setDate(checkDate.getDate() - 1);
    } else {
        // If not completed today yet, check if yesterday was completed
        checkDate.setDate(checkDate.getDate() - 1);
    }

    // Trace backwards for current streak
    while (true) {
        var key = toDateKey(checkDate);
        var scheduled = isHabitScheduledOn(habit, checkDate);
        if (scheduled) {
            if (isHabitCompletedOn(habit, key)) {
                currentStreak++;
            } else {
                break;
            }
        }
        checkDate.setDate(checkDate.getDate() - 1);
        // Safety cap at 3 years
        if (currentStreak > 1100) break;
    }

    // Longest streak across all recorded completions
    var dates = Object.keys(habit.completions).sort();
    var maxStreak = currentStreak;
    var running = 0;
    var prevDate = null;

    for (var i = 0; i < dates.length; i++) {
        var dKey = dates[i];
        if (habit.completions[dKey] >= (habit.targetCount || 1)) {
            var currD = new Date(dKey);
            if (prevDate) {
                var diffDays = Math.round((currD.getTime() - prevDate.getTime()) / (1000 * 60 * 60 * 24));
                if (diffDays === 1) {
                    running++;
                } else if (diffDays > 1) {
                    running = 1;
                }
            } else {
                running = 1;
            }
            prevDate = currD;
            if (running > maxStreak) {
                maxStreak = running;
            }
        }
    }

    return {
        current: currentStreak,
        longest: Math.max(maxStreak, currentStreak)
    };
}

function calculateGlobalStats(habits) {
    if (!Array.isArray(habits) || habits.length === 0) {
        return {
            todayDone: 0,
            todayTotal: 0,
            todayPercent: 0,
            weeklyRate: 0,
            monthlyRate: 0,
            totalCompletions: 0,
            longestStreak: 0,
            bestHabit: ""
        };
    }

    var today = new Date();
    var todayKey = toDateKey(today);
    var todayDone = 0;
    var todayTotal = 0;
    var totalCompletions = 0;
    var maxStreak = 0;
    var bestHabit = "";

    // Today's count
    for (var i = 0; i < habits.length; i++) {
        var h = habits[i];
        if (isHabitScheduledOn(h, today)) {
            todayTotal++;
            if (isHabitCompletedOn(h, todayKey)) {
                todayDone++;
            }
        }
        var streakInfo = calculateHabitStreak(h);
        if (streakInfo.longest > maxStreak) {
            maxStreak = streakInfo.longest;
            bestHabit = h.name;
        }

        // Count total completions for this habit
        if (h.completions) {
            var keys = Object.keys(h.completions);
            for (var k = 0; k < keys.length; k++) {
                if (h.completions[keys[k]] >= (h.targetCount || 1)) {
                    totalCompletions++;
                }
            }
        }
    }

    // Weekly completion rate (last 7 days)
    var weeklyRate = calculateRateForPeriod(habits, 7);
    // Monthly completion rate (last 30 days)
    var monthlyRate = calculateRateForPeriod(habits, 30);

    return {
        todayDone: todayDone,
        todayTotal: todayTotal,
        todayPercent: todayTotal > 0 ? Math.round((todayDone / todayTotal) * 100) : 0,
        weeklyRate: weeklyRate,
        monthlyRate: monthlyRate,
        totalCompletions: totalCompletions,
        longestStreak: maxStreak,
        bestHabit: bestHabit
    };
}

function calculateRateForPeriod(habits, numDays) {
    var today = new Date();
    var scheduledCount = 0;
    var completedCount = 0;

    for (var d = 0; d < numDays; d++) {
        var checkD = new Date(today.getFullYear(), today.getMonth(), today.getDate() - d);
        var key = toDateKey(checkD);

        for (var i = 0; i < habits.length; i++) {
            var h = habits[i];
            if (isHabitScheduledOn(h, checkD)) {
                scheduledCount++;
                if (isHabitCompletedOn(h, key)) {
                    completedCount++;
                }
            }
        }
    }

    if (scheduledCount === 0) return 0;
    return Math.round((completedCount / scheduledCount) * 100);
}

function generateActivityGridData(habits, totalDays) {
    var days = totalDays || 70;
    var today = new Date();
    var grid = [];

    for (var i = days - 1; i >= 0; i--) {
        var d = new Date(today.getFullYear(), today.getMonth(), today.getDate() - i);
        var key = toDateKey(d);
        var scheduled = 0;
        var completed = 0;

        for (var h = 0; h < habits.length; h++) {
            var habit = habits[h];
            if (isHabitScheduledOn(habit, d)) {
                scheduled++;
                if (isHabitCompletedOn(habit, key)) {
                    completed++;
                }
            }
        }

        var ratio = scheduled > 0 ? completed / scheduled : 0;
        var status = "none";
        if (scheduled > 0) {
            if (completed >= scheduled) {
                status = "full";
            } else if (completed > 0) {
                status = "partial";
            } else {
                status = "missed";
            }
        }

        grid.push({
            dateKey: key,
            dayOfWeek: d.getDay(),
            scheduled: scheduled,
            completed: completed,
            ratio: ratio,
            status: status
        });
    }

    return grid;
}


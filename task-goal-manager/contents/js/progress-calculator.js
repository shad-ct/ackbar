.pragma library

function getMilestoneProgress(milestone, allTasks) {
    if (!milestone) return 0;
    // Find all tasks specifically attached to this milestone
    var linked = (allTasks || []).filter(function(t) {
        return t.milestoneId === milestone.id;
    });

    if (linked.length === 0) {
        // If no subtasks, the milestone's completion is binary (true = 100%, false = 0%)
        return milestone.completed ? 100 : 0;
    }

    var done = 0;
    for (var i = 0; i < linked.length; i++) {
        if (linked[i].status === "Completed") {
            done++;
        }
    }
    return Math.round((done / linked.length) * 100);
}

function calculateGoalProgress(goal, allTasks) {
    if (!goal) return 0;
    if (goal.manualProgress !== undefined && goal.manualProgress >= 0) {
        return goal.manualProgress;
    }

    var milestones = goal.milestones || [];
    if (milestones.length > 0) {
        var totalWeight = 0;
        var weightedSum = 0;

        for (var i = 0; i < milestones.length; i++) {
            var m = milestones[i];
            var weight = m.weight || 1;
            var progress = getMilestoneProgress(m, allTasks);
            weightedSum += progress * weight;
            totalWeight += weight;
        }

        if (totalWeight > 0) {
            return Math.round(weightedSum / totalWeight);
        }
    }

    // If goal has no milestones, calculate directly from tasks linked to goal
    var goalTasks = (allTasks || []).filter(function(t) {
        return t.goalId === goal.id;
    });

    if (goalTasks.length === 0) {
        return goal.status === "Completed" ? 100 : 0;
    }

    var completedTasks = 0;
    for (var j = 0; j < goalTasks.length; j++) {
        if (goalTasks[j].status === "Completed") {
            completedTasks++;
        }
    }
    return Math.round((completedTasks / goalTasks.length) * 100);
}

function computeDashboardMetrics(allTasks, allGoals) {
    var todayKey = new Date().toISOString().substring(0, 10);
    var tasks = allTasks || [];
    var goals = allGoals || [];

    var dueTodayCount = 0;
    var overdueCount = 0;
    var upcomingCount = 0;
    var pendingCount = 0;
    var completedRecent = [];

    // Next 7 days deadline threshold
    var nextWeek = new Date();
    nextWeek.setDate(nextWeek.getDate() + 7);
    var nextWeekKey = nextWeek.toISOString().substring(0, 10);

    for (var i = 0; i < tasks.length; i++) {
        var t = tasks[i];
        if (t.status === "Completed") {
            if (completedRecent.length < 5) {
                completedRecent.push(t);
            }
            continue;
        }

        if (t.status === "Archived") continue;

        pendingCount++;
        if (t.dueDate) {
            if (t.dueDate === todayKey) {
                dueTodayCount++;
            } else if (t.dueDate < todayKey) {
                overdueCount++;
            } else if (t.dueDate <= nextWeekKey) {
                upcomingCount++;
            }
        }
    }

    var activeGoals = goals.filter(function(g) {
        return g.status !== "Completed";
    }).map(function(g) {
        return {
            id: g.id,
            title: g.title,
            category: g.category,
            targetDate: g.targetDate,
            progress: calculateGoalProgress(g, tasks)
        };
    });

    return {
        dueTodayCount: dueTodayCount,
        overdueCount: overdueCount,
        upcomingCount: upcomingCount,
        pendingCount: pendingCount,
        activeGoals: activeGoals,
        completedRecent: completedRecent
    };
}


.pragma library

var DEFAULT_GOALS = [
    {
        id: "goal_drone_01",
        title: "ESP32 Drone Project",
        description: "Autonomous mini quadcopter powered by ESP32 microcontroller",
        category: "Engineering",
        startDate: "2026-01-10",
        targetDate: "2026-12-30",
        status: "Active",
        icon: "preferences-system-bluetooth",
        milestones: [
            { id: "m_drone_1", title: "Component selection", weight: 1, completed: true },
            { id: "m_drone_2", title: "Flight controller firmware", weight: 2, completed: true },
            { id: "m_drone_3", title: "Motor control & ESC signals", weight: 2, completed: false },
            { id: "m_drone_4", title: "PID Stabilization tuning", weight: 2, completed: false },
            { id: "m_drone_5", title: "Flight testing & telemetry", weight: 1, completed: false }
        ]
    },
    {
        id: "goal_juggling_02",
        title: "Learn 3-Ball Juggling",
        description: "Develop hand-eye coordination and learn cascade & tricks",
        category: "Dexterity",
        startDate: "2026-02-01",
        targetDate: "2026-08-30",
        status: "Active",
        icon: "games-solve",
        milestones: [
            { id: "m_jug_1", title: "Master 2-ball scoop", weight: 1, completed: true },
            { id: "m_jug_2", title: "3-ball cascade 20 catches", weight: 2, completed: false },
            { id: "m_jug_3", title: "Over-the-top trick", weight: 1, completed: false }
        ]
    },
    {
        id: "goal_recsys_03",
        title: "Build Movie Recommendation System",
        description: "Collaborative filtering and neural embedding model",
        category: "Machine Learning",
        startDate: "2026-03-01",
        targetDate: "2026-11-20",
        status: "Active",
        icon: "view-media-playlist",
        milestones: [
            { id: "m_rec_1", title: "Dataset preprocessing", weight: 1, completed: true },
            { id: "m_rec_2", title: "Matrix factorization baseline", weight: 2, completed: false },
            { id: "m_rec_3", title: "REST API deployment", weight: 1, completed: false }
        ]
    }
];

var DEFAULT_TASKS = [
    {
        id: "task_01",
        title: "Configure motor drivers",
        description: "Set PWM frequency and calibrate minimum throttle",
        category: "Engineering",
        priority: "Urgent",
        status: "Pending",
        dueDate: new Date().toISOString().substring(0, 10),
        goalId: "goal_drone_01",
        milestoneId: "m_drone_3",
        isRecurring: false,
        subtasks: [
            { id: "sub_1", title: "Verify ESC signal wire continuity", completed: true },
            { id: "sub_2", title: "Set PWM 400Hz frequency", completed: false }
        ],
        createdAt: "2026-03-01T10:00:00Z",
        completedAt: null
    },
    {
        id: "task_02",
        title: "Test ESC signals on oscilloscope",
        description: "Check for voltage spikes and clock jitter",
        category: "Engineering",
        priority: "High",
        status: "Pending",
        dueDate: new Date().toISOString().substring(0, 10),
        goalId: "goal_drone_01",
        milestoneId: "m_drone_3",
        isRecurring: false,
        subtasks: [],
        createdAt: "2026-03-01T10:30:00Z",
        completedAt: null
    },
    {
        id: "task_03",
        title: "Finish ML assignment",
        description: "Complete loss optimization gradient proofs",
        category: "Machine Learning",
        priority: "High",
        status: "Pending",
        dueDate: new Date().toISOString().substring(0, 10),
        goalId: "goal_recsys_03",
        milestoneId: null,
        isRecurring: false,
        subtasks: [],
        createdAt: "2026-03-02T09:00:00Z",
        completedAt: null
    },
    {
        id: "task_04",
        title: "Work on KDE widgets",
        description: "Test Plasma 6 Breeze components integration",
        category: "Development",
        priority: "Medium",
        status: "Pending",
        dueDate: new Date().toISOString().substring(0, 10),
        goalId: null,
        milestoneId: null,
        isRecurring: false,
        subtasks: [],
        createdAt: "2026-03-02T11:00:00Z",
        completedAt: null
    },
    {
        id: "task_05",
        title: "Study orbital mechanics",
        description: "Hohmann transfer orbits and delta-v budgets",
        category: "Physics",
        priority: "Low",
        status: "Pending",
        dueDate: "",
        goalId: null,
        milestoneId: null,
        isRecurring: false,
        subtasks: [],
        createdAt: "2026-03-03T08:00:00Z",
        completedAt: null
    }
];

function generateId(prefix) {
    return (prefix || "id") + "_" + Date.now() + "_" + Math.floor(Math.random() * 10000);
}

function loadTasks(plasmoid) {
    if (!plasmoid || !plasmoid.configuration) return [];
    var hasSeeded = plasmoid.configuration.hasSeeded;
    if (!hasSeeded) {
        plasmoid.configuration.hasSeeded = true;
        saveTasks(plasmoid, DEFAULT_TASKS);
        saveGoals(plasmoid, DEFAULT_GOALS);
        return DEFAULT_TASKS;
    }
    var raw = plasmoid.configuration.tasksData;
    if (!raw) return [];
    try {
        var list = JSON.parse(raw);
        return Array.isArray(list) ? list : [];
    } catch (e) {
        return [];
    }
}

function clearAllTasks(plasmoid) {
    saveTasks(plasmoid, []);
    return [];
}

function saveTasks(plasmoid, tasks) {
    if (!plasmoid || !plasmoid.configuration) return false;
    try {
        plasmoid.configuration.tasksData = JSON.stringify(tasks);
        if (typeof plasmoid.configuration.writeConfig === "function") {
            plasmoid.configuration.writeConfig();
        }
        return true;
    } catch (e) {
        return false;
    }
}

function loadGoals(plasmoid) {
    if (!plasmoid || !plasmoid.configuration) return [];
    var hasSeeded = plasmoid.configuration.hasSeeded;
    if (!hasSeeded) {
        plasmoid.configuration.hasSeeded = true;
        saveTasks(plasmoid, DEFAULT_TASKS);
        saveGoals(plasmoid, DEFAULT_GOALS);
        return DEFAULT_GOALS;
    }
    var raw = plasmoid.configuration.goalsData;
    if (!raw) return [];
    try {
        var list = JSON.parse(raw);
        return Array.isArray(list) ? list : [];
    } catch (e) {
        return [];
    }
}

function clearAllGoals(plasmoid) {
    saveGoals(plasmoid, []);
    return [];
}

function saveGoals(plasmoid, goals) {
    if (!plasmoid || !plasmoid.configuration) return false;
    try {
        plasmoid.configuration.goalsData = JSON.stringify(goals);
        if (typeof plasmoid.configuration.writeConfig === "function") {
            plasmoid.configuration.writeConfig();
        }
        return true;
    } catch (e) {
        return false;
    }
}

function addTask(plasmoid, taskObj) {
    var tasks = loadTasks(plasmoid);
    var newTask = {
        id: generateId("task"),
        title: (taskObj.title || "").trim(),
        description: (taskObj.description || "").trim(),
        category: taskObj.category || "General",
        priority: taskObj.priority || "Medium",
        status: "Pending",
        dueDate: taskObj.dueDate || "",
        goalId: taskObj.goalId || null,
        milestoneId: taskObj.milestoneId || null,
        isRecurring: !!taskObj.isRecurring,
        subtasks: taskObj.subtasks || [],
        createdAt: new Date().toISOString(),
        completedAt: null
    };

    tasks.unshift(newTask);
    saveTasks(plasmoid, tasks);
    return newTask;
}

function toggleTaskComplete(plasmoid, taskId) {
    var tasks = loadTasks(plasmoid);
    for (var i = 0; i < tasks.length; i++) {
        if (tasks[i].id === taskId) {
            if (tasks[i].status === "Completed") {
                tasks[i].status = "Pending";
                tasks[i].completedAt = null;
            } else {
                tasks[i].status = "Completed";
                tasks[i].completedAt = new Date().toISOString();
            }
            saveTasks(plasmoid, tasks);
            return tasks[i];
        }
    }
    return null;
}

function deleteTask(plasmoid, taskId) {
    var tasks = loadTasks(plasmoid);
    var filtered = tasks.filter(function(t) { return t.id !== taskId; });
    saveTasks(plasmoid, filtered);
    return filtered;
}

function addGoal(plasmoid, goalObj) {
    var goals = loadGoals(plasmoid);
    var newGoal = {
        id: generateId("goal"),
        title: (goalObj.title || "").trim(),
        description: (goalObj.description || "").trim(),
        category: goalObj.category || "General",
        startDate: goalObj.startDate || new Date().toISOString().substring(0, 10),
        targetDate: goalObj.targetDate || "",
        status: "Active",
        icon: goalObj.icon || "view-calendar-tasks",
        milestones: goalObj.milestones || []
    };
    goals.unshift(newGoal);
    saveGoals(plasmoid, goals);
    return newGoal;
}

function addMilestone(plasmoid, goalId, title, weight) {
    var goals = loadGoals(plasmoid);
    for (var i = 0; i < goals.length; i++) {
        if (goals[i].id === goalId) {
            if (!goals[i].milestones) goals[i].milestones = [];
            var newM = {
                id: generateId("m"),
                title: title.trim(),
                weight: weight || 1,
                completed: false
            };
            goals[i].milestones.push(newM);
            saveGoals(plasmoid, goals);
            return newM;
        }
    }
    return null;
}

function toggleMilestone(plasmoid, goalId, milestoneId) {
    var goals = loadGoals(plasmoid);
    for (var i = 0; i < goals.length; i++) {
        if (goals[i].id === goalId && goals[i].milestones) {
            for (var m = 0; m < goals[i].milestones.length; m++) {
                if (goals[i].milestones[m].id === milestoneId) {
                    goals[i].milestones[m].completed = !goals[i].milestones[m].completed;
                    saveGoals(plasmoid, goals);
                    return goals[i].milestones[m];
                }
            }
        }
    }
    return null;
}

function deleteMilestone(plasmoid, goalId, milestoneId) {
    var goals = loadGoals(plasmoid);
    for (var i = 0; i < goals.length; i++) {
        if (goals[i].id === goalId && goals[i].milestones) {
            goals[i].milestones = goals[i].milestones.filter(function(m) {
                return m.id !== milestoneId;
            });
            saveGoals(plasmoid, goals);
            break;
        }
    }
}


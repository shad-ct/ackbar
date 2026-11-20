.pragma library

var PROMPT_CATEGORIES = [
    "Deep & Reflective",
    "Funny & Light",
    "Gratitude",
    "Self-Discovery",
    "Creative",
    "Relationships",
    "Work & Career",
    "Morning",
    "Evening",
    "Wild & Weird",
    "Quick Check-In"
];

var DIFFICULTIES = ["Gentle", "Medium", "Deep"];

var INITIAL_PROMPTS = [
    // ---------- Deep & Reflective ----------
    {
        id: "deep_01",
        text: "What is a belief you held strongly five years ago that you've since changed your mind about? Why?",
        category: "Deep & Reflective",
        difficulty: "Deep",
        flavour: "reflective"
    },
    {
        id: "deep_02",
        text: "If you could have a completely honest conversation with your younger self, what would you want them to know?",
        category: "Deep & Reflective",
        difficulty: "Deep",
        flavour: "reflective"
    },
    {
        id: "deep_03",
        text: "What does 'enough' look like for you — in work, in love, in possessions?",
        category: "Deep & Reflective",
        difficulty: "Medium",
        flavour: "reflective"
    },
    {
        id: "deep_04",
        text: "Describe a moment when you felt truly at peace. Where were you, and what made it quiet inside?",
        category: "Deep & Reflective",
        difficulty: "Gentle",
        flavour: "reflective"
    },
    {
        id: "deep_05",
        text: "What are you avoiding because it feels too big to start? What would the tiniest first step be?",
        category: "Deep & Reflective",
        difficulty: "Medium",
        flavour: "reflective"
    },
    {
        id: "deep_06",
        text: "If your life were a book, what would this chapter be titled, and what theme is emerging?",
        category: "Deep & Reflective",
        difficulty: "Medium",
        flavour: "reflective"
    },
    {
        id: "deep_07",
        text: "What part of yourself do you hide from most people, and what would happen if you showed it?",
        category: "Deep & Reflective",
        difficulty: "Deep",
        flavour: "reflective"
    },
    {
        id: "deep_08",
        text: "When did you last feel proud of who you are, not just what you did?",
        category: "Deep & Reflective",
        difficulty: "Gentle",
        flavour: "reflective"
    },
    {
        id: "deep_09",
        text: "What does success mean to you when no one else is watching?",
        category: "Deep & Reflective",
        difficulty: "Medium",
        flavour: "reflective"
    },
    {
        id: "deep_10",
        text: "Write a letter to the person you were at your lowest point. What would you say to them?",
        category: "Deep & Reflective",
        difficulty: "Deep",
        flavour: "reflective"
    },
    {
        id: "deep_11",
        text: "What is one thing you've never told anyone because you're afraid of how they'd react?",
        category: "Deep & Reflective",
        difficulty: "Deep",
        flavour: "reflective"
    },
    {
        id: "deep_12",
        text: "If you had to let go of one responsibility today, what would it be and how would you feel?",
        category: "Deep & Reflective",
        difficulty: "Medium",
        flavour: "reflective"
    },

    // ---------- Funny & Light ----------
    {
        id: "funny_01",
        text: "If your pet (or a stuffed animal) could talk for one hour, what would they complain about most?",
        category: "Funny & Light",
        difficulty: "Gentle",
        flavour: "humorous"
    },
    {
        id: "funny_02",
        text: "What is the most ridiculous thing you've ever done to avoid a phone call?",
        category: "Funny & Light",
        difficulty: "Gentle",
        flavour: "humorous"
    },
    {
        id: "funny_03",
        text: "Describe your life as a genre of movie. Who plays you, and what's the absurd plot twist?",
        category: "Funny & Light",
        difficulty: "Medium",
        flavour: "humorous"
    },
    {
        id: "funny_04",
        text: "If you had to eat one meal for the rest of your life, what would it be and how long before you hated it?",
        category: "Funny & Light",
        difficulty: "Gentle",
        flavour: "humorous"
    },
    {
        id: "funny_05",
        text: "What is your 'villain origin story' — the small, petty moment that shaped your dark side?",
        category: "Funny & Light",
        difficulty: "Medium",
        flavour: "humorous"
    },
    {
        id: "funny_06",
        text: "Rank these from worst to best: pineapple on pizza, socks with sandals, Comic Sans. Defend your choices.",
        category: "Funny & Light",
        difficulty: "Gentle",
        flavour: "humorous"
    },
    {
        id: "funny_07",
        text: "If your to-do list had a personality, what kind of person would it be — a drill sergeant, a flake, or a chaotic best friend?",
        category: "Funny & Light",
        difficulty: "Gentle",
        flavour: "humorous"
    },
    {
        id: "funny_08",
        text: "What is the weirdest thing you believed as a child, and how old were you when you stopped?",
        category: "Funny & Light",
        difficulty: "Gentle",
        flavour: "humorous"
    },
    {
        id: "funny_09",
        text: "If animals could talk, which species would be the rudest, and which would give the best life advice?",
        category: "Funny & Light",
        difficulty: "Gentle",
        flavour: "humorous"
    },
    {
        id: "funny_10",
        text: "What is a product that definitely does not exist but absolutely should? Sell it to me in one sentence.",
        category: "Funny & Light",
        difficulty: "Medium",
        flavour: "humorous"
    },
    {
        id: "funny_11",
        text: "What is the most embarrassing thing you've done that you thought no one saw?",
        category: "Funny & Light",
        difficulty: "Medium",
        flavour: "humorous"
    },
    {
        id: "funny_12",
        text: "If you were a ghost haunting a place, where would you haunt and what would you do to annoy people?",
        category: "Funny & Light",
        difficulty: "Gentle",
        flavour: "humorous"
    },

    // ---------- Gratitude ----------
    {
        id: "grat_01",
        text: "Name three small things today that made your life slightly easier.",
        category: "Gratitude",
        difficulty: "Gentle",
        flavour: "gratitude"
    },
    {
        id: "grat_02",
        text: "Who is someone you rarely thank but probably should? What would you say to them?",
        category: "Gratitude",
        difficulty: "Medium",
        flavour: "gratitude"
    },
    {
        id: "grat_03",
        text: "What is a simple pleasure you often take for granted — hot water, a good pillow, a working internet connection?",
        category: "Gratitude",
        difficulty: "Gentle",
        flavour: "gratitude"
    },
    {
        id: "grat_04",
        text: "What did your body let you do today that you didn't have to think about?",
        category: "Gratitude",
        difficulty: "Gentle",
        flavour: "gratitude"
    },
    {
        id: "grat_05",
        text: "List five things in your home that genuinely spark joy when you see them.",
        category: "Gratitude",
        difficulty: "Gentle",
        flavour: "gratitude"
    },
    {
        id: "grat_06",
        text: "What is something about your hometown or current city that you actually like?",
        category: "Gratitude",
        difficulty: "Gentle",
        flavour: "gratitude"
    },
    {
        id: "grat_07",
        text: "Who made you laugh recently, and what was the moment?",
        category: "Gratitude",
        difficulty: "Gentle",
        flavour: "gratitude"
    },
    {
        id: "grat_08",
        text: "What is a lesson you learned the hard way that you're now grateful for?",
        category: "Gratitude",
        difficulty: "Medium",
        flavour: "gratitude"
    },
    {
        id: "grat_09",
        text: "Describe a stranger who did something small but kind for you. Did you thank them?",
        category: "Gratitude",
        difficulty: "Medium",
        flavour: "gratitude"
    },
    {
        id: "grat_10",
        text: "What part of your daily routine do you secretly enjoy?",
        category: "Gratitude",
        difficulty: "Gentle",
        flavour: "gratitude"
    },

    // ---------- Self-Discovery ----------
    {
        id: "self_01",
        text: "What is a quality you admire in others that you suspect you also have?",
        category: "Self-Discovery",
        difficulty: "Medium",
        flavour: "reflective"
    },
    {
        id: "self_02",
        text: "When do you feel most like 'yourself'? What are you doing, and who are you with?",
        category: "Self-Discovery",
        difficulty: "Medium",
        flavour: "reflective"
    },
    {
        id: "self_03",
        text: "What is a compliment you've received that you didn't fully believe at the time — but now do?",
        category: "Self-Discovery",
        difficulty: "Gentle",
        flavour: "reflective"
    },
    {
        id: "self_04",
        text: "If you had a completely free Saturday with no obligations, how would you spend it?",
        category: "Self-Discovery",
        difficulty: "Gentle",
        flavour: "reflective"
    },
    {
        id: "self_05",
        text: "What is a habit you have that serves you, and one that doesn't?",
        category: "Self-Discovery",
        difficulty: "Medium",
        flavour: "reflective"
    },
    {
        id: "self_06",
        text: "What makes you lose track of time? What does that tell you about what matters to you?",
        category: "Self-Discovery",
        difficulty: "Medium",
        flavour: "reflective"
    },
    {
        id: "self_07",
        text: "What is something you're curious about but haven't tried yet? What's stopping you?",
        category: "Self-Discovery",
        difficulty: "Gentle",
        flavour: "reflective"
    },
    {
        id: "self_08",
        text: "Describe yourself using only metaphors — 'I am a...', 'I am like a...'",
        category: "Self-Discovery",
        difficulty: "Medium",
        flavour: "creative"
    },
    {
        id: "self_09",
        text: "What boundary do you need to set or reinforce in your life right now?",
        category: "Self-Discovery",
        difficulty: "Deep",
        flavour: "reflective"
    },
    {
        id: "self_10",
        text: "What version of yourself are you becoming, and do you like them?",
        category: "Self-Discovery",
        difficulty: "Deep",
        flavour: "reflective"
    },

    // ---------- Creative ----------
    {
        id: "cre_01",
        text: "Invent a holiday. What is it called, how do you celebrate it, and what do people eat?",
        category: "Creative",
        difficulty: "Gentle",
        flavour: "creative"
    },
    {
        id: "cre_02",
        text: "Describe the view outside your window as if it were a fantasy world.",
        category: "Creative",
        difficulty: "Gentle",
        flavour: "creative"
    },
    {
        id: "cre_03",
        text: "Write a six-word story about today.",
        category: "Creative",
        difficulty: "Gentle",
        flavour: "creative"
    },
    {
        id: "cre_04",
        text: "If your mood were a colour today, what would it be and why?",
        category: "Creative",
        difficulty: "Gentle",
        flavour: "creative"
    },
    {
        id: "cre_05",
        text: "Design your perfect café. What does it smell like, what's on the menu, and what's the weirdest rule?",
        category: "Creative",
        difficulty: "Medium",
        flavour: "creative"
    },
    {
        id: "cre_06",
        text: "Write a short dialogue between your coffee and your alarm clock.",
        category: "Creative",
        difficulty: "Gentle",
        flavour: "humorous"
    },
    {
        id: "cre_07",
        text: "You wake up and can speak one new language fluently. Which one, and what's the first thing you say?",
        category: "Creative",
        difficulty: "Gentle",
        flavour: "creative"
    },
    {
        id: "cre_08",
        text: "Draw (in words) a map of your ideal neighbourhood. What's on every corner?",
        category: "Creative",
        difficulty: "Medium",
        flavour: "creative"
    },
    {
        id: "cre_09",
        text: "If you could instantly master any instrument, which one, and what's the first song you'd play?",
        category: "Creative",
        difficulty: "Gentle",
        flavour: "creative"
    },
    {
        id: "cre_10",
        text: "Write the back-cover blurb for the autobiography of your life so far.",
        category: "Creative",
        difficulty: "Medium",
        flavour: "creative"
    },

    // ---------- Relationships ----------
    {
        id: "rel_01",
        text: "Who is someone you miss but haven't contacted in a while? What's one thing you'd say to them?",
        category: "Relationships",
        difficulty: "Medium",
        flavour: "reflective"
    },
    {
        id: "rel_02",
        text: "What is a small way someone showed you they care recently?",
        category: "Relationships",
        difficulty: "Gentle",
        flavour: "gratitude"
    },
    {
        id: "rel_03",
        text: "What quality do you most value in a friend, and do you embody it yourself?",
        category: "Relationships",
        difficulty: "Medium",
        flavour: "reflective"
    },
    {
        id: "rel_04",
        text: "Describe a conversation you had recently that stuck with you. Why did it linger?",
        category: "Relationships",
        difficulty: "Medium",
        flavour: "reflective"
    },
    {
        id: "rel_05",
        text: "If you could introduce one person from your life to one famous person (dead or alive), who and who?",
        category: "Relationships",
        difficulty: "Gentle",
        flavour: "creative"
    },
    {
        id: "rel_06",
        text: "What is something you wish more people understood about you?",
        category: "Relationships",
        difficulty: "Medium",
        flavour: "reflective"
    },
    {
        id: "rel_07",
        text: "Who is the easiest person to be silent with, and what does that silence feel like?",
        category: "Relationships",
        difficulty: "Gentle",
        flavour: "reflective"
    },
    {
        id: "rel_08",
        text: "Write a thank-you note to someone who shaped who you are today.",
        category: "Relationships",
        difficulty: "Medium",
        flavour: "gratitude"
    },

    // ---------- Work & Career ----------
    {
        id: "work_01",
        text: "What part of your work (paid or unpaid) feels meaningful, even if just a little?",
        category: "Work & Career",
        difficulty: "Medium",
        flavour: "reflective"
    },
    {
        id: "work_02",
        text: "If you could redesign your ideal workday from scratch, what would it include — and what would it ban?",
        category: "Work & Career",
        difficulty: "Medium",
        flavour: "creative"
    },
    {
        id: "work_03",
        text: "What is a skill you use every day that no one ever taught you formally?",
        category: "Work & Career",
        difficulty: "Gentle",
        flavour: "reflective"
    },
    {
        id: "work_04",
        text: "What is one thing you'd like to learn or improve at work this month?",
        category: "Work & Career",
        difficulty: "Gentle",
        flavour: "reflective"
    },
    {
        id: "work_05",
        text: "Describe a moment at work when you felt genuinely proud.",
        category: "Work & Career",
        difficulty: "Gentle",
        flavour: "reflective"
    },
    {
        id: "work_06",
        text: "If your job had a theme song, what would it be and why?",
        category: "Work & Career",
        difficulty: "Gentle",
        flavour: "humorous"
    },

    // ---------- Morning ----------
    {
        id: "morn_01",
        text: "What is one thing you're looking forward to today?",
        category: "Morning",
        difficulty: "Gentle",
        flavour: "reflective"
    },
    {
        id: "morn_02",
        text: "How do you want to feel by the end of today? What small choice can help that happen?",
        category: "Morning",
        difficulty: "Gentle",
        flavour: "reflective"
    },
    {
        id: "morn_03",
        text: "What is your ideal first 15 minutes of the day, and how close did you come to it today?",
        category: "Morning",
        difficulty: "Gentle",
        flavour: "reflective"
    },
    {
        id: "morn_04",
        text: "Set one intention for today — not a task, but a way of being.",
        category: "Morning",
        difficulty: "Gentle",
        flavour: "reflective"
    },

    // ---------- Evening ----------
    {
        id: "eve_01",
        text: "What went well today, no matter how small?",
        category: "Evening",
        difficulty: "Gentle",
        flavour: "gratitude"
    },
    {
        id: "eve_02",
        text: "What is one thing you'd do differently if you could live today again?",
        category: "Evening",
        difficulty: "Medium",
        flavour: "reflective"
    },
    {
        id: "eve_03",
        text: "What are you looking forward to tomorrow?",
        category: "Evening",
        difficulty: "Gentle",
        flavour: "reflective"
    },
    {
        id: "eve_04",
        text: "What did you consume today (food, media, conversation) that left you feeling good?",
        category: "Evening",
        difficulty: "Gentle",
        flavour: "reflective"
    },
    {
        id: "eve_05",
        text: "What can you let go of from today before you sleep?",
        category: "Evening",
        difficulty: "Medium",
        flavour: "reflective"
    },

    // ---------- Wild & Weird ----------
    {
        id: "wild_01",
        text: "If you were a vegetable, which one would you be and why?",
        category: "Wild & Weird",
        difficulty: "Gentle",
        flavour: "humorous"
    },
    {
        id: "wild_02",
        text: "You discover a door in your home that wasn't there yesterday. Where does it lead?",
        category: "Wild & Weird",
        difficulty: "Gentle",
        flavour: "creative"
    },
    {
        id: "wild_03",
        text: "If you had to be trapped in a TV show for a month, which one, and what role would you play?",
        category: "Wild & Weird",
        difficulty: "Gentle",
        flavour: "humorous"
    },
    {
        id: "wild_04",
        text: "What is the strangest food combination you secretly enjoy?",
        category: "Wild & Weird",
        difficulty: "Gentle",
        flavour: "humorous"
    },
    {
        id: "wild_05",
        text: "If you could time-travel for exactly one hour, when and where would you go — and what's the rule you must not break?",
        category: "Wild & Weird",
        difficulty: "Medium",
        flavour: "creative"
    },
    {
        id: "wild_06",
        text: "Describe your life as a weather forecast for the next week.",
        category: "Wild & Weird",
        difficulty: "Gentle",
        flavour: "creative"
    },
    {
        id: "wild_07",
        text: "If you had a personal mascot, what would it look like and what would its catchphrase be?",
        category: "Wild & Weird",
        difficulty: "Gentle",
        flavour: "humorous"
    },
    {
        id: "wild_08",
        text: "You're hosting a dinner party with three fictional characters. Who's coming, and what goes wrong?",
        category: "Wild & Weird",
        difficulty: "Medium",
        flavour: "humorous"
    },

    // ---------- Quick Check-In ----------
    {
        id: "quick_01",
        text: "How are you, really?",
        category: "Quick Check-In",
        difficulty: "Gentle",
        flavour: "reflective"
    },
    {
        id: "quick_02",
        text: "What is one word to describe your mood right now?",
        category: "Quick Check-In",
        difficulty: "Gentle",
        flavour: "reflective"
    },
    {
        id: "quick_03",
        text: "What does your body need right now — rest, movement, water, food, air?",
        category: "Quick Check-In",
        difficulty: "Gentle",
        flavour: "reflective"
    },
    {
        id: "quick_04",
        text: "What is one thing you can do in the next ten minutes to be kind to yourself?",
        category: "Quick Check-In",
        difficulty: "Gentle",
        flavour: "reflective"
    },
    {
        id: "quick_05",
        text: "On a scale of 1 to 10, how present do you feel right now?",
        category: "Quick Check-In",
        difficulty: "Gentle",
        flavour: "reflective"
    }
];

function getCategories() {
    return PROMPT_CATEGORIES;
}

function getDifficulties() {
    return DIFFICULTIES;
}

function getInitialPrompts() {
    return INITIAL_PROMPTS;
}

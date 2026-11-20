.pragma library

var CATEGORIES = [
    "Programming",
    "Mathematics",
    "Physics",
    "Chemistry",
    "Astronomy",
    "Logic and puzzles",
    "Cryptography",
    "Chess",
    "Memory",
    "Dexterity",
    "Origami",
    "Language learning",
    "Creative writing",
    "General knowledge",
    "Fitness and strength",
    "Cardiovascular endurance",
    "Martial arts and self defense",
    "Dance and movement",
    "Yoga and flexibility",
    "Swimming and aquatics",
    "Cycling",
    "Running and track",
    "Calisthenics",
    "Outdoor and adventure",
    "Team sports",
    "Racket sports",
    "Balance and coordination",
    "Breathwork and recovery",
    "Gymnastics"
];

var DIFFICULTIES = ["Beginner", "Intermediate", "Advanced"];

var INITIAL_CHALLENGES = [
    // 1. Programming (8)
    {
        id: "prog_01",
        title: "Implement a Binary Search Algorithm",
        description: "Write an iterative binary search function in your language of choice that returns the index of a target value or -1 if absent. Test it with odd and even length arrays.",
        category: "Programming",
        difficulty: "Beginner",
        duration: 15
    },
    {
        id: "prog_02",
        title: "LRU Cache from Scratch",
        description: "Design and implement a Least Recently Used (LRU) Cache with get and put methods in O(1) time complexity using a hash map and a doubly linked list.",
        category: "Programming",
        difficulty: "Advanced",
        duration: 45
    },
    {
        id: "prog_03",
        title: "Build a Custom Event Emitter",
        description: "Implement a lightweight publish-subscribe Event Emitter supporting .on(event, listener), .off(event, listener), and .emit(event, ...args).",
        category: "Programming",
        difficulty: "Intermediate",
        duration: 25
    },
    {
        id: "prog_04",
        title: "Tail-Call Optimized Factorial & Fibonacci",
        description: "Write recursive implementations of factorial and nth-Fibonacci that utilize tail-call recursion with accumulator arguments to prevent stack overflow.",
        category: "Programming",
        difficulty: "Intermediate",
        duration: 20
    },
    {
        id: "prog_05",
        title: "Write a Simple Markdown-to-HTML Parser",
        description: "Create a regex or state-machine parser that converts headers (#, ##), bold (**text**), italics (*text*), and inline code backticks into valid HTML tags.",
        category: "Programming",
        difficulty: "Intermediate",
        duration: 35
    },
    {
        id: "prog_06",
        title: "Bit Manipulation Tricks",
        description: "Write functions to check if an integer is a power of two using a single bitwise operation (n & (n - 1) == 0) and count set bits using Brian Kernighan's algorithm.",
        category: "Programming",
        difficulty: "Beginner",
        duration: 15
    },
    {
        id: "prog_07",
        title: "Thread-Safe Producer-Consumer Queue",
        description: "Implement a bounded thread-safe queue using condition variables and mutex locks, ensuring consumers block when empty and producers block when full.",
        category: "Programming",
        difficulty: "Advanced",
        duration: 45
    },
    {
        id: "prog_08",
        title: "Write a Roman Numeral Converter",
        description: "Write two functions: one converting integers (1 to 3999) to standard Roman numerals, and another parsing Roman numeral strings back into integers.",
        category: "Programming",
        difficulty: "Beginner",
        duration: 20
    },

    // 2. Mathematics (8)
    {
        id: "math_01",
        title: "Derive the Quadratic Formula",
        description: "Start from the general second-degree polynomial ax² + bx + c = 0 and derive the quadratic formula step-by-step by completing the square.",
        category: "Mathematics",
        difficulty: "Beginner",
        duration: 15
    },
    {
        id: "math_02",
        title: "Prove the Infinitude of Prime Numbers",
        description: "Write out Euclid's classic proof by contradiction that there are infinitely many primes by considering the integer N = (p₁ · p₂ · ... · pₖ) + 1.",
        category: "Mathematics",
        difficulty: "Intermediate",
        duration: 20
    },
    {
        id: "math_03",
        title: "Calculate Eigenvalues of a 2x2 Matrix",
        description: "Given a 2x2 matrix [[4, 2], [1, 3]], calculate its characteristic polynomial det(A - λI) = 0, find both eigenvalues, and determine their corresponding eigenvectors.",
        category: "Mathematics",
        difficulty: "Intermediate",
        duration: 25
    },
    {
        id: "math_04",
        title: "Euler's Formula Proof via Taylor Series",
        description: "Expand e^(ix), cos(x), and sin(x) as Taylor series centered at zero to verify and prove Euler's identity e^(ix) = cos(x) + i·sin(x).",
        category: "Mathematics",
        difficulty: "Advanced",
        duration: 30
    },
    {
        id: "math_05",
        title: "The Birthday Paradox Calculation",
        description: "Calculate the exact probability that in a room of 23 randomly chosen people, at least two share the same birthday, by evaluating 1 - (365! / (365²³ · (365 - 23)!)).",
        category: "Mathematics",
        difficulty: "Beginner",
        duration: 15
    },
    {
        id: "math_06",
        title: "Compute the Collatz Conjecture Trajectory",
        description: "Choose 3 different two-digit numbers (including 27) and manually trace their Collatz trajectories (if even n/2, if odd 3n+1) until reaching the 4-2-1 loop.",
        category: "Mathematics",
        difficulty: "Beginner",
        duration: 15
    },
    {
        id: "math_07",
        title: "Bayes' Theorem Diagnostic Problem",
        description: "Solve this Bayesian problem: A disease has 0.1% prevalence. A test has 99% sensitivity and 95% specificity. If someone tests positive, compute the posterior probability they actually have it.",
        category: "Mathematics",
        difficulty: "Intermediate",
        duration: 25
    },
    {
        id: "math_08",
        title: "Prove the Golden Ratio Continued Fraction",
        description: "Express φ = (1 + √5)/2 as an infinite continued fraction [1; 1, 1, 1, ...] by setting x = 1 + 1/x and solving the resulting algebraic equation.",
        category: "Mathematics",
        difficulty: "Advanced",
        duration: 25
    },

    // 3. Physics (8)
    {
        id: "phys_01",
        title: "Calculate Orbital Velocity at LEO",
        description: "Calculate the orbital speed v = √(GM/r) for a satellite orbiting in Low Earth Orbit at an altitude of 400 km (Earth mass = 5.972 × 10²⁴ kg, radius = 6371 km).",
        category: "Physics",
        difficulty: "Intermediate",
        duration: 20
    },
    {
        id: "phys_02",
        title: "Analyze a Simple Harmonic Pendulum",
        description: "Set up a lightweight mass on a string of measured length L. Measure the period for 20 oscillations, calculate T = 2π√(L/g), and solve for local gravitational acceleration g.",
        category: "Physics",
        difficulty: "Beginner",
        duration: 20
    },
    {
        id: "phys_03",
        title: "Special Relativity Time Dilation",
        description: "Calculate the Lorentz factor γ = 1 / √(1 - v²/c²) for a particle travelling at 0.8c, and determine how much time passes in the lab frame for 1 hour on the particle's clock.",
        category: "Physics",
        difficulty: "Beginner",
        duration: 15
    },
    {
        id: "phys_04",
        title: "Snell's Law of Refraction Calculation",
        description: "Light passes from crown glass (n₁ = 1.52) into air (n₂ = 1.00). Calculate the critical angle for total internal reflection using θ_c = arcsin(n₂ / n₁).",
        category: "Physics",
        difficulty: "Beginner",
        duration: 15
    },
    {
        id: "phys_05",
        title: "Black Hole Event Horizon Radius",
        description: "Calculate the Schwarzschild radius r_s = 2GM / c² for an object with the mass of our Sun (M = 1.989 × 10³⁰ kg) and the mass of the Earth.",
        category: "Physics",
        difficulty: "Intermediate",
        duration: 20
    },
    {
        id: "phys_06",
        title: "Carnot Engine Maximum Efficiency",
        description: "For a heat engine operating between a boiler at 450°C and a coolant river at 20°C, convert temperatures to Kelvin and compute maximum theoretical thermodynamic efficiency η = 1 - T_C/T_H.",
        category: "Physics",
        difficulty: "Intermediate",
        duration: 15
    },
    {
        id: "phys_07",
        title: "Rutherford Scattering Impact Parameter",
        description: "Derive the relationship between the scattering angle θ and the impact parameter b for Coulomb repulsion between an alpha particle and an atomic gold nucleus.",
        category: "Physics",
        difficulty: "Advanced",
        duration: 40
    },
    {
        id: "phys_08",
        title: "Calculate Doppler Shift for Moving Star",
        description: "A star emitting Hydrogen-alpha light at rest wavelength 656.3 nm is observed at 657.1 nm. Determine whether the star is moving toward or away from Earth and calculate its radial velocity.",
        category: "Physics",
        difficulty: "Intermediate",
        duration: 20
    },

    // 4. Chemistry (8)
    {
        id: "chem_01",
        title: "Balance a Redox Reaction with Half-Reactions",
        description: "Balance the reaction between permanganate (MnO₄⁻) and iron(II) (Fe²⁺) in acidic solution to form Mn²⁺ and Fe³⁺ using the oxidation state half-reaction method.",
        category: "Chemistry",
        difficulty: "Intermediate",
        duration: 20
    },
    {
        id: "chem_02",
        title: "Calculate Buffer pH via Henderson-Hasselbalch",
        description: "Calculate the pH of an aqueous solution containing 0.15 M acetic acid (pKa = 4.76) and 0.25 M sodium acetate using pH = pKa + log([A⁻]/[HA]).",
        category: "Chemistry",
        difficulty: "Beginner",
        duration: 15
    },
    {
        id: "chem_03",
        title: "Draw Lewis Structure & VSEPR Geometry of SF₄",
        description: "Count valence electrons for sulfur tetrafluoride (SF₄), draw the Lewis electron dot structure including formal charges, and predict the molecular geometry (seesaw) and bond angles.",
        category: "Chemistry",
        difficulty: "Intermediate",
        duration: 20
    },
    {
        id: "chem_04",
        title: "Calculate Gibbs Free Energy & Spontaneity",
        description: "Given ΔH° = -92.2 kJ/mol and ΔS° = -198.7 J/(mol·K) for the Haber ammonia synthesis, calculate ΔG° = ΔH° - TΔS° at 298 K and determine if the reaction is spontaneous at room temperature.",
        category: "Chemistry",
        difficulty: "Intermediate",
        duration: 20
    },
    {
        id: "chem_05",
        title: "Determine Empirical Formula from Combustion Data",
        description: "Combustion of a 1.50 g hydrocarbon sample yields 4.40 g of CO₂ and 2.70 g of H₂O. Calculate the molar quantities of C and H and determine the empirical formula.",
        category: "Chemistry",
        difficulty: "Beginner",
        duration: 20
    },
    {
        id: "chem_06",
        title: "Name Organic Isomers of Pentane",
        description: "Draw the skeletal structural formulas for all 3 structural isomers of pentane (C₅H₁₂), name each according to IUPAC nomenclature, and explain why their boiling points differ.",
        category: "Chemistry",
        difficulty: "Beginner",
        duration: 15
    },
    {
        id: "chem_07",
        title: "SN1 vs SN2 Reaction Mechanism Analysis",
        description: "Compare substitution mechanisms for 2-bromopropane reacting with hydroxide vs tert-butyl bromide. Diagram transition states, stereochemical outcomes (inversion vs racemization), and rate laws.",
        category: "Chemistry",
        difficulty: "Advanced",
        duration: 35
    },
    {
        id: "chem_08",
        title: "Calculate Cell Potential via Nernst Equation",
        description: "Calculate the reduction potential at 298 K for a Zn/Cu electrochemical cell when [Zn²⁺] = 0.010 M and [Cu²⁺] = 2.0 M using E = E° - (0.0592/n)·log(Q).",
        category: "Chemistry",
        difficulty: "Advanced",
        duration: 30
    },

    // 5. Astronomy (8)
    {
        id: "astr_01",
        title: "Locate Polaris using the Big Dipper",
        description: "Step outside or open a sky chart: find Ursa Major (Big Dipper), identify pointer stars Merak and Dubhe, and draw a line extending 5 times their distance to pinpoint Polaris (North Star).",
        category: "Astronomy",
        difficulty: "Beginner",
        duration: 15
    },
    {
        id: "astr_02",
        title: "Hertzsprung-Russell Diagram Interpretation",
        description: "Sketch an H-R diagram: label the horizontal axis (spectral class OBAFGKM / decreasing temperature) and vertical axis (luminosity). Mark the Main Sequence, Red Giants, and White Dwarfs.",
        category: "Astronomy",
        difficulty: "Intermediate",
        duration: 20
    },
    {
        id: "astr_03",
        title: "Calculate Distance to a Star via Parallax",
        description: "Proxima Centauri has an annual parallax angle p = 0.768 arcseconds. Calculate its distance in parsecs using d = 1/p, and convert this value into light-years (1 pc ≈ 3.26 ly).",
        category: "Astronomy",
        difficulty: "Beginner",
        duration: 15
    },
    {
        id: "astr_04",
        title: "Calculate Solar System Escape Velocity",
        description: "Calculate the escape velocity from Earth's orbit around the Sun v_esc = √(2GM_sun / R), where R = 1 AU (1.496 × 10¹¹ m) and M_sun = 1.989 × 10³⁰ kg.",
        category: "Astronomy",
        difficulty: "Intermediate",
        duration: 20
    },
    {
        id: "astr_05",
        title: "Identify Major Lunar Maria",
        description: "Using a lunar map or high-resolution photo, identify and note the positions of Sea of Tranquility, Ocean of Storms, Sea of Serenity, and Copernicus crater.",
        category: "Astronomy",
        difficulty: "Beginner",
        duration: 15
    },
    {
        id: "astr_06",
        title: "Kepler's Third Law Verification",
        description: "Compare Mars (semi-major axis 1.524 AU) and Jupiter (5.204 AU) using Kepler's Harmonic Law (T² = a³). Calculate their orbital periods in Earth years and compare with empirical values.",
        category: "Astronomy",
        difficulty: "Intermediate",
        duration: 20
    },
    {
        id: "astr_07",
        title: "Hubble-Lemaître Law & Age of the Universe",
        description: "Given Hubble constant H₀ ≈ 70 km/s/Mpc, convert units to reciprocal seconds and estimate the approximate age of the observable universe t ≈ 1/H₀ in billions of years.",
        category: "Astronomy",
        difficulty: "Advanced",
        duration: 30
    },
    {
        id: "astr_08",
        title: "Trace Stellar Nucleosynthesis Cycles",
        description: "Diagram the proton-proton chain reaction for stellar hydrogen fusion into helium-4, detailing positron emission, neutrino release, and gamma-ray energy yields.",
        category: "Astronomy",
        difficulty: "Advanced",
        duration: 35
    },

    // 6. Logic and puzzles (8)
    {
        id: "logic_01",
        title: "Solve the Three Switches and Three Lightbulbs Riddle",
        description: "Outside a closed room are three standard switches. Inside are three incandescent bulbs. You can enter the room only once. Devise a foolproof strategy to identify each switch's bulb.",
        category: "Logic and puzzles",
        difficulty: "Beginner",
        duration: 15
    },
    {
        id: "logic_02",
        title: "The Monty Hall Problem Simulation",
        description: "Write out the conditional probability tree for the 3-door Monty Hall problem. Prove why switching doors wins the car 2/3 of the time versus 1/3 when staying.",
        category: "Logic and puzzles",
        difficulty: "Intermediate",
        duration: 20
    },
    {
        id: "logic_03",
        title: "Knights, Knaves, and the Fork in the Road",
        description: "You encounter two guards at a fork in the road: one always tells the truth, one always lies. You do not know which is which. Formulate a single question to determine the correct path.",
        category: "Logic and puzzles",
        difficulty: "Beginner",
        duration: 15
    },
    {
        id: "logic_04",
        title: "Einstein's Zebra Puzzle Deductive Matrix",
        description: "Draw a 5x5 deductive grid to solve the famous 5-houses riddle (color, nationality, pet, drink, cigarette). Fill in the direct clues and deduce who owns the fish.",
        category: "Logic and puzzles",
        difficulty: "Advanced",
        duration: 45
    },
    {
        id: "logic_05",
        title: "The 12 Coins Balance Scale Puzzle",
        description: "You have 12 identical coins; one is counterfeit (heavier or lighter). Using a two-pan balance scale only 3 times, write a decision tree to identify the counterfeit coin and whether it is heavier or lighter.",
        category: "Logic and puzzles",
        difficulty: "Advanced",
        duration: 40
    },
    {
        id: "logic_06",
        title: "Tower of Hanoi Minimum Moves Formula",
        description: "Set up or draw a 4-disk Tower of Hanoi puzzle. Solve it physically or on paper, verify that the minimum number of moves is 2ⁿ - 1 (15 moves for n=4), and document the recursive pattern.",
        category: "Logic and puzzles",
        difficulty: "Beginner",
        duration: 20
    },
    {
        id: "logic_07",
        title: "The Blue Eyes Logic Island Riddle",
        description: "One hundred people with blue eyes live on an island. A visitor announces 'At least one person has blue eyes.' By induction, deduce what happens on night 100.",
        category: "Logic and puzzles",
        difficulty: "Advanced",
        duration: 30
    },
    {
        id: "logic_08",
        title: "Boolean Satisfiability (SAT) Truth Table",
        description: "Construct a complete truth table for the formula (A ∨ ¬B) ∧ (¬A ∨ C) ∧ (B ∨ ¬C) and determine all satisfying assignments of variables (A, B, C).",
        category: "Logic and puzzles",
        difficulty: "Intermediate",
        duration: 20
    },

    // 7. Cryptography (8)
    {
        id: "crypto_01",
        title: "Break a Caesar Cipher with Frequency Analysis",
        description: "Encrypt a short paragraph using a Caesar shift of +7. Then, count the letter frequencies (looking for 'E', 'T', 'A', 'O') to systematically deduce the key without knowing it in advance.",
        category: "Cryptography",
        difficulty: "Beginner",
        duration: 25
    },
    {
        id: "crypto_02",
        title: "Implement a Vigenère Cipher by Hand",
        description: "Choose a keyword (e.g. 'PLASMA') and encrypt a 20-word message using a 26x26 Vigenère tabula recta. Then perform the reverse decryption operation.",
        category: "Cryptography",
        difficulty: "Beginner",
        duration: 20
    },
    {
        id: "crypto_03",
        title: "Walk Through RSA Key Generation Manually",
        description: "Pick small primes p=11 and q=13. Compute n=pq, φ(n)=(p-1)(q-1). Pick public exponent e=7 (coprime to φ(n)). Find private d using the Extended Euclidean Algorithm (ed ≡ 1 mod φ(n)).",
        category: "Cryptography",
        difficulty: "Intermediate",
        duration: 35
    },
    {
        id: "crypto_04",
        title: "Diffie-Hellman Key Exchange on Paper",
        description: "Using public modulus p=23 and base g=5, choose private secret keys Alice (a=6) and Bob (b=15). Calculate public keys A and B, exchange them, and compute the identical shared secret s.",
        category: "Cryptography",
        difficulty: "Intermediate",
        duration: 25
    },
    {
        id: "crypto_05",
        title: "Compute a Merkle Tree Root Hash",
        description: "Given four string blocks L1, L2, L3, L4, compute the cryptographic hash of each leaf, hash pairwise pairs H(H(L1)+H(L2)), and compute the single root hash.",
        category: "Cryptography",
        difficulty: "Intermediate",
        duration: 25
    },
    {
        id: "crypto_06",
        title: "One-Time Pad Perfect Secrecy Demonstration",
        description: "Generate a truly random binary key string equal in length to a 4-letter ASCII message. Perform XOR encryption and demonstrate why Shannon proved it information-theoretically unbreakable.",
        category: "Cryptography",
        difficulty: "Beginner",
        duration: 20
    },
    {
        id: "crypto_07",
        title: "Birthday Attack on a 16-bit Hash",
        description: "Write a small script or calculate the combinatorics of how many random inputs must be evaluated before finding a hash collision with ≥50% probability on a 16-bit hash (≈ 2^8 = 256 inputs).",
        category: "Cryptography",
        difficulty: "Advanced",
        duration: 30
    },
    {
        id: "crypto_08",
        title: "Analyze the Enigma Rotor Stepping Mechanism",
        description: "Diagram the electrical current flow through an Enigma machine with 3 rotors (entry wheel, rotors I, II, III with turnover notches, and reflector UKW-B). Explain why a letter never encrypts to itself.",
        category: "Cryptography",
        difficulty: "Advanced",
        duration: 40
    },

    // 8. Chess (8)
    {
        id: "chess_01",
        title: "Master the Lucena Position (Rook Endgame)",
        description: "Set up the Lucena position on a chessboard: White King on e8 with pawn on e7, Black King on e6. Execute the 'bridge building' maneuver (Rf4 followed by Rd4+) to force pawn promotion.",
        category: "Chess",
        difficulty: "Intermediate",
        duration: 25
    },
    {
        id: "chess_02",
        title: "Philidor Defense Rook Endgame Drawing Technique",
        description: "Set up the Philidor position: defending King in front of opposing pawn. Maintain the 6th-rank horizontal shield with your rook until the pawn advances, then move rook to 8th rank for vertical checks.",
        category: "Chess",
        difficulty: "Intermediate",
        duration: 25
    },
    {
        id: "chess_03",
        title: "Calculate Knight's Tour on a 5x5 Board",
        description: "On a 5x5 grid, find a sequence of legal knight moves that visits every single square exactly once using Warnsdorff's heuristic (always move to the square with fewest onward choices).",
        category: "Chess",
        difficulty: "Intermediate",
        duration: 25
    },
    {
        id: "chess_04",
        title: "King and Pawn Key Squares & Opposition",
        description: "Study key squares in K+P vs K endgames. Demonstrate vertical, horizontal, and distant opposition, and verify when advancing the King guarantees pawn queening.",
        category: "Chess",
        difficulty: "Beginner",
        duration: 20
    },
    {
        id: "chess_05",
        title: "Execute the Anastasia's Mate Pattern",
        description: "Review Anastasia's checkmate motif (Knight blocking g8/g6 escape squares, Rook delivering checkmate along the open h-file after a queen sacrifice on h7). Solve 3 puzzle positions.",
        category: "Chess",
        difficulty: "Beginner",
        duration: 15
    },
    {
        id: "chess_06",
        title: "Visualize Blindfold Square Colors",
        description: "Test your mental chessboard: name 10 random squares (e.g. c4, f7, b2, g5) and instantly identify whether each square is dark or light (hint: rank+file parity).",
        category: "Chess",
        difficulty: "Beginner",
        duration: 10
    },
    {
        id: "chess_07",
        title: "Calculate a 5-Move Tactical Combination",
        description: "Find and analyze a classic game sacrifice (e.g. Lasker's double bishop sacrifice against Bauer 1889). Write down the candidate moves and calculate all defensive responses.",
        category: "Chess",
        difficulty: "Advanced",
        duration: 35
    },
    {
        id: "chess_08",
        title: "Triangulation Endgame Maneuver",
        description: "Set up a King and Pawn endgame where White wants to pass the move to Black. Execute triangulation with White King (e.g., e4 -> d4 -> e3 -> e4) to gain decisive zugzwang.",
        category: "Chess",
        difficulty: "Advanced",
        duration: 30
    },

    // 9. Memory (8)
    {
        id: "mem_01",
        title: "Construct a 10-Station Memory Palace",
        description: "Select 10 sequential landmarks along a familiar route in your home. Mentally place 10 vivid, bizarre objects in each station, and recall the list forwards and backwards.",
        category: "Memory",
        difficulty: "Beginner",
        duration: 20
    },
    {
        id: "mem_02",
        title: "Learn the Major System Phonetic Code (0-9)",
        description: "Memorize the phonetic consonant associations for digits 0-9 (0=s/z, 1=t/d, 2=n, 3=m, 4=r, 5=l, 6=j/sh, 7=k/g, 8=f/v, 9=p/b). Encode 5 three-digit numbers into peg words.",
        category: "Memory",
        difficulty: "Intermediate",
        duration: 30
    },
    {
        id: "mem_03",
        title: "Memorize 25 Digits of Pi",
        description: "Chunk 25 digits of π (3.1415926535 8979323846 26433) into rhythmic 5-digit groups or story images, practice retrieval 3 times, and write them down from memory.",
        category: "Memory",
        difficulty: "Beginner",
        duration: 15
    },
    {
        id: "mem_04",
        title: "Memorize NATO Phonetic Alphabet",
        description: "Recite the full 26-word NATO phonetic alphabet from Alpha to Zulu without hesitation. Practice spelling your full name, city, and computer model using the code.",
        category: "Memory",
        difficulty: "Beginner",
        duration: 15
    },
    {
        id: "mem_05",
        title: "Memorize a 12-Line Classic Poem",
        description: "Select a 12-line poem (e.g. Robert Frost's 'Stopping by Woods on a Snowy Evening'). Use stanza visualization and chunking to recite it aloud accurately from memory.",
        category: "Memory",
        difficulty: "Intermediate",
        duration: 25
    },
    {
        id: "mem_06",
        title: "Face-Name Association Technique",
        description: "Look at 10 unfamiliar faces in portraits or photos. Identify a distinctive physical feature on each face, link it to a vivid visual pun of their name, and test recall.",
        category: "Memory",
        difficulty: "Intermediate",
        duration: 20
    },
    {
        id: "mem_07",
        title: "Memorize a Deck of Cards Half-Stack (26 cards)",
        description: "Assign person-action-object (PAO) images to 26 playing cards. Place them along your memory palace route and attempt full sequence recall.",
        category: "Memory",
        difficulty: "Advanced",
        duration: 45
    },
    {
        id: "mem_08",
        title: "Calendar Day Calculation (Doomsday Rule)",
        description: "Learn Conway's Doomsday Rule anchor days for the current year. Practice calculating the exact day of the week for any 5 random dates in 2026 within 30 seconds each.",
        category: "Memory",
        difficulty: "Advanced",
        duration: 35
    },

    // 10. Dexterity (8)
    {
        id: "dext_01",
        title: "Learn the 3-Ball Cascade Juggling Pattern",
        description: "Take three light balls or rolled socks. Start with 2 balls doing alternating scoop-and-toss arcs, then transition into continuous 3-ball cascade throws for 15 clean catches.",
        category: "Dexterity",
        difficulty: "Intermediate",
        duration: 25
    },
    {
        id: "dext_02",
        title: "Coin Roll Across Four Knuckles",
        description: "Take a large coin (e.g. 50-cent or 2-Euro coin). Practice rolling it smoothly across the back of the fingers from index to pinky and slipping it back underneath.",
        category: "Dexterity",
        difficulty: "Intermediate",
        duration: 20
    },
    {
        id: "dext_03",
        title: "Tie 5 Essential Knots One-Handed",
        description: "Practice tying the Bowline, Square knot, Clove hitch, Figure-8, and Taut-line hitch. Time yourself tying each securely within 10 seconds.",
        category: "Dexterity",
        difficulty: "Beginner",
        duration: 20
    },
    {
        id: "dext_04",
        title: "Speed Pen Spinning (Thumb Around)",
        description: "Learn the Thumb Around pen spin: balance pen between index and middle fingers, propel with middle finger around thumb, and catch cleanly between thumb and index.",
        category: "Dexterity",
        difficulty: "Beginner",
        duration: 15
    },
    {
        id: "dext_05",
        title: "Mirror Writing with Non-Dominant Hand",
        description: "Take a pen in your non-dominant hand. Write a 3-sentence paragraph in reverse mirror-script from right to left so that it reads normally in a mirror.",
        category: "Dexterity",
        difficulty: "Intermediate",
        duration: 15
    },
    {
        id: "dext_06",
        title: "Single-Handed Card Cut (Charlier Cut)",
        description: "Hold a deck of cards in mechanic's grip in one hand. Release the bottom half with your thumb, push it up and over the top packet using your index finger, and close the cut.",
        category: "Dexterity",
        difficulty: "Beginner",
        duration: 15
    },
    {
        id: "dext_07",
        title: "Bimanual Coordination Rhythm Exercise",
        description: "Tap 3 beats with your left hand while tapping 4 beats with your right hand (3 against 4 polyrhythm: 'pass the god-damned butter'). Maintain uninterrupted for 1 minute.",
        category: "Dexterity",
        difficulty: "Advanced",
        duration: 20
    },
    {
        id: "dext_08",
        title: "Master the 3-Ball 'Over the Top' Juggling Trick",
        description: "From a steady 3-ball cascade, throw every third ball in a high reverse arc over the pattern with your right hand. Complete 10 consecutive over-the-top cycles without dropping.",
        category: "Dexterity",
        difficulty: "Advanced",
        duration: 30
    },

    // 11. Origami (8)
    {
        id: "orig_01",
        title: "Fold a Traditional Flapping Crane",
        description: "Take a square sheet of paper. Create a bird base with preliminary square and petal folds, shape the neck, head, and tail, and gently pull the chest to flap the wings.",
        category: "Origami",
        difficulty: "Beginner",
        duration: 20
    },
    {
        id: "orig_02",
        title: "Fold a Jumping Frog",
        description: "Fold a jumping frog from rectangular index card or origami paper. Form the triangular waterbomb base, pleat the hind legs with accordion folds, and test its jumping distance.",
        category: "Origami",
        difficulty: "Beginner",
        duration: 15
    },
    {
        id: "orig_03",
        title: "Construct a Sonobe Modular Polyhedron Unit",
        description: "Fold 6 identical Sonobe units with parallelograms and locking tabs. Assemble the 6 units into a rigid 3D cubic cube with zero adhesive or tape.",
        category: "Origami",
        difficulty: "Intermediate",
        duration: 30
    },
    {
        id: "orig_04",
        title: "Fold a Kawasaki Rose",
        description: "Execute Toshikazu Kawasaki's swirl rose with a central twist fold, curved petals, and 3D lock base. Carefully shape petals using a toothpick or tweezers.",
        category: "Origami",
        difficulty: "Advanced",
        duration: 45
    },
    {
        id: "orig_05",
        title: "Fold a Masu Gift Box with Fitted Lid",
        description: "Fold a traditional Japanese square Masu box from a single square sheet. Then, take a slightly larger sheet (or trim 3mm off the base sheet) and fold a snug, matching lid.",
        category: "Origami",
        difficulty: "Beginner",
        duration: 15
    },
    {
        id: "orig_06",
        title: "Fold an Origami Iris Flower",
        description: "Create a traditional 4-petaled Iris flower using a frog base with squash folds. Fluff and curl the four petals outward around the stem.",
        category: "Origami",
        difficulty: "Intermediate",
        duration: 25
    },
    {
        id: "orig_07",
        title: "Miura Fold (Space Deployable Solar Array)",
        description: "Score and fold a sheet with alternating parallelogram tessellations to create a Miura fold: a surface that expands and contracts in two directions when pulled by two opposite corners.",
        category: "Origami",
        difficulty: "Advanced",
        duration: 35
    },
    {
        id: "orig_08",
        title: "Fold an Origami Dragon",
        description: "Fold an advanced origami dragon starting from a bird base: stretch neck and tail with inside-reverse folds, crease pleated accordion wings, and shape detailed horns.",
        category: "Origami",
        difficulty: "Advanced",
        duration: 45
    },

    // 12. Language learning (8)
    {
        id: "lang_01",
        title: "Master 10 Basic Conversational Idioms in Target Language",
        description: "Select 10 authentic idioms in a language you study (e.g. Spanish, German, Japanese, French). Write their literal translations, contextual meanings, and use each in an original sentence.",
        category: "Language learning",
        difficulty: "Beginner",
        duration: 20
    },
    {
        id: "lang_02",
        title: "Conjugate 5 Irregular Verbs in Past Tenses",
        description: "Pick 5 high-frequency irregular verbs in your target language. Conjugate each across all pronouns in past tense / preterite, and formulate one question with each.",
        category: "Language learning",
        difficulty: "Intermediate",
        duration: 25
    },
    {
        id: "lang_03",
        title: "Shadow 3 Minutes of Native Speech",
        description: "Listen to a 3-minute recording of a native speaker (podcast, news clip). Shadow the speech simultaneously with a 0.5-second delay, matching pronunciation, intonation, and rhythm.",
        category: "Language learning",
        difficulty: "Intermediate",
        duration: 20
    },
    {
        id: "lang_04",
        title: "Learn and Write 10 Japanese Katakana or Greek Letters",
        description: "Learn 10 characters of an unfamiliar writing system (e.g. Katakana or Greek alphabet). Practice the correct stroke order on lined paper until written smoothly from memory.",
        category: "Language learning",
        difficulty: "Beginner",
        duration: 25
    },
    {
        id: "lang_05",
        title: "Translate a 100-Word News Abstract",
        description: "Take a short news abstract from an international newspaper. Translate it into your target language without automated translation, using only a dictionary, and analyze syntax.",
        category: "Language learning",
        difficulty: "Intermediate",
        duration: 30
    },
    {
        id: "lang_06",
        title: "Learn Subjunctive Mood Triggers",
        description: "Write down the 6 key trigger categories for subjunctive mood (wishes, emotions, doubts, necessity) in Romance or Germanic languages, and draft 2 example sentences for each trigger.",
        category: "Language learning",
        difficulty: "Advanced",
        duration: 30
    },
    {
        id: "lang_07",
        title: "Record a 2-Minute Spontaneous Monologue",
        description: "Pick a random prompt topic (e.g. 'My ideal weekend' or 'A memorable trip'). Record yourself speaking for 2 minutes continuously without pausing or looking up words.",
        category: "Language learning",
        difficulty: "Beginner",
        duration: 15
    },
    {
        id: "lang_08",
        title: "Etymological Deep-Dive into 5 Cognates",
        description: "Trace the Proto-Indo-European (PIE) roots of 5 common words (e.g. mother, night, water, star, heart) across 3 distinct language families to trace linguistic drift.",
        category: "Language learning",
        difficulty: "Advanced",
        duration: 35
    },

    // 13. Creative writing (8)
    {
        id: "crit_01",
        title: "Write a 100-Word Micro-Story (Drabble)",
        description: "Write a complete narrative with a distinct beginning, conflict, and twist ending that is exactly 100 words long (not 99, not 101). Count every word carefully.",
        category: "Creative writing",
        difficulty: "Beginner",
        duration: 20
    },
    {
        id: "crit_02",
        title: "Write a Dialogue Scene with No Dialogue Tags",
        description: "Write a tense 300-word conversation between two characters without using 'he said', 'she whispered', or any dialogue tag. Convey identity, tone, and action purely through voice and subtext.",
        category: "Creative writing",
        difficulty: "Intermediate",
        duration: 25
    },
    {
        id: "crit_03",
        title: "Write a Shakespearian Sonnet (14 Lines, ABAB CDCD EFEF GG)",
        description: "Compose a 14-line sonnet in strict iambic pentameter (da-DUM da-DUM da-DUM da-DUM da-DUM) with a thematic 'volta' (turn) occurring at line 9 and concluding with a rhyming couplet.",
        category: "Creative writing",
        difficulty: "Advanced",
        duration: 40
    },
    {
        id: "crit_04",
        title: "Sensory Description without Visual Cues",
        description: "Describe a crowded room or outdoor setting for 200 words without using any visual descriptions (no colors, no sight adjectives). Rely entirely on sound, scent, texture, and temperature.",
        category: "Creative writing",
        difficulty: "Intermediate",
        duration: 20
    },
    {
        id: "crit_05",
        title: "Write an Unreliable Narrator Confession",
        description: "Draft a 250-word monologued confession where the narrator insists they are doing something altruistic, while subtly revealing to the reader that they are acting out of selfish motives.",
        category: "Creative writing",
        difficulty: "Advanced",
        duration: 30
    },
    {
        id: "crit_06",
        title: "Six-Room Poem Structure",
        description: "Write a poem visiting six mental rooms: Room 1 (an image), Room 2 (light/shadow), Room 3 (sound), Room 4 (a question), Room 5 (feeling), Room 6 (the unexpected truth).",
        category: "Creative writing",
        difficulty: "Beginner",
        duration: 20
    },
    {
        id: "crit_07",
        title: "Flash Fiction from an Everyday Object's Perspective",
        description: "Write a 200-word narrative written from the first-person perspective of an overlooked inanimate object (e.g. an old mechanical watch, an elevator button, a lighthouse lens).",
        category: "Creative writing",
        difficulty: "Beginner",
        duration: 15
    },
    {
        id: "crit_08",
        title: "Stream of Consciousness Style Exercise",
        description: "Emulate Virginia Woolf or James Joyce: write 250 words capturing uninterrupted internal monologue responding to a single sudden stimulus (a train whistle, a dropped mug).",
        category: "Creative writing",
        difficulty: "Intermediate",
        duration: 25
    },

    // 14. General knowledge (8)
    {
        id: "gen_01",
        title: "Identify All 7 World Continents and Their Highest Peaks",
        description: "List the 7 continents and write down each continent's highest geographical summit (the 'Seven Summits': Everest, Aconcagua, Denali, Kilimanjaro, Elbrus, Vinson, Puncak Jaya).",
        category: "General knowledge",
        difficulty: "Beginner",
        duration: 15
    },
    {
        id: "gen_02",
        title: "Map the Geological Eras of Earth's History",
        description: "Sketch a timeline of Earth's four primary eons (Hadean, Archean, Proterozoic, Phanerozoic) and the three eras of the Phanerozoic (Paleozoic, Mesozoic, Cenozoic) with key evolutionary milestones.",
        category: "General knowledge",
        difficulty: "Intermediate",
        duration: 25
    },
    {
        id: "gen_03",
        title: "Explain the Breton Woods Monetary Agreement",
        description: "Summarize the 1944 Bretton Woods conference in 4 concise bullet points: establishment of the IMF and World Bank, the US dollar gold peg ($35/oz), and the 1971 Nixon shock ending convertibility.",
        category: "General knowledge",
        difficulty: "Intermediate",
        duration: 20
    },
    {
        id: "gen_04",
        title: "Identify Major World Shipping Chokepoints",
        description: "Locate and note the strategic importance of 5 vital maritime chokepoints: Strait of Malacca, Suez Canal, Panama Canal, Strait of Hormuz, and Bab el-Mandeb.",
        category: "General knowledge",
        difficulty: "Beginner",
        duration: 15
    },
    {
        id: "gen_05",
        title: "Summarize the Five Great Extinction Events",
        description: "List the 'Big Five' mass extinctions (Ordovician-Silurian, Late Devonian, Permian-Triassic 'Great Dying', Triassic-Jurassic, Cretaceous-Paleogene) and their suspected primary triggers.",
        category: "General knowledge",
        difficulty: "Intermediate",
        duration: 25
    },
    {
        id: "gen_06",
        title: "Understand the Structure of the United Nations",
        description: "Diagram the 6 principal organs of the UN: General Assembly, Security Council (including the 5 permanent veto members), Economic and Social Council, Secretariat, ICJ, and Trusteeship Council.",
        category: "General knowledge",
        difficulty: "Beginner",
        duration: 20
    },
    {
        id: "gen_07",
        title: "Trace the Evolution of the Internet Protocols",
        description: "Outline the key architectural transitions from ARPANET in 1969 to TCP/IP standardization in 1983, Tim Berners-Lee's HTTP/HTML in 1989, and modern DNS root architecture.",
        category: "General knowledge",
        difficulty: "Advanced",
        duration: 30
    },
    {
        id: "gen_08",
        title: "Explain the Mechanism of CRISPR-Cas9 Gene Editing",
        description: "Explain in 5 steps how CRISPR-Cas9 works: guide RNA (gRNA) design, PAM sequence recognition, Cas9 endonuclease double-strand DNA cleavage, and cellular repair (NHEJ vs HDR).",
        category: "General knowledge",
        difficulty: "Advanced",
        duration: 35
    },

    // 15. Fitness and strength (8)
    {
        id: "fit_01",
        title: "Master the Push-Up (10 Strict Reps)",
        description: "Perform 10 strict full-range push-ups with chest to floor, elbows at 45 degrees, core braced, and a straight body line from head to heels. Rest 60 seconds between sets; aim for 3 sets.",
        category: "Fitness and strength",
        difficulty: "Beginner",
        duration: 15
    },
    {
        id: "fit_02",
        title: "Bodyweight Squat Volume Challenge (50 Reps)",
        description: "Complete 50 air squats with hips below knees, knees tracking toes, and heels down. Break into sets as needed but minimize rest. Focus on depth and consistent tempo.",
        category: "Fitness and strength",
        difficulty: "Beginner",
        duration: 15
    },
    {
        id: "fit_03",
        title: "Plank Hold for Time (2 Minutes)",
        description: "Hold a forearm plank with elbows under shoulders, glutes and quads engaged, spine neutral, for a continuous 2 minutes. Record your time and aim to beat it.",
        category: "Fitness and strength",
        difficulty: "Beginner",
        duration: 10
    },
    {
        id: "fit_04",
        title: "Dumbbell Goblet Squat Form Clinic",
        description: "Hold a dumbbell or weighted object at chest height. Perform 3 sets of 12 goblet squats, emphasizing an upright torso, elbows inside knees, and driving through the heels.",
        category: "Fitness and strength",
        difficulty: "Intermediate",
        duration: 20
    },
    {
        id: "fit_05",
        title: "Romanian Deadlift Hip Hinge Practice",
        description: "With a light weight or broomstick, practice the hip hinge: soft knees, push hips back while keeping a flat back, feel hamstring stretch, then squeeze glutes to return. 3 sets of 10.",
        category: "Fitness and strength",
        difficulty: "Beginner",
        duration: 15
    },
    {
        id: "fit_06",
        title: "Overhead Press Stability Test",
        description: "Stand tall and press a light weight overhead from front-rack position to full lockout without arching the lower back. 3 sets of 8 reps, core braced throughout.",
        category: "Fitness and strength",
        difficulty: "Intermediate",
        duration: 15
    },
    {
        id: "fit_07",
        title: "Walking Lunge Circuit (20 Meters)",
        description: "Lunge-walk 20 meters forward with each knee nearly touching the ground, torso upright, then turn and lunge back. Repeat for 3 rounds, tracking total distance.",
        category: "Fitness and strength",
        difficulty: "Beginner",
        duration: 15
    },
    {
        id: "fit_08",
        title: "Farmer's Carry Grip & Core",
        description: "Pick up two heavy, equal weights (dumbbells, kettlebells, or filled water jugs). Walk 40 meters with shoulders down, core tight, and an upright posture. 3 rounds.",
        category: "Fitness and strength",
        difficulty: "Intermediate",
        duration: 15
    },

    // 16. Cardiovascular endurance (8)
    {
        id: "cardio_01",
        title: "Brisk 30-Minute Walk",
        description: "Walk outdoors at a brisk, conversation-pace for 30 continuous minutes. Focus on steady breathing, heel-to-toe rolling, and swinging arms naturally.",
        category: "Cardiovascular endurance",
        difficulty: "Beginner",
        duration: 35
    },
    {
        id: "cardio_02",
        title: "Jump Rope for 5 Minutes Straight",
        description: "Jump rope continuously for 5 minutes, landing softly on the balls of your feet. Pause only to untangle; count total jumps and aim to increase next time.",
        category: "Cardiovascular endurance",
        difficulty: "Beginner",
        duration: 10
    },
    {
        id: "cardio_03",
        title: "Stair Climb Intervals (10 Flights)",
        description: "Climb 10 flights of stairs at a steady pace, walking back down for recovery. Time the ascent and note how your legs and lungs feel by the final flight.",
        category: "Cardiovascular endurance",
        difficulty: "Intermediate",
        duration: 20
    },
    {
        id: "cardio_04",
        title: "2-Kilometer Steady Run",
        description: "Run or jog 2 km without stopping at a conversational pace. Focus on relaxed shoulders, mid-foot strike, and rhythmic breathing (inhale 3 steps, exhale 2).",
        category: "Cardiovascular endurance",
        difficulty: "Beginner",
        duration: 20
    },
    {
        id: "cardio_05",
        title: "High-Knee Running Drill (3 Minutes)",
        description: "Run in place driving knees to hip height for 3 minutes total, broken into 30-second bursts with 30 seconds of marching recovery between each.",
        category: "Cardiovascular endurance",
        difficulty: "Beginner",
        duration: 10
    },
    {
        id: "cardio_06",
        title: "Shadow Boxing Cardio Round",
        description: "Throw continuous punches and move your feet for one 3-minute round, as if in a boxing ring. Stay light on your toes and keep your guard up the whole time.",
        category: "Cardiovascular endurance",
        difficulty: "Beginner",
        duration: 10
    },
    {
        id: "cardio_07",
        title: "Burpee Ladder (1-10-1)",
        description: "Perform burpees in a ladder: 1 rep, rest; 2 reps, rest; ... up to 10, then back down to 1. Modify by stepping back instead of jumping if needed.",
        category: "Cardiovascular endurance",
        difficulty: "Advanced",
        duration: 20
    },
    {
        id: "cardio_08",
        title: "Rowing Machine 500-Meter Sprint",
        description: "On a rowing machine, row 500 meters as fast as you can with proper form (legs, core, arms on the drive; arms, core, legs on the recovery). Record your time.",
        category: "Cardiovascular endurance",
        difficulty: "Intermediate",
        duration: 15
    },

    // 17. Martial arts and self defense (8)
    {
        id: "martial_01",
        title: "Learn the Basic Fighting Stance & Footwork",
        description: "Adopt a balanced fighting stance: lead foot forward, weight on balls of feet, hands guarding chin. Practice stepping forward, backward, and side-to-side while returning to stance.",
        category: "Martial arts and self defense",
        difficulty: "Beginner",
        duration: 15
    },
    {
        id: "martial_02",
        title: "Throw 50 Jab-Cross Combinations",
        description: "Practice the jab-cross (1-2) combination on air or a heavy bag for 50 repetitions. Rotate hips on the cross, snap punches back to guard, and breathe on each strike.",
        category: "Martial arts and self defense",
        difficulty: "Beginner",
        duration: 15
    },
    {
        id: "martial_03",
        title: "Front Kick Technique Drill",
        description: "Practice the front snap kick: chamber the knee, extend the leg with the ball of the foot, retract quickly, and return to stance. 10 reps per leg.",
        category: "Martial arts and self defense",
        difficulty: "Beginner",
        duration: 15
    },
    {
        id: "martial_04",
        title: "Basic Escapes from Wrist Grabs",
        description: "With a partner, practice releasing yourself from single and double wrist grabs using rotation against the thumb weak point. 5 repetitions each side.",
        category: "Martial arts and self defense",
        difficulty: "Beginner",
        duration: 15
    },
    {
        id: "martial_05",
        title: "Roundhouse Kick on Heavy Bag",
        description: "Pivot on the ball of your foot, rotate hips, and strike with the shin. Perform 10 roundhouse kicks per leg on a heavy bag or target, resetting stance between each.",
        category: "Martial arts and self defense",
        difficulty: "Intermediate",
        duration: 20
    },
    {
        id: "martial_06",
        title: "Shrimp & Bridge Floor Movement (BJJ)",
        description: "On a mat, practice the hip escape (shrimp) and bridge movements used in Brazilian Jiu-Jitsu to create space from the bottom position. 1 minute each, continuous.",
        category: "Martial arts and self defense",
        difficulty: "Beginner",
        duration: 10
    },
    {
        id: "martial_07",
        title: "Parry and Counter Drill",
        description: "With a partner throwing slow punches, practice parrying (deflecting) the strike and immediately countering with a straight punch. 10 cycles per side.",
        category: "Martial arts and self defense",
        difficulty: "Intermediate",
        duration: 15
    },
    {
        id: "martial_08",
        title: "Shadow Fight Full Round (3 Minutes)",
        description: "Combine stance, footwork, punches, kicks, and slips into a continuous 3-minute shadow fight, moving in all directions and keeping a high guard throughout.",
        category: "Martial arts and self defense",
        difficulty: "Intermediate",
        duration: 10
    },

    // 18. Dance and movement (8)
    {
        id: "dance_01",
        title: "Learn the Basic Two-Step",
        description: "Put on a song with a clear beat and practice the two-step: step-touch side to side in time with the music, adding a gentle bounce and arm swing. 3 minutes continuous.",
        category: "Dance and movement",
        difficulty: "Beginner",
        duration: 10
    },
    {
        id: "dance_02",
        title: "Freestyle to One Song (3 Minutes)",
        description: "Choose one song and move freely for its entire length without stopping. Explore different levels (high, mid, low) and directions; no moves are wrong.",
        category: "Dance and movement",
        difficulty: "Beginner",
        duration: 10
    },
    {
        id: "dance_03",
        title: "Practice the Grapevine Step",
        description: "Step side, cross behind, step side, touch. Repeat the grapevine traveling left and right for 2 minutes, staying light on your feet and in rhythm.",
        category: "Dance and movement",
        difficulty: "Beginner",
        duration: 10
    },
    {
        id: "dance_04",
        title: "Body Isolation Warm-Up",
        description: "Move each body part independently: head, shoulders, ribcage, and hips in isolation circles. Spend 30 seconds per part to improve body awareness and control.",
        category: "Dance and movement",
        difficulty: "Beginner",
        duration: 10
    },
    {
        id: "dance_05",
        title: "Learn a 30-Second Choreography Phrase",
        description: "Pick a short dance tutorial online and memorize a 30-second movement phrase. Perform it from start to finish without pausing, then add your own flair.",
        category: "Dance and movement",
        difficulty: "Intermediate",
        duration: 20
    },
    {
        id: "dance_06",
        title: "Floorwork Roll Sequence",
        description: "Practice rolling safely from standing to the floor and back up in both directions (forward and backward shoulder rolls). Link three rolls together smoothly.",
        category: "Dance and movement",
        difficulty: "Intermediate",
        duration: 15
    },
    {
        id: "dance_07",
        title: "Improvisational Mirror Dance",
        description: "Stand before a mirror and imitate your own reflection in slow motion, exaggerating every gesture. Move for 2 minutes, treating your reflection as the leader.",
        category: "Dance and movement",
        difficulty: "Beginner",
        duration: 10
    },
    {
        id: "dance_08",
        title: "Spin and Turn Practice (Pirouette Prep)",
        description: "Practice spotting: fix your eyes on a single point, whip your head around at the last moment, and practice quarter, half, and full turns on one foot.",
        category: "Dance and movement",
        difficulty: "Intermediate",
        duration: 15
    },

    // 19. Yoga and flexibility (8)
    {
        id: "yoga_01",
        title: "Sun Salutation A Flow (5 Rounds)",
        description: "Move through Sun Salutation A (Mountain, Forward Fold, Half Lift, Plank, Chaturanga, Upward Dog, Downward Dog) linking breath to movement for 5 rounds.",
        category: "Yoga and flexibility",
        difficulty: "Beginner",
        duration: 15
    },
    {
        id: "yoga_02",
        title: "Hold Downward Dog for 2 Minutes",
        description: "Press into Downward-Facing Dog: hands shoulder-width, feet hip-width, hips high, heels pressing toward the floor. Breathe deeply for 2 continuous minutes.",
        category: "Yoga and flexibility",
        difficulty: "Beginner",
        duration: 10
    },
    {
        id: "yoga_03",
        title: "Seated Forward Fold Stretch",
        description: "Sit with legs extended, hinge at the hips, and reach for your feet. Hold for 2 minutes with a relaxed spine, breathing into the hamstrings and lower back.",
        category: "Yoga and flexibility",
        difficulty: "Beginner",
        duration: 10
    },
    {
        id: "yoga_04",
        title: "Cat-Cow Spinal Mobility (2 Minutes)",
        description: "On all fours, alternate between arching (Cow) and rounding (Cat) your spine with each breath. Move slowly and deliberately for 2 minutes.",
        category: "Yoga and flexibility",
        difficulty: "Beginner",
        duration: 10
    },
    {
        id: "yoga_05",
        title: "Pigeon Pose Hip Opener (2 Minutes Per Side)",
        description: "From Downward Dog, bring one knee forward behind the wrist and extend the other leg back. Hold Pigeon Pose for 2 minutes per side to open the hips.",
        category: "Yoga and flexibility",
        difficulty: "Intermediate",
        duration: 15
    },
    {
        id: "yoga_06",
        title: "Tree Pose Balance Practice",
        description: "Stand on one leg, place the opposite foot on your inner thigh or calf (not the knee), hands at heart center. Hold for 1 minute per side, eyes fixed on a point.",
        category: "Yoga and flexibility",
        difficulty: "Beginner",
        duration: 10
    },
    {
        id: "yoga_07",
        title: "Cobra and Upward Dog Strengthener",
        description: "Lie prone and lift your chest into Cobra, then press up through Upward-Facing Dog. Flow between them for 3 sets of 5 repetitions, engaging the back muscles.",
        category: "Yoga and flexibility",
        difficulty: "Beginner",
        duration: 10
    },
    {
        id: "yoga_08",
        title: "Full-Body Yin Stretch Sequence",
        description: "Hold passive stretches (butterfly, child's pose, supine twist, legs-up-wall) for 2 minutes each. Focus on relaxing the muscles and breathing into the connective tissue.",
        category: "Yoga and flexibility",
        difficulty: "Beginner",
        duration: 20
    },

    // 20. Swimming and aquatics (8)
    {
        id: "swim_01",
        title: "Tread Water for 2 Minutes",
        description: "In a pool, stay upright and afloat using a gentle eggbeater kick and sculling hands for 2 continuous minutes without touching the bottom or walls.",
        category: "Swimming and aquatics",
        difficulty: "Beginner",
        duration: 10
    },
    {
        id: "swim_02",
        title: "Front Crawl 4 Lengths",
        description: "Swim 4 lengths (100 meters) of front crawl with bilateral breathing (every 3 strokes). Focus on body rotation and a high elbow recovery.",
        category: "Swimming and aquatics",
        difficulty: "Intermediate",
        duration: 20
    },
    {
        id: "swim_03",
        title: "Kickboard Kick Set (200 Meters)",
        description: "Hold a kickboard and kick 200 meters with a flutter kick, face in or out of the water, keeping hips high and legs relatively straight from the hip.",
        category: "Swimming and aquatics",
        difficulty: "Beginner",
        duration: 20
    },
    {
        id: "swim_04",
        title: "Backstroke 2 Lengths",
        description: "Swim 2 lengths of backstroke, keeping your head still, ears in the water, and rotating shoulders with each arm recovery. Aim for smooth, even strokes.",
        category: "Swimming and aquatics",
        difficulty: "Beginner",
        duration: 15
    },
    {
        id: "swim_05",
        title: "Breaststroke Timing Drill",
        description: "Practice the breaststroke pull-breathe-kick-glide sequence for 4 lengths, emphasizing the glide phase and timing the breath with the pull.",
        category: "Swimming and aquatics",
        difficulty: "Intermediate",
        duration: 15
    },
    {
        id: "swim_06",
        title: "Deep-Water Bobbing",
        description: "In deep water, repeatedly sink to the bottom, push off, and exhale fully while surfacing. Perform 10 bobs to build comfort and breath control underwater.",
        category: "Swimming and aquatics",
        difficulty: "Beginner",
        duration: 10
    },
    {
        id: "swim_07",
        title: "Open Turn Practice at Wall",
        description: "Swim into the wall, touch with both hands, tuck, plant your feet, and push off in a streamlined position. Repeat 5 times focusing on a tight tuck.",
        category: "Swimming and aquatics",
        difficulty: "Intermediate",
        duration: 15
    },
    {
        id: "swim_08",
        title: "Float and Relax (Dead Man's Float)",
        description: "In chest-deep water, take a breath, tuck your knees, and let your body float face-down in a relaxed dead-man's float for 30 seconds, then stand calmly.",
        category: "Swimming and aquatics",
        difficulty: "Beginner",
        duration: 10
    },

    // 21. Cycling (8)
    {
        id: "bike_01",
        title: "Ride 5 Kilometers at a Steady Pace",
        description: "Cycle 5 km on a road or path at a comfortable, sustainable speed. Focus on smooth pedaling circles and shifting gears to maintain cadence.",
        category: "Cycling",
        difficulty: "Beginner",
        duration: 30
    },
    {
        id: "bike_02",
        title: "Hill Repeats (3 Climbs)",
        description: "Find a short hill and ride up it 3 times, recovering by coasting or spinning down. Stay seated for the first two climbs, stand for the third.",
        category: "Cycling",
        difficulty: "Intermediate",
        duration: 30
    },
    {
        id: "bike_03",
        title: "Emergency Stop Practice",
        description: "In an empty parking lot, accelerate to a moderate speed and practice stopping quickly using both brakes evenly, shifting weight back over the rear wheel.",
        category: "Cycling",
        difficulty: "Beginner",
        duration: 15
    },
    {
        id: "bike_04",
        title: "Single-Leg Pedaling Drill",
        description: "On a stationary bike or trainer, unclip one foot and pedal with only the other leg for 30 seconds, focusing on a smooth circular stroke. Switch legs; repeat 3x per side.",
        category: "Cycling",
        difficulty: "Beginner",
        duration: 15
    },
    {
        id: "bike_05",
        title: "Group Ride Pace Line (20 Minutes)",
        description: "Ride with others in a rotating pace line, taking short pulls at the front and tucking in behind to draft. Communicate with hand signals and callouts.",
        category: "Cycling",
        difficulty: "Intermediate",
        duration: 30
    },
    {
        id: "bike_06",
        title: "Track Stand Balance",
        description: "Practice balancing stationary on your bike (track stand) by balancing pressure on pedals and slight handlebar adjustments. Hold for 30 seconds without putting a foot down.",
        category: "Cycling",
        difficulty: "Intermediate",
        duration: 10
    },
    {
        id: "bike_07",
        title: "Cornering Drill (Figure-8)",
        description: "Ride figure-8s around two markers, leaning the bike under you while keeping your body more upright. Look through the turn and brake before the corner.",
        category: "Cycling",
        difficulty: "Beginner",
        duration: 15
    },
    {
        id: "bike_08",
        title: "Bike Safety Check (ABC Quick Check)",
        description: "Perform an Air-Brakes-Chain-Cranks-Quick release safety inspection of your bike. Inflate tires, test brakes, lubricate chain, and check wheel security before riding.",
        category: "Cycling",
        difficulty: "Beginner",
        duration: 10
    },

    // 22. Running and track (8)
    {
        id: "run_01",
        title: "400-Meter Track Lap",
        description: "Run one lap (400 m) on a track or measured loop at a controlled effort. Focus on even pacing and relaxed shoulders; record your lap time.",
        category: "Running and track",
        difficulty: "Beginner",
        duration: 15
    },
    {
        id: "run_02",
        title: "Interval Sprint Workout (8 x 30 Seconds)",
        description: "Sprint hard for 30 seconds, walk/jog for 90 seconds, and repeat 8 times. Give near-maximum effort on each sprint while maintaining form.",
        category: "Running and track",
        difficulty: "Advanced",
        duration: 30
    },
    {
        id: "run_03",
        title: "Long Slow Distance Run (5 Kilometers)",
        description: "Run 5 km at an easy, conversational pace where you can speak in full sentences. Prioritize time on feet over speed.",
        category: "Running and track",
        difficulty: "Intermediate",
        duration: 45
    },
    {
        id: "run_04",
        title: "Strides and Form Drills",
        description: "After a warm-up, run 4 x 100-meter strides (gradually accelerating to near-sprint, then decelerating) focusing on tall posture and quick foot turnover.",
        category: "Running and track",
        difficulty: "Beginner",
        duration: 20
    },
    {
        id: "run_05",
        title: "Hill Sprint Repeats (6 x Short Hill)",
        description: "Sprint up a steep hill for 10-15 seconds, walk back down for full recovery, and repeat 6 times. Drive your knees and pump your arms on each ascent.",
        category: "Running and track",
        difficulty: "Advanced",
        duration: 30
    },
    {
        id: "run_06",
        title: "Negative Split Mile",
        description: "Run one mile where each quarter-mile lap is slightly faster than the previous one. Finish strong while maintaining control throughout.",
        category: "Running and track",
        difficulty: "Intermediate",
        duration: 15
    },
    {
        id: "run_07",
        title: "Running Cadence Count",
        description: "Run for 1 minute and count how many times one foot strikes the ground. Aim for ~90 per foot (180 total). Adjust your step length, not speed, to hit the target.",
        category: "Running and track",
        difficulty: "Beginner",
        duration: 10
    },
    {
        id: "run_08",
        title: "Recovery Jog with Dynamic Stretch",
        description: "Jog easily for 15 minutes, then perform dynamic stretches (leg swings, walking lunges, high knees, butt kicks) for 5 minutes to aid recovery.",
        category: "Running and track",
        difficulty: "Beginner",
        duration: 25
    },

    // 23. Calisthenics (8)
    {
        id: "calis_01",
        title: "Hold a Hollow Body for 60 Seconds",
        description: "Lie on your back, press your lower back into the floor, lift shoulders and legs a few inches off the ground, and hold the hollow-body shape for 60 seconds.",
        category: "Calisthenics",
        difficulty: "Beginner",
        duration: 10
    },
    {
        id: "calis_02",
        title: "Pull-Up Progression (Negatives)",
        description: "Jump or step to the top of a pull-up bar, then lower yourself as slowly as possible over 5 seconds. Perform 5 negative pull-ups with full range of motion.",
        category: "Calisthenics",
        difficulty: "Beginner",
        duration: 15
    },
    {
        id: "calis_03",
        title: "Dip Station 3 Sets of 8",
        description: "Perform 3 sets of 8 parallel-bar dips, lowering until shoulders are below elbows and pressing to full lockout. Keep shoulders depressed and stable.",
        category: "Calisthenics",
        difficulty: "Intermediate",
        duration: 15
    },
    {
        id: "calis_04",
        title: "Pistol Squat Assisted Practice",
        description: "Practice single-leg squats holding onto a sturdy object for balance. Lower slowly on one leg, sit back, and stand up. 5 reps per leg.",
        category: "Calisthenics",
        difficulty: "Intermediate",
        duration: 15
    },
    {
        id: "calis_05",
        title: "L-Sit Hold on Parallettes or Floor",
        description: "Support yourself on your hands with legs extended straight out in front at hip height. Hold an L-sit for 10 seconds; repeat 3 times with rest.",
        category: "Calisthenics",
        difficulty: "Advanced",
        duration: 10
    },
    {
        id: "calis_06",
        title: "Australian Pull-Ups (Body Rows)",
        description: "Under a low bar or table, pull your chest to the bar with a straight body and heels on the ground. 3 sets of 10 reps, squeezing shoulder blades together.",
        category: "Calisthenics",
        difficulty: "Beginner",
        duration: 15
    },
    {
        id: "calis_07",
        title: "Wall Handstand Kick-Up Practice",
        description: "Kick up into a handstand against a wall, hold with a tight body for 10 seconds, and come down with control. Practice 5 kick-ups per side.",
        category: "Calisthenics",
        difficulty: "Intermediate",
        duration: 15
    },
    {
        id: "calis_08",
        title: "Muscle-Up Transition Drill",
        description: "On a low bar, practice the transition from pull to dip by pulling explosively and leaning your chest over the bar. Use a band or box for assistance. 5 attempts.",
        category: "Calisthenics",
        difficulty: "Advanced",
        duration: 20
    },

    // 24. Outdoor and adventure (8)
    {
        id: "outdoor_01",
        title: "3-Kilometer Nature Hike",
        description: "Hike 3 km on a trail or natural path, observing terrain underfoot and scenery around you. Wear sturdy shoes and carry water; leave no trace.",
        category: "Outdoor and adventure",
        difficulty: "Beginner",
        duration: 50
    },
    {
        id: "outdoor_02",
        title: "Basic Map Orientation",
        description: "With a topographic map and compass, orient the map to north using terrain features, then identify your location and a nearby landmark.",
        category: "Outdoor and adventure",
        difficulty: "Beginner",
        duration: 20
    },
    {
        id: "outdoor_03",
        title: "Rock Climbing Boulder Problem (3 Attempts)",
        description: "At a climbing gym or boulder, attempt 3 different problems (routes) focusing on foot placement, body positioning, and using your legs to push up.",
        category: "Outdoor and adventure",
        difficulty: "Intermediate",
        duration: 30
    },
    {
        id: "outdoor_04",
        title: "Build and Test a Basic Shelter Tarp",
        description: "Using a tarp, rope, and trees, rig a simple A-frame or lean-to shelter. Spend 5 minutes inside testing its coverage and stability.",
        category: "Outdoor and adventure",
        difficulty: "Beginner",
        duration: 25
    },
    {
        id: "outdoor_05",
        title: "Trail Run Intervals",
        description: "Run on uneven trail terrain for 20 minutes, alternating 1 minute of faster running with 2 minutes of easy jogging to navigate roots and rocks.",
        category: "Outdoor and adventure",
        difficulty: "Intermediate",
        duration: 30
    },
    {
        id: "outdoor_06",
        title: "Identify 5 Local Plants or Trees",
        description: "On a walk, find and identify 5 different plant or tree species using a field guide or app. Note their leaves, bark, and any distinguishing features.",
        category: "Outdoor and adventure",
        difficulty: "Beginner",
        duration: 30
    },
    {
        id: "outdoor_07",
        title: "Orienteering Course (3 Control Points)",
        description: "Set up 3 control points in a park and navigate between them using only a map and compass, recording the time to find each one.",
        category: "Outdoor and adventure",
        difficulty: "Intermediate",
        duration: 45
    },
    {
        id: "outdoor_08",
        title: "Sunset/Sunrise Outdoor Meditation",
        description: "Sit quietly outdoors at sunrise or sunset for 10 minutes, observing light changes, temperature, sounds, and your breath without distraction.",
        category: "Outdoor and adventure",
        difficulty: "Beginner",
        duration: 15
    },

    // 25. Team sports (8)
    {
        id: "team_01",
        title: "Basketball Shooting Form (25 Shots)",
        description: "Take 25 shots from different spots near the basket, focusing on consistent form: knees bent, elbow under the ball, follow-through with wrist snap.",
        category: "Team sports",
        difficulty: "Beginner",
        duration: 20
    },
    {
        id: "team_02",
        title: "Soccer Juggling (100 Touches)",
        description: "Keep a soccer ball in the air using feet, thighs, and chest for 100 total touches without letting it hit the ground. Track your personal best.",
        category: "Team sports",
        difficulty: "Intermediate",
        duration: 15
    },
    {
        id: "team_03",
        title: "Volleyball Passing Drill",
        description: "With a partner or against a wall, practice forearm passes (bumps) setting the ball to a target. Aim for 20 consecutive controlled passes.",
        category: "Team sports",
        difficulty: "Beginner",
        duration: 15
    },
    {
        id: "team_04",
        title: "Relay Sprint Handoffs",
        description: "With a partner, practice sprint baton handoffs over 4 x 50-meter relays, focusing on passing the baton within the exchange zone at full speed.",
        category: "Team sports",
        difficulty: "Intermediate",
        duration: 20
    },
    {
        id: "team_05",
        title: "Defensive Slides (Basketball)",
        description: "Slide laterally in a defensive stance (knees bent, arms wide) across the width of a court or marked area for 1 minute without crossing your feet.",
        category: "Team sports",
        difficulty: "Beginner",
        duration: 10
    },
    {
        id: "team_06",
        title: "Keep-Away Possession Game",
        description: "Play 3-v-1 keep-away in a small grid: 3 attackers maintain possession while 1 defender tries to steal. Play for 5 minutes, rotating the defender.",
        category: "Team sports",
        difficulty: "Intermediate",
        duration: 20
    },
    {
        id: "team_07",
        title: "Free Throw Routine Practice",
        description: "Develop and repeat a consistent free throw routine (dribble, breath, shoot) for 10 attempts, tracking how many you make and adjusting your form.",
        category: "Team sports",
        difficulty: "Beginner",
        duration: 15
    },
    {
        id: "team_08",
        title: "Small-Sided Game (15 Minutes)",
        description: "Play a 3-v-3 or 4-v-4 small-sided game (soccer, basketball, or ultimate) for 15 minutes with continuous play and minimal stoppages.",
        category: "Team sports",
        difficulty: "Intermediate",
        duration: 25
    },

    // 26. Racket sports (8)
    {
        id: "racket_01",
        title: "Forehand Groundstroke Rally (20 Shots)",
        description: "With a partner or wall, hit 20 consecutive forehand groundstrokes in a rally, focusing on early preparation, contact in front, and full follow-through.",
        category: "Racket sports",
        difficulty: "Beginner",
        duration: 15
    },
    {
        id: "racket_02",
        title: "Serve Toss Consistency (20 Tosses)",
        description: "Practice your service toss 20 times without hitting the ball, aiming to place it in the same spot every time slightly in front and to the side.",
        category: "Racket sports",
        difficulty: "Beginner",
        duration: 10
    },
    {
        id: "racket_03",
        title: "Backhand Slice Practice",
        description: "Hit 15 backhand slice shots, keeping the racket face open and cutting under the ball to produce backspin and a low trajectory.",
        category: "Racket sports",
        difficulty: "Intermediate",
        duration: 15
    },
    {
        id: "racket_04",
        title: "Volley Reflex Drill at Net",
        description: "Stand at the net and volley 15 quick balls fed to you, punching the ball forward with a short backswing and firm wrist.",
        category: "Racket sports",
        difficulty: "Intermediate",
        duration: 10
    },
    {
        id: "racket_05",
        title: "Footwork Shadow Drill (3 Minutes)",
        description: "Move side-to-side and forward-backward in an athletic stance mimicking match movement for 3 minutes, always returning to a ready position.",
        category: "Racket sports",
        difficulty: "Beginner",
        duration: 10
    },
    {
        id: "racket_06",
        title: "Overhead Smash Technique",
        description: "Practice the overhead smash motion 10 times: turn sideways, racket back, contact high in front, and snap through the ball. Use a partner feeding lobs.",
        category: "Racket sports",
        difficulty: "Intermediate",
        duration: 15
    },
    {
        id: "racket_07",
        title: "Drop Shot Touch Drill",
        description: "Hit 10 soft drop shots that land just over the net, using a gentle grip and abbreviated swing to place the ball precisely.",
        category: "Racket sports",
        difficulty: "Intermediate",
        duration: 10
    },
    {
        id: "racket_08",
        title: "Mini Match Tiebreak (First to 7)",
        description: "Play a tiebreak to 7 points against a partner, serving alternately and calling your own lines. Play honestly and focus on placement over power.",
        category: "Racket sports",
        difficulty: "Intermediate",
        duration: 20
    },

    // 27. Balance and coordination (8)
    {
        id: "balance_01",
        title: "Single-Leg Stand with Eyes Closed (30 Seconds)",
        description: "Stand on one leg with your eyes closed and hold for 30 seconds. Switch legs. Use a wall nearby for safety if you begin to wobble.",
        category: "Balance and coordination",
        difficulty: "Beginner",
        duration: 10
    },
    {
        id: "balance_02",
        title: "Agility Ladder Quick Feet",
        description: "Run through an agility ladder (or draw one with chalk) using one-foot-in-each-square, two-foot hops, and lateral shuffles for 3 minutes total.",
        category: "Balance and coordination",
        difficulty: "Beginner",
        duration: 10
    },
    {
        id: "balance_03",
        title: "Slackline Balance Attempt",
        description: "Walk across a slackline or a low narrow beam, using your arms for balance. Aim to cross its full length without stepping off.",
        category: "Balance and coordination",
        difficulty: "Intermediate",
        duration: 15
    },
    {
        id: "balance_04",
        title: "Cone Weave (Carioca and Shuffle)",
        description: "Set 5 cones in a line and weave through them using carioca (crossing feet laterally) and side shuffles. Complete 6 round trips.",
        category: "Balance and coordination",
        difficulty: "Beginner",
        duration: 10
    },
    {
        id: "balance_05",
        title: "BOSU or Pillow Balance Squat",
        description: "Stand on an unstable surface (BOSU trainer, pillow, or folded towel) and perform 10 slow bodyweight squats without touching the ground with your hands.",
        category: "Balance and coordination",
        difficulty: "Intermediate",
        duration: 10
    },
    {
        id: "balance_06",
        title: "Juggle Three Balls for 30 Catches",
        description: "Practice the 3-ball cascade and count consecutive clean catches until you reach 30 without a drop. Take breaks as needed.",
        category: "Balance and coordination",
        difficulty: "Intermediate",
        duration: 20
    },
    {
        id: "balance_07",
        title: "Single-Leg Romanian Deadlift",
        description: "Balance on one leg, hinge at the hips, and extend the other leg behind you while reaching toward the ground. 8 reps per leg with control.",
        category: "Balance and coordination",
        difficulty: "Intermediate",
        duration: 10
    },
    {
        id: "balance_08",
        title: "Proprioception Ankle Alphabet",
        description: "Standing on one leg, trace the alphabet in the air with your free foot, moving slowly through each letter. Switch legs and repeat A-Z.",
        category: "Balance and coordination",
        difficulty: "Beginner",
        duration: 10
    },

    // 28. Breathwork and recovery (8)
    {
        id: "breath_01",
        title: "Box Breathing (5 Minutes)",
        description: "Inhale 4 seconds, hold 4, exhale 4, hold 4; repeat for 5 minutes. Use this to calm the nervous system and improve focus.",
        category: "Breathwork and recovery",
        difficulty: "Beginner",
        duration: 10
    },
    {
        id: "breath_02",
        title: "Cold Exposure Shower Finish",
        description: "End your shower with 2 minutes of cold water, focusing on slow, controlled breathing rather than gasping. Note your body's response afterward.",
        category: "Breathwork and recovery",
        difficulty: "Intermediate",
        duration: 10
    },
    {
        id: "breath_03",
        title: "Foam Rolling Full Body",
        description: "Spend 10 minutes foam rolling major muscle groups (calves, quads, IT band, back, lats), pausing on tender spots for 30 seconds each.",
        category: "Breathwork and recovery",
        difficulty: "Beginner",
        duration: 15
    },
    {
        id: "breath_04",
        title: "Alternate Nostril Breathing (Nadi Shodhana)",
        description: "Using your thumb and ring finger, alternate closing nostrils while breathing in one side and out the other for 5 minutes. Keep the breath smooth and even.",
        category: "Breathwork and recovery",
        difficulty: "Beginner",
        duration: 10
    },
    {
        id: "breath_05",
        title: "Sauna Session with Hydration",
        description: "Spend 10-15 minutes in a sauna or steam room, drinking water before and after. Practice slow breathing and observe your heart rate settle.",
        category: "Breathwork and recovery",
        difficulty: "Beginner",
        duration: 20
    },
    {
        id: "breath_06",
        title: "4-7-8 Relaxation Breath (8 Cycles)",
        description: "Inhale for 4 seconds, hold for 7, exhale forcefully for 8. Repeat 8 cycles to downshift into a relaxed state before bed or after stress.",
        category: "Breathwork and recovery",
        difficulty: "Beginner",
        duration: 10
    },
    {
        id: "breath_07",
        title: "Diaphragmatic Breathing Practice",
        description: "Lie on your back with one hand on your chest and one on your belly. Breathe so only the belly hand moves for 5 minutes, training diaphragmatic breathing.",
        category: "Breathwork and recovery",
        difficulty: "Beginner",
        duration: 10
    },
    {
        id: "breath_08",
        title: "Post-Workout Static Stretch Routine",
        description: "After any physical activity, hold static stretches for hamstrings, quads, chest, and shoulders for 30 seconds each, breathing deeply into the stretch.",
        category: "Breathwork and recovery",
        difficulty: "Beginner",
        duration: 15
    },

    // 29. Gymnastics (8)
    {
        id: "gym_01",
        title: "Forward and Backward Roll",
        description: "On a mat, perform 5 smooth forward rolls and 5 backward rolls, tucking your chin and rolling along your spine rather than your neck.",
        category: "Gymnastics",
        difficulty: "Beginner",
        duration: 10
    },
    {
        id: "gym_02",
        title: "Cartwheel on Both Sides",
        description: "Practice cartwheels leading with each hand, keeping arms straight and legs in a V-shape overhead. Land facing the direction you started.",
        category: "Gymnastics",
        difficulty: "Beginner",
        duration: 15
    },
    {
        id: "gym_03",
        title: "Handstand Hold Against Wall",
        description: "Kick into a handstand against a wall with a tight, hollow body. Hold for 30 seconds, then come down with control. Repeat 3 times.",
        category: "Gymnastics",
        difficulty: "Intermediate",
        duration: 15
    },
    {
        id: "gym_04",
        title: "Bridge / Backbend Hold",
        description: "Lie on your back, place hands by your ears, and press up into a bridge. Hold for 20 seconds, pushing shoulders over wrists and hips high.",
        category: "Gymnastics",
        difficulty: "Beginner",
        duration: 10
    },
    {
        id: "gym_05",
        title: "Round-Off Rebound",
        description: "Practice a round-off: cartwheel into a snap-down, landing on both feet and immediately rebounding upward. Perform 5 clean round-offs.",
        category: "Gymnastics",
        difficulty: "Intermediate",
        duration: 15
    },
    {
        id: "gym_06",
        title: "Front Support on Parallettes",
        description: "Support your body on parallettes or sturdy bars with arms straight, shoulders depressed, and legs together. Hold a front support for 30 seconds.",
        category: "Gymnastics",
        difficulty: "Intermediate",
        duration: 10
    },
    {
        id: "gym_07",
        title: "Cast to Handstand Drill (on Bar)",
        description: "From a hanging support on a low bar, cast your hips up and extend to a handstand position with a spotter or band assistance. 3 attempts.",
        category: "Gymnastics",
        difficulty: "Advanced",
        duration: 20
    },
    {
        id: "gym_08",
        title: "Split Stretch Routine",
        description: "Warm up thoroughly, then work toward front and straddle splits. Hold each split stretch for 60 seconds, breathing deeply and never forcing pain.",
        category: "Gymnastics",
        difficulty: "Beginner",
        duration: 20
    }
];

function getCategories() {
    return CATEGORIES;
}

function getDifficulties() {
    return DIFFICULTIES;
}

function getInitialChallenges() {
    return INITIAL_CHALLENGES;
}


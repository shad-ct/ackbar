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
    "General knowledge"
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


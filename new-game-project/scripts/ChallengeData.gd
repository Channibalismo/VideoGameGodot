class_name ChallengeData
extends RefCounted
## Coding-challenge objectives, one easy/medium/hard trio per lesson.
## Grading in coding_challenges.gd strips all whitespace before comparing,
## so exact indentation/line breaks in the player's answer don't matter \u2014
## only the actual code tokens and their order do.

const CHALLENGES := {
	1: { # Introduction to Computer Programming
		"easy": {"objective": "Print the text Hello, World! to the console.", "answer": "System.out.println(\"Hello, World!\");"},
		"medium": {"objective": "Declare an int variable named steps and set it to 5.", "answer": "int steps = 5;"},
		"hard": {"objective": "Declare a String variable named language set to \"Java\".", "answer": "String language = \"Java\";"},
	},
	2: { # Data Types and Variables
		"easy": {"objective": "Declare a double named price set to 9.99.", "answer": "double price = 9.99;"},
		"medium": {"objective": "Declare a boolean named isActive set to true.", "answer": "boolean isActive = true;"},
		"hard": {"objective": "Declare a char named grade set to 'A'.", "answer": "char grade = 'A';"},
	},
	3: { # Output / print and println
		"easy": {"objective": "Print \"Java\" without starting a new line.", "answer": "System.out.print(\"Java\");"},
		"medium": {"objective": "Print the number 42 on its own line.", "answer": "System.out.println(42);"},
		"hard": {"objective": "Print \"Score: \" joined with the number 100, on one line.", "answer": "System.out.println(\"Score: \" + 100);"},
	},
	4: { # Arithmetic Operators
		"easy": {"objective": "Declare an int named total equal to 4 + 5.", "answer": "int total = 4 + 5;"},
		"medium": {"objective": "Declare an int named mod equal to 10 % 3.", "answer": "int mod = 10 % 3;"},
		"hard": {"objective": "Declare an int named area equal to 6 * 7.", "answer": "int area = 6 * 7;"},
	},
	5: { # Logical Operators
		"easy": {"objective": "Declare a boolean named result equal to a AND b.", "answer": "boolean result = a && b;"},
		"medium": {"objective": "Declare a boolean named result equal to a OR b.", "answer": "boolean result = a || b;"},
		"hard": {"objective": "Declare a boolean named result equal to NOT a.", "answer": "boolean result = !a;"},
	},
	6: { # If Statements
		"easy": {"objective": "Write an if statement that prints \"Positive\" when x > 0.", "answer": "if (x > 0) { System.out.println(\"Positive\"); }"},
		"medium": {"objective": "Write an if/else: print \"Positive\" if x > 0, otherwise print \"Non-positive\".", "answer": "if (x > 0) { System.out.println(\"Positive\"); } else { System.out.println(\"Non-positive\"); }"},
		"hard": {"objective": "Write if/else if/else: print \"Zero\" if x == 0, \"Positive\" if x > 0, else \"Negative\".", "answer": "if (x == 0) { System.out.println(\"Zero\"); } else if (x > 0) { System.out.println(\"Positive\"); } else { System.out.println(\"Negative\"); }"},
	},
	7: { # Switch Statements
		"easy": {"objective": "Write a switch on day with case 1 printing \"Monday\" and a default printing \"Unknown\".", "answer": "switch (day) { case 1: System.out.println(\"Monday\"); break; default: System.out.println(\"Unknown\"); }"},
		"medium": {"objective": "Add case 2 printing \"Tuesday\" to that same switch on day.", "answer": "switch (day) { case 1: System.out.println(\"Monday\"); break; case 2: System.out.println(\"Tuesday\"); break; default: System.out.println(\"Unknown\"); }"},
		"hard": {"objective": "Write a switch on grade: case 'A' prints \"Excellent\", case 'B' prints \"Good\", default prints \"Keep trying\".", "answer": "switch (grade) { case 'A': System.out.println(\"Excellent\"); break; case 'B': System.out.println(\"Good\"); break; default: System.out.println(\"Keep trying\"); }"},
	},
	8: { # Loops
		"easy": {"objective": "Write a for loop that prints i for i from 0 to 4.", "answer": "for (int i = 0; i < 5; i++) { System.out.println(i); }"},
		"medium": {"objective": "Write a while loop that prints count while count < 3, starting at 0.", "answer": "while (count < 3) { System.out.println(count); count++; }"},
		"hard": {"objective": "Write a do-while loop that prints count at least once while count < 3.", "answer": "do { System.out.println(count); count++; } while (count < 3);"},
	},
	9: { # Methods
		"easy": {"objective": "Write a void method named greet with no parameters that prints \"Hello\".", "answer": "void greet() { System.out.println(\"Hello\"); }"},
		"medium": {"objective": "Write an int method named doubleIt that takes an int n and returns n * 2.", "answer": "int doubleIt(int n) { return n * 2; }"},
		"hard": {"objective": "Write an int method named add that takes two ints a and b and returns their sum.", "answer": "int add(int a, int b) { return a + b; }"},
	},
	10: { # Arrays
		"easy": {"objective": "Declare an int array named nums containing 1, 2, and 3.", "answer": "int[] nums = {1, 2, 3};"},
		"medium": {"objective": "Declare an int named first equal to the first element of nums.", "answer": "int first = nums[0];"},
		"hard": {"objective": "Declare an int named size equal to the length of nums.", "answer": "int size = nums.length;"},
	},
	11: { # Strings
		"easy": {"objective": "Declare an int named len equal to the length of the String name.", "answer": "int len = name.length();"},
		"medium": {"objective": "Declare a String named first3 equal to the first 3 characters of name.", "answer": "String first3 = name.substring(0, 3);"},
		"hard": {"objective": "Declare a String named greeting equal to \"Hello, \" joined with name.", "answer": "String greeting = \"Hello, \" + name;"},
	},
	12: { # File Manipulation
		"easy": {"objective": "Declare a Scanner named reader that reads from a File named file.", "answer": "Scanner reader = new Scanner(file);"},
		"medium": {"objective": "Declare a FileWriter named writer for a file named \"log.txt\".", "answer": "FileWriter writer = new FileWriter(\"log.txt\");"},
		"hard": {"objective": "Close the Scanner named reader.", "answer": "reader.close();"},
	},
	13: { # GUI
		"easy": {"objective": "Declare a JButton named button with the text \"Click Me\".", "answer": "JButton button = new JButton(\"Click Me\");"},
		"medium": {"objective": "Declare a JFrame named frame with the title \"My App\".", "answer": "JFrame frame = new JFrame(\"My App\");"},
		"hard": {"objective": "Add an ActionListener named listener to button.", "answer": "button.addActionListener(listener);"},
	},
}

const LESSON_NAMES := [
	"1. Introduction to Computer Programming",
	"2. Data Types and Variables",
	"3. Output / print and println",
	"4. Arithmetic Operators",
	"5. Logical Operators",
	"6. If Statements",
	"7. Switch Statements",
	"8. Loops",
	"9. Methods",
	"10. Arrays",
	"11. Strings",
	"12. File Manipulation",
	"13. GUI",
]

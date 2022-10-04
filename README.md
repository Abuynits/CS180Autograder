# Autograder v 0.1
## Description
- A Perl script that reads test cases (input and output) and runs your java code on them
- Paste your i/o examples exactly as they appear in vocareum
- Separate each test case by a `\n` in your document of choice
## Configuration
- you only need the `grade.pl` file
- The rest of the files in the repo act as an example to test it
- Copy the `grader.pl` file to your project directory
- give execution access via `chmod +x grader.pl`
- run with `./grader.pl YOUR_UNIQUE_INPUT_FILES`
## File Layout
- All of your code should be done in the src folder.
- The first time the program is run, it will create a `classes` folder in your directory
## Inputs to Program
`./grader.pl input.txt output.txt mainJavaclass.java additional`

**input.txt**: file containing your test cases with inputs and outputs

**output.txt**: file that will contain the output of the program

**mainJavaClass.java**: file that contains the main method of your program

    ex: MyMainClass.java

**additional** a `-` seperated list of all supporting java files

    ex: Ball.java-Player.java



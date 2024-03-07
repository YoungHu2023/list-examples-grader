CPATH='.;./lib/hamcrest-core-1.3.jar;./lib/junit-4.13.2.jar'

rm -rf student-submission
rm -rf grading-area

mkdir grading-area

git clone $1 student-submission
echo 'Finished cloning'

if [ ! -f "student-submission/ListExamples.java" ]
then
    echo "Error: ListExamples.java not found in the student submission."
    exit 1
fi

echo "No Error: ListExamples.java found in the student submission."

cp -r lib grading-area/
cp student-submission/ListExamples.java grading-area/
cp TestListExamples.java grading-area/

cd grading-area
javac -cp $CPATH TestListExamples.java ListExamples.java
if [ $? -ne 0 ]; 
then
    echo "Error: Compilation failed."
    exit 1
fi

echo "No Error: Compilation successful."


java -cp $CPATH org.junit.runner.JUnitCore TestListExamples > junit-output.txt
lastline=$(grep "Tests run:" "junit-output.txt")
tests=$(echo $lastline | grep -o -E 'Tests run: [0-9]+' | awk '{print $NF}')
failures=$(echo $lastline | grep -o -E 'Failures: [0-9]+' | awk '{print $NF}')
successes=$((tests - failures))

if [[ -z "$lastline" ]]
then
    echo "you got full score!"
else
    echo $lastline
    echo "Your score is $successes / $tests"
fi

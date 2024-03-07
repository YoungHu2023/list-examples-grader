CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'

rm -rf student-submission
rm -rf grading-area

mkdir grading-area

git clone $1 student-submission
echo 'Finished cloning'

if [ ! -f "student-submission/ListExamples.java" ]; then
    echo "Error: ListExamples.java not found in the student submission."
    exit 1
fi

echo "No Error: ListExamples.java found in the student submission."

cp -r lib grading-area/
cp student-submission/ListExamples.java grading-area/
cp TestListExamples.java grading-area/

cd grading-area
javac -cp $CPATH TestListExamples.java ListExamples.java
if [ $? -ne 0 ]; then
    echo "Error: Compilation failed."
    exit 1
fi

echo "No Error: Compilation successful."


java -cp $CPATH org.junit.runner.JUnitCore TestListExamples  
lastline=$(cat grading-area/junit-output.txt | tail -n 2 | head -n 1)
tests=$(echo $lastline | awk -F '[, ]' '{print $6}')
successes=$((tests - failures))

echo "Your score is $successes / $tests"

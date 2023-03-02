CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'
CPATHWINDOWS=".;../lib/junit-4.13.2.jar;../lib/hamcrest-core-1.3.jar"

rm -rf student-submission
git clone $1 student-submission
echo 'Finished cloning'

cd student-submission
if [[ -f ListExamples.java ]]
    then
        cp ../TestListExamples.java ../student-submission/

        javac -cp $CPATHWINDOWS *.java 2>error.txt

        if [[ -f ListExamples.class ]]
            then
                FILTER=`grep "filter" ListExamples.java`
                if [[ $FILTER != *"static List<String> filter(List<String>"* ]]
                    then
                        echo 'Filter method not found or improperly implemented'
                        exit
                fi
                MERGE=`grep "merge" ListExamples.java`
                if [[ $MERGE != *"static List<String> merge(List<String>"* ]]
                    then
                        echo 'Merge method not found or improperly implemented'
                        exit
                fi

                java -cp $CPATHWINDOWS org.junit.runner.JUnitCore TestListExamples > testResults.txt

                if [[ $? == "0" ]]
                    then
                        echo "All tests have passed"

                    else
                        cat testResults.txt
                        echo "One or more tests failed"
                fi
            else
                echo "Compile error"
        fi
    else
        echo "ListExamples.java not found"
fi
exit
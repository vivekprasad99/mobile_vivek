# Variable to track if any command failed
ANY_ERROR=false

# Function to run commands for dart analyzer, flutter analyzer and test code coverage
analyze_and_test() {
    # Run Dart analyzer
    output=$(melos run dart-analyze)

    # Check if there were any errors during analysis
    if [ $? -ne 0 ]; then
        echo "Error: Dart analyze failed. Aborting."
        echo "$output"
        ANY_ERROR=true
        #exit 1
    fi

    # Run Flutter analyzer
    # output=$(flutter analyze --no-fatal-infos --no-fatal-warnings)
    output=$(melos run flutter-analyze)

    # Check if there were any errors during analysis
    if [ $? -ne 0 ]; then
        echo "Error: Flutter analyze failed. Aborting."
        echo "$output"
        ANY_ERROR=true
        #exit 1
    fi

    # Run Flutter tests with coverage
    # flutter test --coverage
    melos exec flutter test --coverage
    melos run checkCoverage

    # Check if there were any errors during test coverage
    if [ $? -ne 0 ]; then
        echo "Error: Flutter test coverage failed. Aborting."
        ANY_ERROR=true
    fi
}

# Run Dart analyzer and test coverage for main directory
echo "Analyzing main..."
analyze_and_test

# Check if any command failed
if [ "$ANY_ERROR" = true ]; then
    echo "At least one command failed. Please check the output for details."
    exit 1
fi

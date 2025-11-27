#!/bin/bash
# Script to fix line endings for shell scripts
# Run this once in WSL/Linux if you get "bad interpreter" errors

echo "Fixing line endings for shell scripts..."

# Fix shell scripts
for file in run_tests.sh quick_test.sh; do
    if [ -f "$file" ]; then
        echo "  Fixing $file..."
        sed -i 's/\r$//' "$file"
        chmod +x "$file"
    fi
done

echo "Done! Line endings fixed."
echo "You can now run: ./run_tests.sh or ./quick_test.sh"

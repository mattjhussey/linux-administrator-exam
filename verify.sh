# Create a variable to store results
results=""

# Question 1.1
# Check kernel file content with default value if file is missing
kernel_value=$(cat /opt/course/1/kernel 2>/dev/null || echo "")
if [ "$kernel_value" = "kernel_placeholder" ]; then
    results="${results}1.1 1 "
fi

# Question 1.2
# Check ip_forward file content with default value if file is missing
ip_forward_value=$(cat /opt/course/1/ip_forward 2>/dev/null || echo "")
if [ "$ip_forward_value" = "ip_forward_placeholder" ]; then
    results="${results}1.2 1 "
fi

# Question 1.3
# Check timezone file content with default value if file is missing
timezone_value=$(cat /opt/course/1/timezone 2>/dev/null || echo "")
if [ "$timezone_value" = "timezone_placeholder" ]; then
    results="${results}1.3 1 "
fi

# Find and store the question results pattern
results_pattern='questionResults = {[^}]*};'
results_output='questionResults = {'$results'};'
# Replace the result object in questions.html with the actual results
sed -i "s|$results_pattern|$results_output|g" questions.html
#!/bin/bash

output_file="/home/jaak/Desktop/Uni/Masterarbeit/newEvaluation/WalletLibrary/transientWalletLibrary_1.evaluation"

# Clear the output file if it exists
> $output_file

# Initialize variables to sum the times
total_real=0
total_user=0
total_sys=0

# Initialize arrays to store individual times
real_times=()
user_times=()
sys_times=()

# Total number of executions
total_executions=10

for i in {1..10}; do
    # Calculate and display progress percentage
    progress=$(awk -v i=$i -v total=$total_executions 'BEGIN {printf "%.0f", (i / total) * 100}')
    echo "Progress: ${progress}%" 
    
    echo "Execution $i:" >> $output_file
    
    # Capture the time output
    exec_output=$( { time /home/jaak/Desktop/Uni/Masterarbeit/mythril_implementation/mythril-transient-storage/myth analyze -c "$(cat /home/jaak/Desktop/Uni/Masterarbeit/mythril_implementation/mythril-transient-storage/bytecodes/WalletLibrary/transientWalletLibrary_1.bytecode)" -t 1; } 2>&1 )
    echo "$exec_output" >> $output_file
    
    # Extract real, user, and sys times
    real_time=$(echo "$exec_output" | grep real | awk '{print $2}')
    user_time=$(echo "$exec_output" | grep user | awk '{print $2}')
    sys_time=$(echo "$exec_output" | grep sys | awk '{print $2}')
    
    # Convert times to seconds for calculation
    real_sec=$(echo $real_time | awk -Fm '{print $1*60+$2}')
    user_sec=$(echo $user_time | awk -Fm '{print $1*60+$2}')
    sys_sec=$(echo $sys_time | awk -Fm '{print $1*60+$2}')
    
    # Add times to totals
    total_real=$(awk -v t1=$total_real -v t2=$real_sec 'BEGIN {print t1 + t2}')
    total_user=$(awk -v t1=$total_user -v t2=$user_sec 'BEGIN {print t1 + t2}')
    total_sys=$(awk -v t1=$total_sys -v t2=$sys_sec 'BEGIN {print t1 + t2}')
    
    # Store individual times
    real_times+=($real_sec)
    user_times+=($user_sec)
    sys_times+=($sys_sec)
    
    echo "------------------------" >> $output_file
done

# Calculate means
mean_real=$(awk -v total=$total_real 'BEGIN {print total / 10}')
mean_user=$(awk -v total=$total_user 'BEGIN {print total / 10}')
mean_sys=$(awk -v total=$total_sys 'BEGIN {print total / 10}')

# Calculate variances
var_real=$(awk -v mean=$mean_real -v times="${real_times[*]}" 'BEGIN {
    split(times, a);
    sum_sq_diff = 0;
    for (i in a) {
        sum_sq_diff += (a[i] - mean) ^ 2;
    }
    print sum_sq_diff / (length(a) - 1);
}')

var_user=$(awk -v mean=$mean_user -v times="${user_times[*]}" 'BEGIN {
    split(times, a);
    sum_sq_diff = 0;
    for (i in a) {
        sum_sq_diff += (a[i] - mean) ^ 2;
    }
    print sum_sq_diff / (length(a) - 1);
}')

var_sys=$(awk -v mean=$mean_sys -v times="${sys_times[*]}" 'BEGIN {
    split(times, a);
    sum_sq_diff = 0;
    for (i in a) {
        sum_sq_diff += (a[i] - mean) ^ 2;
    }
    print sum_sq_diff / (length(a) - 1);
}')

# Output means and variances to file
echo "Mean real time: $mean_real seconds" >> $output_file
echo "Mean user time: $mean_user seconds" >> $output_file
echo "Mean sys time: $mean_sys seconds" >> $output_file
echo "Variance of real time: $var_real" >> $output_file
echo "Variance of user time: $var_user" >> $output_file
echo "Variance of sys time: $var_sys" >> $output_file

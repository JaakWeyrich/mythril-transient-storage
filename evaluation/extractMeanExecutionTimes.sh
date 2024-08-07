#!/bin/bash

# Define the order of directories and files based on the table
declare -a contracts=(
    "BECToken/BECToken_1.evaluation"
    "BECToken/BECToken_2.evaluation"
    "BECToken/BECToken_3.evaluation"
    "BECToken/BECToken_4.evaluation"
    "BECToken/BECToken_5.evaluation"
    "BECToken/BECToken_6.evaluation"
    "BECToken/BECToken_7.evaluation"
    "WalletLibrary/WalletLibrary_1.evaluation"
    "WalletLibrary/WalletLibrary_2.evaluation"
    "calls/calls_1.evaluation"
    "etherstore/etherstore_1.evaluation"
    "hashforether/hashforether_1.evaluation"
    "killbilly/killbilly_1.evaluation"
    "origin/origin_1.evaluation"
    "returnvalue/returnvalue_1.evaluation"
    "rubixi/rubixi_1.evaluation"
    "suicide/suicide_1.evaluation"
    "timelock/timelock_1.evaluation"
)

declare -a transient_contracts=(
    "BECToken/transientBECToken_1.evaluation"
    "BECToken/transientBECToken_2.evaluation"
    "BECToken/transientBECToken_3.evaluation"
    "BECToken/transientBECToken_4.evaluation"
    "BECToken/transientBECToken_5.evaluation"
    "BECToken/transientBECToken_6.evaluation"
    "BECToken/transientBECToken_7.evaluation"
    "WalletLibrary/transientWalletLibrary_1.evaluation"
    "WalletLibrary/transientWalletLibrary_2.evaluation"
    "calls/transientcalls_1.evaluation"
    "etherstore/transientetherstore_1.evaluation"
    "hashforether/transienthashforether_1.evaluation"
    "killbilly/transientkillbilly_1.evaluation"
    "origin/transientorigin_1.evaluation"
    "returnvalue/transientreturnvalue_1.evaluation"
    "rubixi/transientrubixi_1.evaluation"
    "suicide/transientsuicide_1.evaluation"
    "timelock/transienttimelock_1.evaluation"
)

# Process each file in the defined order
for i in "${!contracts[@]}"; do
    normal_file="${contracts[$i]}"
    transient_file="${transient_contracts[$i]}"

    if [[ -f "$normal_file" && -f "$transient_file" ]]; then
        # Extract the mean real time and variance using grep and awk
        normal_mean_real_time=$(grep "Mean real time" "$normal_file" | awk '{print $4}')
        normal_variance_real_time=$(grep "Variance of real time" "$normal_file" | awk '{print $5}')
        transient_mean_real_time=$(grep "Mean real time" "$transient_file" | awk '{print $4}')
        transient_variance_real_time=$(grep "Variance of real time" "$transient_file" | awk '{print $5}')

        # Calculate the differences using awk
        mean_difference=$(awk "BEGIN {print $normal_mean_real_time - $transient_mean_real_time}")
        variance_difference=$(awk "BEGIN {print $normal_variance_real_time - $transient_variance_real_time}")

        # Calculate the percentage difference using awk
        percentage_difference=$(awk "BEGIN {printf \"%.2f\", (($normal_mean_real_time - $transient_mean_real_time) / $normal_mean_real_time) * 100}")
        if awk "BEGIN {exit !($transient_mean_real_time < $normal_mean_real_time)}"; then
            percentage_difference="- $percentage_difference %"
        else
            percentage_difference="+ $percentage_difference %"
        fi

        # Print the filename and the extracted values
        echo "----------------------------------------"
        echo "Files: $normal_file & $transient_file"
        echo "Normal Mean real time:     $normal_mean_real_time seconds"
        echo "Normal Variance:           $normal_variance_real_time"
        echo "Transient Mean real time:  $transient_mean_real_time seconds"
        echo "Transient Variance:        $transient_variance_real_time"
        echo "Mean difference:           $mean_difference seconds"
        echo "Percentage difference:     $percentage_difference"
        echo "----------------------------------------"
    fi
done

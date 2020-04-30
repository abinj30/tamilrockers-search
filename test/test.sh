#!/bin/bash

fail () {
   echo $1
   echo "Test $2 failed❌"
   exit 1
}

MALAYALAM=("virus-2019" "malayalam" 25 "https://tamilrockers.ws/index.php/topic/113733-virus-2019-malayalam-720p-hdrip-dd-51-x264-14gb-esubs/")
TAMIL=("petta-2019" "tamil" 15 "https://tamilrockers.ws/index.php/topic/104722-petta-2019tamil-1080p-proper-hd-avc-dd-51-x264-25gb-esubs/")
TEST_SUITES=(
  MALAYALAM[@]
  TAMIL[@]
)

# Loop and print it.  Using offset and length to extract values
COUNT=${#TEST_SUITES[@]}
for ((i=0; i<$COUNT; i++))
do
   SEARCH_STRING=${!TEST_SUITES[i]:0:1}
   LANGUAGE=${!TEST_SUITES[i]:1:1}
   EXPECTED_COUNT=${!TEST_SUITES[i]:2:1}
   SAMPLE_MATCH=${!TEST_SUITES[i]:3:1}
   OUTPUT_FILE="out_$LANGUAGE.txt"

   tamilrockers-search -s $SEARCH_STRING -l $LANGUAGE -o $OUTPUT_FILE
   ACTUAL_COUNT=$(wc -l $OUTPUT_FILE | awk '{ print $1 }')

   if [[ $ACTUAL_COUNT -lt $EXPECTED_COUNT ]]; then
      echo "Expected Count: $EXPECTED_COUNT. Actual Count: $ACTUAL_COUNT"
      fail "Count Validation Failed❌" $LANGUAGE
   else
      echo "Count Validation passed✅"
   fi

   echo "Matching Sample: $SAMPLE_MATCH"
   if grep -Fxq "$SAMPLE_MATCH" $OUTPUT_FILE
   then
      echo "Sample Matching Passed✅"
   else
      echo fail "Sample Matching Failed❌" $LANGUAGE
   fi

   echo "Test $LANGUAGE passed✅"

done



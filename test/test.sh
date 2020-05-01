#!/bin/bash

fail () {
   echo "$1"
   echo "Test $2 failed❌"
   exit 1
}

HINDI=("karwaan-2018" "hindi" 4 "https://tamilrockers.ws/index.php/topic/80873-karwaan-2018hindi-hq-hdrip-x264-250mb-esubs/")
MALAYALAM=("virus-2019" "malayalam" 25 "https://tamilrockers.ws/index.php/topic/113733-virus-2019-malayalam-720p-hdrip-dd-51-x264-14gb-esubs/")
TAMIL=("petta-2019" "tamil" 15 "https://tamilrockers.ws/index.php/topic/104722-petta-2019tamil-1080p-proper-hd-avc-dd-51-x264-25gb-esubs/")
KANNADA=("pailwaan-2019" "kannada" 5 "https://tamilrockers.ws/index.php/topic/121467-pailwaan-2019proper-kannada-720p-hdrip-x264-dd-51-14gb-esubs/")
TELUGU=("ala-vaikunthapurramloo-2020" "telugu" 20 "https://tamilrockers.ws/index.php/topic/128870-ala-vaikunthapurramloo-2020-telugu-720p-hdrip-ac3-51-x264-14gb-esubs/")
ENGLISH=("bloodshot-2020" "english" 7 "https://tamilrockers.ws/index.php/tutorials/article/20357-bloodshot-2020-english-720p-bdrip-x264-1gb-esubs/")
TEST_SUITES=(
  HINDI[@]
  MALAYALAM[@]
  TAMIL[@]
  KANNADA[@]
  TELUGU[@]
  ENGLISH[@]
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

   tamilrockers-search -s "$SEARCH_STRING" -l "$LANGUAGE" -o "$OUTPUT_FILE"
   ACTUAL_COUNT=$(wc -l "$OUTPUT_FILE" | awk '{ print $1 }')

   echo "Expected Count >= $EXPECTED_COUNT. Actual Count: $ACTUAL_COUNT"
   if [[ $ACTUAL_COUNT -lt $EXPECTED_COUNT ]]; then
      fail "Count Validation Failed❌" $LANGUAGE
   else
      echo "Count Validation passed✅"
   fi

   echo "Matching Sample: $SAMPLE_MATCH"
   if grep -Fxq "$SAMPLE_MATCH" "$OUTPUT_FILE"
   then
      echo "Sample Matching Passed✅"
   else
      fail "Sample Matching Failed❌" "$LANGUAGE"
   fi

   echo "Test $LANGUAGE passed✅"

done
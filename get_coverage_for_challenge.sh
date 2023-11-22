#!/usr/bin/env bash

set -x
set -e
set -u
set -o pipefail

SCRIPT_CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

CHALLENGE_ID=$1
RUBY_TEST_REPORT_CSV_FILE="${SCRIPT_CURRENT_DIR}/coverage/results.csv"
RUBY_CODE_COVERAGE_INFO="${SCRIPT_CURRENT_DIR}/coverage.tdl"
RUBY_CODE_COVERAGE_CACHE="${SCRIPT_CURRENT_DIR}/.resultset.json"

exitAfterNoCoverageReportFoundError() {
  echo "No coverage report was found"
  exit -1
}

if [[ ! -e "${SCRIPT_CURRENT_DIR}/lib/solutions/${CHALLENGE_ID}" ]]; then
   echo "" > ${RUBY_CODE_COVERAGE_INFO}
   echo "The provided CHALLENGE_ID: '${CHALLENGE_ID}' isn't valid, aborting process..."
   exit 1
fi

( cd ${SCRIPT_CURRENT_DIR} && \
    bundle install && \
    bundle exec rake 1>&2 || true )

[[ -e "${RUBY_CODE_COVERAGE_INFO}" ]] && rm -f "${RUBY_CODE_COVERAGE_INFO}" && rm -f "${RUBY_CODE_COVERAGE_CACHE}"

if [[ -f "${RUBY_TEST_REPORT_CSV_FILE}" ]]; then
    TOTAL_COVERAGE_PERCENTAGE=$(( 0 ))
    NUMBER_OF_FILES=$(( 0 ))

    COVERAGE_OUTPUT=$(grep "lib\/solutions\/${CHALLENGE_ID}\/" ${RUBY_TEST_REPORT_CSV_FILE} || true)
    RELEVANT_LINES_COL=4
    LINES_COVERED_COL=5

    if [[ ! -z "${COVERAGE_OUTPUT}" ]]; then
        RELEVANT_LINES=$(echo "${COVERAGE_OUTPUT}" | cut -d "," -f${RELEVANT_LINES_COL} | jq -s 'add')
        LINES_COVERED=$(echo "${COVERAGE_OUTPUT}" | cut -d "," -f${LINES_COVERED_COL} | jq -s 'add')
        TOTAL_COVERAGE_PERCENTAGE=$(( (${LINES_COVERED} * 100) / ${RELEVANT_LINES} ))
    fi

    echo $((TOTAL_COVERAGE_PERCENTAGE)) > ${RUBY_CODE_COVERAGE_INFO}
    cat ${RUBY_CODE_COVERAGE_INFO}
    exit 0
else
    exitAfterNoCoverageReportFoundError
fi

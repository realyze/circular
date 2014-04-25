set -e

TMP_DIR='/tmp/circular/'
REPO=${1}
ORG=${2}
REPO_URL="git@github.com:${ORG}/${REPO}.git"

mkdir -p ${TMP_DIR}
cd ${TMP_DIR}

rm -rf ${REPO}

# Clone the repo.
git clone ${REPO_URL}
cd ./${REPO}

git checkout ${CIRCLE_BRANCH}
LAST_COMMIT_TS=$(git rev-list --format=format:'%at' --max-count=1 `git rev-parse HEAD` | tail -1)
CURRENT_TS=`date +"%s"`
TS_DIFF=`expr ${CURRENT_TS} - ${LAST_COMMIT_TS}`

echo "Last commit to ${CIRCLE_BRANCH} detected ${TS_DIFF} seconds ago."

BRANCH="test-smoke-${CIRCLE_BRANCH}"

if [ "${TS_DIFF}" -ge "3600" ]; then
  git checkout -b ${BRANCH}
fi

echo "pushing branch ${BRANCH} to ${REPO_URL}..."
git push --set-upstream origin ${BRANCH}

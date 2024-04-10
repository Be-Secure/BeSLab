#!/bin/bash
#
#   Copyright 2023 BeS Community
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
BESLAB_LOG_FILE=$HOME/.besman/beslab_log

__beslab_createlogfile () {
   
   if [ ! -z $1 ];then
     export BESLAB_LOG_FILE="$1"
   else
     export BESLAB_LOG_FILE=$BLIMAN_LOG_FILE	   
   fi
   
   [[ ! -f $BESLAB_LOG_FILE ]] && touch $BESLAB_LOG_FILE
}

__beslab_log() {
   datetime=$(date)
   while IFS= read -r line; do
     echo "$datetime : $line" >> $BESLAB_LOG_FILE
   done
}

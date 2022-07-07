#!/bin/bash

# Filtering valid URLs
echo "Filtering valid docs URLs..."
cat docs.txt | grep '^docs.google.com/\(spreadsheets/d/\|document/d/\|file/d/\|folder/d/\|forms/d/\|presentation/d/\)' > /tmp/doc-clean.txt 
echo -e "\n\nFiltering valid drive URLs..."
cat drive.txt | grep '^drive.google.com/\(drive/folders/\|file/d\|file/d/\)' > /tmp/drive-clean.txt

# Collecting working URLs
echo -e "\n\nCollecting working doc URLs..."
cat /tmp/doc-clean.txt | httpx -title -rl 10 -status-code -follow-redirects -no-color | grep '200]' | awk -F' ' '{print $1}' | tee /tmp/doc-urls.txt
echo -e "\n\nCollecting working drive URLs..."
cat /tmp/drive-clean.txt | httpx -title -rl 10 -status-code -follow-redirects -no-color | grep '200]' | awk -F' ' '{print $1}' | tee /tmp/drive-urls.txt

# Pausing process for 5min
echo "Pausing process for 5min to avoid getting banned from google..."
sleep 5m

# Saving webpages and collecting important info - doc
echo -e "\n\nSaving webpages and collecting important info of docs.txt"
cat /tmp/doc-urls.txt | while read -r link; 
    do curl -s $link > /tmp/doc-curl.txt
        # Collecting titles
        title=`cat /tmp/doc-curl.txt | grep -o '<title>[^"]*</title>' | sed -e 's/<\/\?title>//g'`
        # Collecting important strings
        cat /tmp/doc-curl.txt | stuff=`cat /tmp/doc-curl.txt | grep -i '\(password\|credentials\|token\|api\|secret\|key\)'`
        stuff=$(echo $stuff | tr '[:upper:]' '[:lower:]')
            if [[ "$stuff" == *"password"* || "$title" == *"password"* ]]; then
                pwd="Password";
            else
                pwd=" ";
            fi
            if [[ "$stuff" == *"credentials"* || "$title" == *"credentials"* ]]; then
                cre="Credentials";
            else
                cre=" ";
            fi
            if [[ "$stuff" == *"token"* || "$title" == *"token"* ]]; then
                tok="Token";
            else
                tok=" ";
            fi
            if [[ "$stuff" == *"api"* || "$title" == *"api"* ]]; then
                api="Api";
            else
                api=" ";
            fi
            if [[ "$stuff" == *"secret"* || "$title" == *"secret"* ]]; then
                sec="Secret";
            else
                sec=" ";
            fi
            if [[ "$stuff" == *"key"* || "$title" == *"key"* ]]; then
                key="Key";
            else
                key=" ";
            fi
        echo -e "\nTitle: $title" >> doc-result.txt & echo "Link: $link" >> doc-result.txt & echo "Link or Web Page contains: $pwd $cre $tok $api $sec $key" >> doc-result.txt
        sleep 5s
    done
echo -e "\n\nYou can now check doc-result.txt"

# Pausing process for 5min
echo "Pausing process for 5min to avoid getting banned from google..."
sleep 5m

# Saving webpages and collecting important info - drive
echo -e "\n\nSaving webpages and collecting important info of drive.txt"
cat /tmp/drive-urls.txt | while read -r link; 
    do curl -s $link > /tmp/drive-curl.txt
        # Collecting titles
        title=`cat /tmp/drive-curl.txt | grep -o '<title>[^"]*</title>' | sed -e 's/<\/\?title>//g'`
        # Collecting important strings
        cat /tmp/doc-curl.txt | stuff=`cat /tmp/doc-curl.txt | grep -i '\(password\|credentials\|token\|api\|secret\|key\)'`
        stuff=$(echo $stuff | tr '[:upper:]' '[:lower:]')
            if [[ "$stuff" == *"password"* || "$title" == *"password"* ]]; then
                pwd="Password";
            else
                pwd=" ";
            fi
            if [[ "$stuff" == *"credentials"* || "$title" == *"credentials"* ]]; then
                cre="Credentials";
            else
                cre=" ";
            fi
            if [[ "$stuff" == *"token"* || "$title" == *"token"* ]]; then
                tok="Token";
            else
                tok=" ";
            fi
            if [[ "$stuff" == *"api"* || "$title" == *"api"* ]]; then
                api="Api";
            else
                api=" ";
            fi
            if [[ "$stuff" == *"secret"* || "$title" == *"secret"* ]]; then
                sec="Secret";
            else
                sec=" ";
            fi
            if [[ "$stuff" == *"key"* || "$title" == *"key"* ]]; then
                key="Key";
            else
                key=" ";
            fi
        echo -e "\nTitle: $title" >> drive-result.txt & echo "Link: $link" >> drive-result.txt & echo "Link or Web Page contains: $pwd $cre $tok $api $sec $key" >> drive-result.txt
        sleep 5s
    done
echo -e "\n\nYou can now check drive-result.txt"

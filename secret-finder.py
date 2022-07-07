# Install the following by running ->  python3 -m pip install requests
import requests
# Importing the grep / regex library
import re
# This is how python perform bash commands
import os

proxyList = []
validProxies = []
cleanDocsUrls = []
cleanDrivesUrls = []

# Disabling python request warnings cause they're pretty ugly :3
requests.packages.urllib3.disable_warnings()

# Loading and Checking for valid proxies (you can add as many proxies as you want to the proxy-list.txt file)
with open('proxy-list.txt', 'r') as f:
    proxies = f.readlines()
    for proxy in proxies:
        # Adding nothing replacing newlines
        proxy = proxy.replace("\n", "")
        try:
            gResponse = requests.get("https://google.com", proxies={
                "http": f"http://{proxy}",
                "https": f"http://{proxy}",
            }, verify=False)
            if (gResponse.status_code == 200):
                validProxies.append(proxy)
                print(f"[DEBUG] Valid proxy found - [{proxy}]")
        except:
            # Add code here to run when a invalid proxy is detected
            pass
print(f"[+] Found {len(validProxies)} valid proxies!")


os.system("mkdir doc")
os.system("mkdir drive")


# Parsing for valid doc URLs
with open('docs.txt', 'r') as f:
    content = f.readlines()
    regexFilter = "^docs.google.com/(spreadsheets/d/|document/d/|file/d/|folder/d/|forms/d/|presentation/d/)"
    for line in content:
        if (re.search(regexFilter, line)):
            # Adding nothing replacing newlines
            cleanDocsUrls.append("https://" + line.replace("\n", ""))

print(f"Found {len(cleanDocsUrls)} clean Google Docs URLs.")

# Parsing for valid drive URLs
with open('drive.txt', 'r') as f:
    content = f.readlines()
    regexFilter = "^drive.google.com/(drive/folders/|file/d|file/d/)"
    for line in content:
        if (re.search(regexFilter, line)):
            # Adding nothing replacing newlines
            cleanDrivesUrls.append("https://" + line.replace("\n", ""))

print(f"Found {len(cleanDrivesUrls)} clean Google Drive URLs.")


# Saving files of doc URLs
count = 0
for url in cleanDocsUrls:
    # Selecting a random proxy
    try:
        cProxy = validProxies[count % len(validProxies)]

        httpResponse = requests.get(url, verify=False, proxies={
            "http": f"http://{cProxy}",
            "https": f"http://{cProxy}"
        })
        print(f"[+] Got {httpResponse.status_code} CODE | {url} | {cProxy}")
        if (httpResponse.status_code == 200):
            filename = "doc/" + url.replace("?","").replace("&", "").replace("https://", "").replace("/", "-") + ".txt"
            with open(filename, 'w') as f:
                f.write(httpResponse.content.decode())
        count = count + 1
    except:
        # Add code here to handle failed URLS
        count = count + 1


# Saving files of drive URLs
count = 0
for url in cleanDocsUrls:
    # Selecting a random proxy
    try:
        cProxy = validProxies[count % len(validProxies)]

        httpResponse = requests.get(url, verify=False, proxies={
            "http": f"http://{cProxy}",
            "https": f"http://{cProxy}"
        })
        print(f"[+] Got {httpResponse.status_code} CODE | {url} | {cProxy}")
        if (httpResponse.status_code == 200):
            filename = "drive/" + url.replace("?","").replace("&", "").replace("https://", "").replace("/", "-") + ".txt"
            with open(filename, 'w') as f:
                f.write(httpResponse.content.decode())
        count = count + 1
    except:
        # Add code here to handle failed URLS
        count = count + 1


# Running Nuclei
os.system("nuclei -target doc -o nuclei-doc.log")
os.system("nuclei -target drive -o nuclei-drive.log")

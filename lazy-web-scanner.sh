#!/bin/bash
clear
# Function to generate a random color
random_color() {
  colors=("31" "32" "33" "34" "35" "36")
  echo -e "\033[${colors[$(($RANDOM % 6))]}m"
}

# Generate the box with random-colored *
for i in {1..4}; do
  for j in {1..70}; do
    if [ $i -eq 1 ] || [ $i -eq 4 ] || [ $j -eq 1 ] || [ $j -eq 70 ]; then
      echo -en "$(random_color)*\033[0m"
    else
      echo -en "$(random_color).\033[0m"
    fi
  done
  echo ""
done

# Print "LAZY WEB SCANNER" 
echo -e "\n$(random_color)      LAZY WEB SCANNER\033[0m"

# Generate the box with random-colored *
for i in {1..4}; do
  for j in {1..70}; do
    if [ $i -eq 1 ] || [ $i -eq 4 ] || [ $j -eq 1 ] || [ $j -eq 70 ]; then
      echo -en "$(random_color)*\033[0m"
    else
      echo -en "$(random_color).\033[0m"
    fi
  done
  echo ""
done

# Set color variables
YELLOW='\033[1;33m'
NC='\033[0m'

# Ask user for target IP or URL
echo -e "${YELLOW}Please enter the IP address or URL of the target:${NC}"
read target

# Create folder with name target-data-time
folder_name=$(date '+%Y-%m-%d_%H-%M-%S')-$target
mkdir $folder_name
cd $folder_name

# Ping target and check if it's alive
echo -e "${YELLOW}Pinging target...${NC}"
if ping -c 1 $target &> /dev/null
then
    echo -e "${YELLOW}Ping successful. Host alive. Let's go!${NC}"
else
    echo -e "${YELLOW}Seems like the host is dead or ICMP is blocked. Let me try to figure this out...${NC}"
    nmap -Pn -T4 --max-rate=25000 $target -oN nmap-ping-sweep.txt &> /dev/null
fi

# Perform a full nmap scan with service/version detection and all scripts (except bruteforce)
echo -e "${YELLOW}Starting Nmap full scan...Give me 10 minutes and I'll collect some info. Drink a cup of tea and chill out${NC}"
nmap -A -O -Pn -sV -T4 --max-rate=25000 --script "(not intrusive and not brute) or default" $target -oN nmap-full-target.txt &> /dev/null

# Check if there are any open web ports and start Nikto scan if available
if grep -q -E "80|443|8000|8080|8443" nmap-full-target.txt
then
    echo -e "${YELLOW}Starting Nikto full scan...${NC}"
    nikto -h $target -output nikto-target.txt  &> /dev/null
fi

# Check if there are any open HTTP/HTTPS ports and start nmap script scan with web groups
if grep -q -E "80|443|8000|8080|8443" nmap-full-target.txt
then
    echo -e "${YELLOW}Starting Nmap script scan with web groups...${NC}"
    nmap -Pn -T4 --max-rate=25000 --script "(http* or ssl*) and not (brute or dos or external)" $target -oN nmap-script-web-target.txt &> /dev/null

    # Check if port 443 is open and start SSLyze scan if available
    if grep -q "443/tcp" nmap-full-target.txt
    then
        echo -e "${YELLOW}Starting SSLyze scan...${NC}"
        sslyze --regular $target:443 | tee sslyze-target.txt
    fi

    # Start dirb scan for each open web port
    echo -e "${YELLOW}Starting dirb scan for each open web port...${NC}"
    grep -E "80|443|8000|8080|8443" nmap-full-target.txt | cut -d "/" -f 1 | xargs -I{} sh -c "dirb http://$target:{} -l -w -S -o dirb-scan-{}.txt" &> /dev/null
fi

# Say goodbye
echo -e "${YELLOW}All done! Search all reports in the folder $folder_name Goodbye.${NC}"
